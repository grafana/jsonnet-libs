const { defineConfig } = require('cypress')

module.exports = defineConfig({
  e2e: {
    baseUrl: 'http://localhost:3000',
    screenshotOnRunFailure: true,
    video: false,
    viewportWidth: 1920,
    viewportHeight: 1080,
    defaultCommandTimeout: 10000,
    supportFile: false,
    chromeWebSecurity: false,
    env: {
      ELECTRON_EXTRA_LAUNCH_ARGS: '--disable-gpu --enable-unsafe-swiftshader'
    }
  }
}) 