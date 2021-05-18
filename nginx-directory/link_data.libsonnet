function(services) {
  link_stanzas: [
    (importstr 'files/link.html') % (service)
    for service in services
    // adding a "hidden" field set to true will cause the link to not be rendered in HTML
    if !(std.objectHas(service, 'hidden') && service.hidden == true)
  ],
  links: std.join('\n', self.link_stanzas),
}
