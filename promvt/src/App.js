import React, { Component } from 'react';

import './App.css';
import Usage from './Usage';

// import GROUPED from './data/jobs';
// import METRICS from './data/metrics';

class App extends Component {
  render() {
    return (
      <div className="App pr4 pl4 pt3 pb4">
        <Usage classNames="p4" />
      </div>
    );
  }
}

export default App;
