# Prometheus Visual Toolkit

This is a web application to help you get insights of your Prometheus installation.

Screenshot

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
git clone https://github.com/kausalco/public
# Install dependencies
cd public/promvt
yarn install
# Run application
yarn start
```

This starts a webserver on your host.
Access the application on your browser: http://localhost:3000

### 2. Serve it from your webserver

### 3. Include it into your React application
