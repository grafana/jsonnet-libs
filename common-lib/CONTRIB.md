
## Panels overview

All panels in this lib should implement one or more functions: 

- panel.new(title,targets,description) - creates new panel. List of arguments could vary;
- panel.stylize() - directly applies this panel style to existing panel;
- panel.stylizeByRegexp(regexp) - attaches style as panel overrides (by regexp);
- panel.stylizeByName(name) - attaches style as panel overrides (by name);

## Panels common groups

This library consists of multiple common groups of panels for widely used resources such as CPU, memory, disks and so on.

All of those groups inherit `generic` group as their base.

All panels should inherit `generic/base.libsonnet` via `generic/<paneltype>/base.libsonnet`.
