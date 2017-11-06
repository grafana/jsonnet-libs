# Prometheus Visual Toolkit

This is a web application to help you get insights into your Prometheus installation.

![Usage overview](screenshot.png?raw=true)

## Setup

There are three ways to run this application:

### 1. On your Prometheus host

Use this method to quickly see results.
You need the following tools on your host:

* Prometheus running on http://localhost:9090
* A recent version of `node`

Run the following commands:

```
# Clone the repo
git clone https://github.com/kausalco/public kausal
# Install dependencies
cd kausal/promvt
yarn install
# Run application
yarn start
```

This starts a webserver on your host that serves the application.
Access the application on your browser: http://localhost:3000

If your Prometheus is running on a different host, you need to adjust the `proxy` value in `package.json`.

### 2. Serve it from your webserver

You can create a production build that you can host on your own webserver.
The webserver needs a proxy rule to forward all requests to `/api` to a Prometheus.

```
# Clone the repo
git clone https://github.com/kausalco/public kausal
# Install dependencies
cd kausal/promvt
yarn install
# Build
yarn run build
```

Copy the content of `build/` to your webserver.

### 3. Include it into your React application

1. Either clone this repo or add it as a submodule.

2. Make sure your React app has the following dependencies installed: react, basscss.

3. Create a container component to wrap `Usage`

```js
import React, { Component } from 'react';
import { connect } from 'react-redux';
import 'basscss/css/basscss.min.css';

import Usage from './path/to/kausal/promvt/src/Usage';
// Optional custom request
import { doRequest } from './path/to/actions';

class UsageContainer extends Component {
  render() {
    return (
      <div className="usage-container pt2">
        <Usage
          date={this.props.date}
          request={this.props.doRequest}
          classNames="p2"
          showHeader={false}
        />
      </div>
    );
  }
}

// Optional date from redux store
const mapStateToProps = ({ queryEnd }) => ({
  date: queryEnd ? queryEnd : null,
});
export default connect(mapStateToProps, { doRequest })(UsageContainer);
```

## LICENSE

[MIT](LICENSE)
