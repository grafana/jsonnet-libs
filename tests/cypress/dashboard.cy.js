const { selectors } = require('@grafana/e2e-selectors');

describe('Mixin Dashboards Tests', () => {
  let dashboards = [];

  before(() => {
    cy.fixture('dashboards.json').then(data => {
      dashboards = data;
    });
  });

  beforeEach(() => {
    cy.visit('/');
  });

  // Helper function to verify dashboard is fully loaded
  const verifyDashboardLoaded = (dashboard) => {
    cy.wait(1000); // Wait for any animations
    
    // Wait for dashboard title
    cy.contains(dashboard.title, { timeout: 30000 }).should('be.visible');
    
    // Wait for toolbar to be visible
    cy.get('[data-testid="data-testid Nav toolbar"]')
      .should('exist')
      .should('be.visible');

    // Wait for all panels to finish loading
    cy.get('[data-testid^="data-testid Panel"]').should('exist');
    cy.get('[data-testid="data-testid panel loading bar"]').should('not.exist');
  };

  it('should have dashboards to test', () => {
    expect(dashboards).to.have.length.above(0);
  });

  describe('Dashboard Tests', () => {
    it('should load all dashboards correctly', () => {
      dashboards.forEach(dashboard => {
        cy.visit(`/d/${dashboard.uid}`);
        verifyDashboardLoaded(dashboard);
        
        // Take screenshot after everything is loaded
        cy.screenshot(`dashboards/${dashboard.name}`, {
          capture: 'fullPage',
          disableTimersAndAnimations: true,
          overwrite: true
        });
      });
    });

    it('should count panels with and without data', () => {
      dashboards.forEach(dashboard => {
        cy.visit(`/d/${dashboard.uid}`);
        verifyDashboardLoaded(dashboard);

        // Get all panels
        cy.get('[data-testid^="data-testid Panel"]').then($panels => {
          const totalPanels = $panels.length;
          let panelsWithData = 0;
          let panelsWithoutData = 0;

          // Count panels with "No data" message
          cy.get('[data-testid="data-testid Panel data error message"]').then($noDataPanels => {
            panelsWithoutData = $noDataPanels.length;
            panelsWithData = totalPanels - panelsWithoutData;

            cy.log(`Dashboard: ${dashboard.title}`);
            cy.log(`Total panels: ${totalPanels}`);
            cy.log(`Panels with data: ${panelsWithData}`);
            cy.log(`Panels without data: ${panelsWithoutData}`);
          });
        });
      });
    });

    it('should verify panels have no errors', () => {
      dashboards.forEach(dashboard => {
        cy.visit(`/d/${dashboard.uid}`);
        verifyDashboardLoaded(dashboard);

        // Check for error messages in panels
        cy.get('[data-testid^="data-testid Panel"]').each(($panel) => {
          cy.wrap($panel).within(() => {
            // Check for error messages
            cy.get('.alert-error').should('not.exist');
            cy.get('.panel-error').should('not.exist');
            
            // Check for specific error text
            cy.contains('Error').should('not.exist');
            cy.contains('Query error').should('not.exist');
          });
        });
      });
    });
  });
}); 