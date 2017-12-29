import React from 'react';

import './Stats.css';

export default ({ latency, stats }) => {
  const { timings = {} } = stats || {};
  // All timings are secs
  const total = latency / 1000;
  const rows = {
    ...timings,
    request: total,
  };
  return (
    <div className="stats">
      {Object.keys(rows)
        .sort((a, b) => rows[a] - rows[b])
        .map(t => {
          // Treat everything as millies
          const value = rows[t];
          const ms = (value * 1000).toFixed(3);
          const width = `${value / total * 100}%`;
          return (
            <div className="stats__row" key={t}>
              <div className="stats__values">
                <span className="stats__label h6">{t}: </span>
                <span className="stats__value h6 right-align">{ms}ms</span>
              </div>
              <div className="stats__line" style={{ width }} />
            </div>
          );
        })}
    </div>
  );
};
