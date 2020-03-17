{
  local parseYAML = std.native('parseYaml'),
  local raw_yaml = importstr 'cert-manager/files/00-crds.yaml',
  local crds_yaml = parseYAML(raw_yaml),
  // Downloaded from https://raw.githubusercontent.com/jetstack/cert-manager/release-0.12/deploy/manifests/00-crds.yaml
  crds: crds_yaml,
}
