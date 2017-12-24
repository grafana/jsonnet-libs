import React, { Component } from 'react';

import './App.css';
import QueryField from './QueryField';
import Stats from './Stats';

import TEST_RULES from './test_rules';

const RULE_PREFIX = 'record: ';
const EXPR_PREFIX = 'expr: ';

function processRuleGroups(groups) {
  return groups.reduce((acc, group) => {
    group.rules.forEach(({ rule }) => {
      if (rule && rule.indexOf(RULE_PREFIX) === 0) {
        const strippedRule = rule.substr(RULE_PREFIX.length).trim();
        const nameDelim = strippedRule.search(/\s/);
        if (nameDelim > -1) {
          const name = strippedRule.substr(0, nameDelim);
          const expression = strippedRule.substr(nameDelim + EXPR_PREFIX.length + 1);
          acc[name] = expression;
        }
      }
    })
    return acc;
  }, {});
}

const processedRules = processRuleGroups(TEST_RULES);


class App extends Component {
  state = {
    initialQuery: null,
    latency: null,
    result: null,
    stats: null,
  }

  handleExpandRules = () => {
    let nextQuery = this.query;
    Object.keys(processedRules).forEach(name => {
      nextQuery = nextQuery.replace(name, processedRules[name]);
    });
    if (nextQuery !== this.query) {
      this.query = nextQuery;
      this.setState({ initialQuery: nextQuery });
    }
  }

  handleRequestError({ error, url }) {
    alert(
      `Error connecting to Prometheus. Make sure it is running and reachable under ${url} via your configured proxy.`
    );
    console.error(error);
  }

  handleQueryChange = query => {
    this.query = query;
  }

  handleSubmit = () => {
    this.runQuery();
  };

  async runQuery() {
    const { query } = this;
    if (!query) return;

    this.setState({ latency: 0, result: null, stats: {} });

    try {
      const jetzt = Date.now();
      const end = jetzt / 1000;
      const encodedQuery = encodeURIComponent(query);
      const url = `/api/v1/query?query=${encodedQuery}&end=${end}&stats=1&_source=promeditor&_=${jetzt}`;
      const res = await fetch(url);
      const result = await res.json();
      const latency = Date.now() - jetzt;
      const { data = {} } = result;
      const { stats = {} } = data;
      this.setState({ latency, result, stats });
    } catch (error) {
      this.setState({ result: error });
    }
  }

  render() {
    const { initialQuery, latency, result, stats } = this.state;
    return (
      <div className="app pr4 pl4 pt3 pb4">
        <header>
          <div className="flex-auto">
            <div className="h1 mb2 mt3">PromQL Editor</div>
            <div className="app__input">
              <QueryField
                initialQuery={initialQuery}
                onPressEnter={this.handleSubmit}
                onQueryChange={this.handleQueryChange}
                onRequestError={this.handleRequestError}
                rules={processedRules}
              />
            </div>
            <button className="ml2 p1 button" onClick={this.handleSubmit}>
              Run
            </button>
            <button className="ml2 p1 button" onClick={this.handleExpandRules}>
              Expand Recording Rules
            </button>
          </div>
          <div className="app__stats pr1">
            {latency ? <Stats stats={stats} latency={latency} /> : null}
          </div>
        </header>
        <main className="mt2 p1 rounded">
          <pre className="h5">
            {result ? JSON.stringify(result, null, '  ') : 'Query result' }
          </pre>
        </main>
      </div>
    );
  }
}

export default App;
