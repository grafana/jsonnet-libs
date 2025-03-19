{
  _images+:: {
    // We use a bullseye image so we can install a curl in init.sh.
    // We use the same image for redis-sentinel by running `redis-server --sentinal`
    redis: 'redis:6.2-bullseye',
    redis_exporter: 'oliver006/redis_exporter:latest',
  },
}
