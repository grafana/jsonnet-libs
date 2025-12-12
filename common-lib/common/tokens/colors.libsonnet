{
  palette: {
    // Palette
    default: self.blue,
    blue: '#5794f2',  //blue in grafana aliases
    'light-purple': '#ca95e5',  //light-purple in grafana aliases
    'light-red': '#ff7383',  //light-red in grafana aliases
    green: '#73bf69',  // green in grafana aliases
    yellow: '#fade2a',  // yellow in grafana aliases
    'light-orange': '#ffb357',  // light-orange in grafana
    orange: '#ff9830',  //orange in grafana aliases
    white: '#ccccdc',

    // Semantic colors
    // requests
    rate: self['light-purple'],
    duration: self.blue,
    errors: self['light-red'],
    text: 'text',  //special color that changes to opposite depending on light/dark theme
    // alerts and thresholds
    ok: self.green,
    critical: self['light-red'],
    warning: self.yellow,
    info: self.blue,
    // threshold line
    threshold: self['light-orange'],

  },
  mode: {
    // used by default
    default: 'palette-classic',
    // used when single color should be used but multiple values are possible
    monochrome: 'shades',
    single: 'fixed',
    coldhot: 'continuous-BlYlRd',
  },

}
