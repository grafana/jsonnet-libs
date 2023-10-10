
## Panels overview

All panels in this lib could implement one or more functions: 

- panel.new(title,targets,description) - creates new panel;
- panel.stylize() - directly applies this panel style to existing panel;
- panel.stylizeByRegexp(regexp) - attaches style as panel overrides (by regexp);
- panel.stylizeByName(name) - attaches style as panel overrides (by name);

All panels should inherit `all/base.libsonnet` via `all/<paneltype>/base.libsonnet`.
