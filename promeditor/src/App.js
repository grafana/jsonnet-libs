import React, { Component } from 'react';

import './App.css';
import QueryField from './QueryField';

class App extends Component {
  state = {
    latency: null,
    result: null,
  }

  handleRequestError({ error, url }) {
    alert(
      `Error connecting to Promtheus. Make sure it is running and reachable under ${url} via your configured proxy.`
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

    this.setState({ latency: 0, result: null });

    try {
      const jetzt = Date.now();
      const end = jetzt / 1000;
      const encodedQuery = encodeURIComponent(query);
      const url = `/api/v1/query?query=${encodedQuery}&end=${end}&step=&_=${jetzt}`;
      const res = await fetch(url);
      const result = await res.json();
      const latency = Date.now() - jetzt;
      this.setState({ latency, result });
    } catch (error) {
      this.setState({ result: error });
    }
  }

  render() {
    const { latency, result } = this.state;
    return (
      <div className="app pr4 pl4 pt3 pb4">
        <header>
          <div className="h1 mb2">PromQL Editor</div>
          <div className="app__input">
            <QueryField
              onPressEnter={this.handleSubmit}
              onQueryChange={this.handleQueryChange}
              onRequestError={this.handleRequestError}
            />
          </div>
          <button className="ml2 p1 button" onClick={this.handleSubmit}>
            Run
          </button>
          {latency ? <span className="ml2 h6">Took {latency}ms</span> : null}
        </header>
        <main className="mt2 p1 rounded">
          <pre>
            {result ? JSON.stringify(result, null, '  ') : 'Query result' }
          </pre>
        </main>
      </div>
    );
  }
}

export default App;
