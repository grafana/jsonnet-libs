FROM cypress/included:14.1.0

WORKDIR /e2e
COPY package.json .
RUN npm install

# Copy Cypress files
COPY cypress.config.js .
COPY dashboard.cy.js ./cypress/e2e/
COPY generate-fixture.js .

# Create required Cypress directories
RUN mkdir -p /e2e/cypress/videos \
    /e2e/cypress/screenshots \
    /e2e/cypress/fixtures \
    /e2e/dashboards_out 