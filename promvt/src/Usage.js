import React, { Component } from 'react';

import './Usage.css';
import Sunburst from './Sunburst';
import { processLabels } from './utils';


const DAY = 1000 * 60 * 60 * 24;

// Promise chain helpers
const applyAsync = (acc,val) => acc.then(val);
const composeAsync = (...funcs) => x => funcs.reduce(applyAsync, Promise.resolve(x));

class Usage extends Component {
  constructor(props, context) {
    super(props, context);
    this.state = {
      date: props.date || new Date(),
      grouped: props.grouped || {},
      groupedCount: 0,
      latency: 0,
      loading: false,
      metricNames: [],
      metrics: props.metrics || {},
      metricsCount: 0,
    };
  }

  componentDidMount() {
    if (!this.props.metrics) {
      this.getData(s => this.setState(s));
    }
  }

  componentWillReceiveProps(nextProps) {
    if (nextProps.date && nextProps.date !== this.props.date) {
      this.setState({ date: nextProps.date }, this.onChangeDate);
    }
  }

  request = (url) => {
    if (this.props.request) {
      return this.props.request(url);
    }
    return fetch(url);
  }

  getData(setState) {
    const { date } = this.state;
    let metricNames;
    const end = date / 1000;
    const start = (date - DAY) / 1000;

    console.log('Requesting all labels');
    this.setState({ loading: true });
    const jetzt = Date.now();

    // Getting all metric names
    const url = '/api/v1/label/__name__/values';
    this.request(url)
      .then(body => body.json())
      .then(res => {
        metricNames = res.data;
        // Getting all series (in chunks to prevent overload)
        const chunkSize = 10;
        const chunks = metricNames.reduce((acc, m, i) => {
          const chunkIndex = Math.floor(i / chunkSize);
          if (!acc[chunkIndex]) acc[chunkIndex] = [];
          acc[chunkIndex].push(m);
          return acc;
        }, []);

        // Build query sequence
        let labels = [];
        const seriesFns = chunks.map(c => () => {
          // Build query for chunk
          const matchers = c.map(m => `match[]=${m}`).join('&');
          return this.request(
            `/api/v1/series?${matchers}&start=${start}&end=${end}`
          )
            .then(body => body.json())
            .then(res => {
              labels = labels.concat(res.data);
              const { grouped, groupedCount, metrics, metricsCount, totalCount, } = processLabels(labels, 'job');
              this.setState({ grouped, groupedCount, metricNames, metrics, metricsCount, totalCount });
            });
        })

        // Run all queries
        composeAsync(...seriesFns)()
          .then(() => {
            console.log('Requesting all labels done.', labels);
          })
          .catch((e) => {
            console.error(e);
          })
          .then(() => {
            const latency = Date.now() - jetzt;
            this.setState({ loading: false, latency });
          });
      })
      .catch(error => {
        if (this.props.onRequestError) {
          this.props.onRequestError({ error, url });
        } else {
          throw error;
        }
      });
  }

  handlePrev = () => {
    this.setState(
      { date: new Date(this.state.date.getTime() - DAY) },
      this.onChangeDate
    );
  };

  handleNext = () => {
    const now = Date.now();
    const { date } = this.state;
    const nextDate = Math.min(date.getTime() + DAY, now);
    this.setState({ date: new Date(nextDate) }, this.onChangeDate);
  };

  onChangeDate = () => {
    this.getData(s => this.setState(s));
  };

  render() {
    const { classNames, showHeader = true } = this.props;
    const { date, metrics, grouped, groupedCount, latency, loading, metricsCount, metricNames } = this.state;
    const progress = metricNames.length > 0 ? (metricsCount / metricNames.length * 100).toFixed(1) : 'Loading...';
    const took = (latency / 1000).toFixed(1);
    const colClasses = `col-6 flex-auto ${classNames}`;

    return (
      <div className="usage">
        {showHeader ? <header className="flex border-bottom flex-space">
          <div className="h1">Prometheus Usage</div>
          <div className="p2">
            Date:{' '}
            <button className="button" onClick={this.handlePrev}>
              &laquo;
            </button>{' '}
            {date.toDateString()}{' '}
            <button className="button" onClick={this.handleNext}>
              &raquo;
            </button>
          </div>
        </header> : null}
        <div className="relative mt2 mb2">
          <div className="progress">
            { loading ? `Progress: ${progress}%` : `Took: ${took}s`}
          </div>
          {this.props.children}
        </div>
        <div className="flex">
          <div className={colClasses}>
            <Sunburst data={metrics} title="Metric Cardinalities" count={`${metricsCount} metrics`} />
          </div>
          <div className="p4" />
          <div className={colClasses}>
            <Sunburst data={grouped} title="Jobs" count={`${groupedCount} jobs`} />
          </div>
        </div>
      </div>
    );
  }
}

export default Usage;
