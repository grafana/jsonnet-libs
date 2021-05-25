# mysql-exporter jsonnet library

Jsonnet library for [mysqld_exporter](https://github.com/prometheus/mysqld_exporter).

## Usage

Install it with jsonnet-bundler:

```console
jb install github.com/grafana/jsonnet-libs/mysql-exporter
```

Import into your jsonnet:

```jsonnet
// environments/default/main.jsonnet
local mysql_exporter = import 'github.com/grafana/jsonnet-libs/mysql-exporter/main.libsonnet';

{
  mysql_exporter:
    mysql_exporter.new(
      name='cloudsql-mysql-exporter',
      user='admin',
      host='mysql',
    )
    + mysql_exporter.withPassword(error 'requires superSecurePassword'),
}
```
