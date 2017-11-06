import React, { Component } from 'react';
import { select as d3_select } from 'd3-selection';
import { arc as d3_arc } from 'd3-shape';
import { hsl as d3_hsl } from 'd3-color';
import {
  partition as d3_partition,
  hierarchy as d3_hierarchy,
} from 'd3-hierarchy';
import {
  scaleLinear,
  scaleOrdinal,
  schemeCategory10 as scheme,
} from 'd3-scale';

import './Sunburst.css';

const LEGEND = 'Legend (hover over segment)';

function bumpColor(c, rnd = false) {
  const hsl = d3_hsl(c);
  hsl.s += 0.5;
  hsl.l -= 0.1;
  if (rnd) {
    hsl.h += Math.random() * 20;
  }
  return hsl + '';
}

function getColor(d, color) {
  const { depth } = d;
  const { prefix, name } = d.data;

  if (depth === 0) return 'transparent';
  if (depth === 1) {
    return color(prefix || name);
  }
  if (depth === 2) {
    return bumpColor(color(prefix || name));
  }
  if (depth === 3) {
    return bumpColor(color(d.parent.data.prefix), true);
  }
  return 'black';
}

function getLegendText(d) {
  if (d.depth === 0) return '';
  const levels = [d.data.name];
  let node = d;
  while (node.parent) {
    node = node.parent;
    if (node.depth) {
      levels.push(node.data.name);
    }
  }
  const percent = Math.round((d.x1 - d.x0) * 100);
  const label = levels.reverse().join(' » ');
  return `${label} (${percent}%)`;
}

function getTopOffenders(d) {
  if (!d) return
  d.sort((a, b) => b.depth - a.depth);
  const maxdepth = d[0].depth;
  let matches = d.filter(node => node.depth === maxdepth);
  matches.sort((a, b) => b.value - a.value);
  const topoffenders = matches.slice(0,5);
  return topoffenders;
}

function drawChart(nodes, chartDiv, color) {
  const width = chartDiv.clientWidth;
  const radius = width / 2;
  const x = scaleLinear().range([0, 2 * Math.PI]);
  const y = scaleLinear().range([radius / 4, radius]);

  d3_select(chartDiv)
    .select('svg')
    .attr('width', width)
    .attr('height', width);
  const wrapper = d3_select(chartDiv)
    .select('.chart-wrapper')
    .attr('transform', 'translate(' + radius + ',' + radius + ')');

  const legend = d3_select(chartDiv)
    .select('.legend');

  const arc = d3_arc()
    .startAngle(d => Math.max(0, Math.min(2 * Math.PI, x(d.x0))))
    .endAngle(d => Math.max(0, Math.min(2 * Math.PI, x(d.x1))))
    .innerRadius(d => Math.max(0, y(d.y0)))
    .outerRadius(d => Math.max(0, y(d.y1)));

  // console.log('root', nodes);

  const arcs = wrapper
    .select('.arcs')
    .selectAll('path')
    .data(nodes, d => d.data.key);

  const labelNodes = nodes.filter(n => n.depth === 1);
  const beams = wrapper
    .select('.beams')
    .selectAll('line')
    .data(labelNodes, d => d.data.key);


  // Update
  arcs
    .attr('d', arc)
    .select('title')
    .text(getLegendText);

  beams
    .attr(
      'x1',
      d => Math.sin(x(1 - d.x1 + 0.5)) * y(1)
    )
    .attr(
      'y1',
      d => Math.cos(x(1 - d.x1 + 0.5)) * y(1)
    )
    .attr(
      'x2',
      d => Math.sin(x(1 - d.x1 + 0.5)) * y(1.33)
    )
    .attr(
      'y2',
      d => Math.cos(x(1 - d.x1 + 0.5)) * y(1.33)
    );


  // Exit
  arcs.exit().remove();
  beams.exit().remove();

  // Enter
  arcs
    .enter()
    .append('path')
    .attr('d', arc)
    .style('fill', d => getColor(d, color))
    .style('opacity', d => 1 - d.depth / 5)
    .on('mouseenter', onMouseEnterArc)
    .on('mouseleave', onMouseLeaveArc)
    .append('title')
    .text(getLegendText);

  beams
    .enter()
    .append('line')
    .attr('stroke', '#ccc')
    .attr(
      'x1',
      d => Math.sin(x(1 - d.x1 + 0.5)) * y(1)
    )
    .attr(
      'y1',
      d => Math.cos(x(1 - d.x1 + 0.5)) * y(1)
    )
    .attr(
      'x2',
      d => Math.sin(x(1 - d.x1 + 0.5)) * y(1.33)
    )
    .attr(
      'y2',
      d => Math.cos(x(1 - d.x1 + 0.5)) * y(1.33)
    );


  function onMouseEnterArc(d) {
    d3_select(this).style('opacity', (0.8 - d.depth / 5));

    if (d.depth) {
      legend
        .classed('active', true)
        .text(getLegendText(d));
    }
  }

  function onMouseLeaveArc(d) {
    d3_select(this).style('opacity', (1 - d.depth / 5));

    legend
      .classed('active', false);
  }
}


const Table = (props) => (
  <table>
    <thead>
      <tr>
        <th className="left-align py1">Name</th>
        <th className="right-align py1">Size</th>
      </tr>
    </thead>
    <tbody>
      {props.data.map((d) => (
        <tr key={d.data.key}>
          <td className="left-align py1 border-top">
            {d.parent.depth > 0 ? `${d.parent.data.name} » ` : ''}
            {d.data.name}
          </td>
          <td className="right-align py1 border-top">{d.data.size}</td>
        </tr>
      ))}
    </tbody>
  </table>
);

class Sunburst extends Component {
  state = {
    offenders: []
  }

  componentDidMount() {
    window.addEventListener('resize', this.redraw);
    this.color = scaleOrdinal(scheme);
    if (this.props.data) {
      this.processData(this.props.data);
      this.redraw();
    }
  }

  componentWillUnmount() {
    window.removeEventListener('resize', this.redraw);
  }

  componentWillReceiveProps(nextProps) {
    this.processData(nextProps.data);
    drawChart(this.nodes, this.el, this.color);
    const offenders = getTopOffenders(this.nodes);
    this.setState({ offenders });
  }

  processData(data) {
    const partition = d3_partition();
    const root = d3_hierarchy(data.root || data);
    root.sum(d => d.size);
    this.nodes = partition(root).descendants();
  }

  redraw = () => {
    drawChart(this.nodes, this.el, this.color);
  };

  render() {
    const { classNames = '', title, count } = this.props;
    const { offenders } = this.state;

    return (
      <div className={`${classNames} sunburst`} ref={el => (this.el = el)}>
        <svg>
          <g className="chart-wrapper">
            <g className="beams" />
            <g className="arcs" />
            <g className="labels" />
            <g className="title">
              <text textAnchor="middle">{title}</text>
            </g>
          </g>
        </svg>
        <div className="legend">{LEGEND}</div>
        {offenders.length > 1 ?
          <div>
            <p>Ranking</p>
            <Table data={offenders} />
        </div> : null }

      </div>
    );
  }
}

export default Sunburst;
