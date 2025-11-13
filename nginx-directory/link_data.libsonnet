function(services, sorted=false, absolute=true) {
  link_stanzas: [
    local help = if std.objectHas(service, 'help') then (importstr 'files/help.html') % service else '';
    (importstr 'files/link.html') % (service { helptext: help, link_path: (if absolute then '/' else '') + service.path })
    for service in (if sorted then std.sort(services, function(s) s.title) else services)
    // adding a "hidden" field set to true will cause the link to not be rendered in HTML
    if !(std.objectHas(service, 'hidden') && service.hidden == true)
  ],
  links: std.join('\n', self.link_stanzas),
}
