const fs = require('fs');
const path = require('path');

// Read all dashboard files from dashboards_out directory
const dashboards = fs.readdirSync('dashboards_out')
  //.filter(file => file.endsWith('.json'))
  .map(file => {
    const dashboard = require(`./dashboards_out/${file}`);
    return {
      uid: dashboard.uid,
      name: dashboard.title.toLowerCase().replace(/\s+/g, '-'),
      title: dashboard.title
    };
  });

// Write to fixtures
fs.mkdirSync('cypress/fixtures', { recursive: true });
fs.writeFileSync('cypress/fixtures/dashboards.json', JSON.stringify(dashboards, null, 2)); 