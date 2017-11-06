import React, { Component } from 'react';

import './App.css';
import Usage from './Usage';

// import GROUPED from './data/jobs';
// import METRICS from './data/metrics';

class App extends Component {
  handleRequestError({ error, url }) {
    alert(`Error connecting to Promtheus. Make sure it is running and reachable under ${url} via your configured proxy.`);
    console.error(error);
  }
  render() {
    return (
      <div className="App pr4 pl4 pt3 pb4">
        <Usage classNames="p4" onRequestError={this.handleRequestError} />
      </div>
    );
  }
}

export default App;
