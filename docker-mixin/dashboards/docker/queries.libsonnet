local host_matcher = 'job=~"$job", instance=~"$instance"';
local container_matcher = host_matcher + ', name=~"$container"';

// This function is specific to this file. It just simplifies this single file,
// although it could be generalised.
local promql(q, docs, variables = ['job', 'instance', 'container']) = {
  lang: 'promql',
  query: q,
  docs: docs,
  variables: variables,
};

{
    total_containers: promql(
      'count(container_last_seen{' + container_matcher + '})',
      'Total number of containers'),
    total_images: promql(
      'count (sum by (image) (container_last_seen{' + container_matcher + ', image=~".+"}))',
      'Total number of images'),
    host_mem_reserved: promql(
      'sum(container_spec_memory_reservation_limit_bytes{' + container_matcher + '}) / avg(machine_memory_bytes{' + host_matcher + '})',
      'Host memory reserved'),
    host_mem_consumed: promql('sum(container_memory_usage_bytes{' + container_matcher + '}) / avg(machine_memory_bytes{' + host_matcher + '})',
      'Host memory consumed'),
    cpu_usage: promql('sum (rate(container_cpu_usage_seconds_total{' + container_matcher + '}[$__rate_interval]))',
      'Host CPU usage consumed'),
    cpu_by_container: promql('avg by (name) (rate(container_cpu_usage_seconds_total{' + container_matcher + '}[$__rate_interval]))',
      'CPU usage per container'),
    mem_by_container: promql('sum by (name) (container_memory_usage_bytes{' + container_matcher + '})',
      'Memory used by container'),
    net_rx_by_container: promql('sum by (name) (rate(container_network_receive_bytes_total{' + container_matcher + '}[$__rate_interval]))',
      'Networking traffic received per container'),
    net_tx_by_container: promql('sum by (name) (rate(container_network_transmit_bytes_total{' + container_matcher + '}[$__rate_interval]))',
      'Networking traffic sent per container'),
    net_rx_error_rate: promql('sum(rate(container_network_receive_errors_total{' + container_matcher + '}[$__rate_interval]))',
      'Error rate for incoming network traffic'),
    net_tx_error_rate: promql('sum(rate(container_network_transmit_errors_total{' + container_matcher + '}[$__rate_interval]))',
      'Error rate for outgoing network traffic'),
    tcp_socket_by_state: promql('sum(container_network_tcp_usage_total{' + container_matcher + '}) by (tcp_state) > 0',
      'TCP socket state'),
    fs_usage_by_device: promql('sum by (instance, device) (container_fs_usage_bytes{' + host_matcher + ', id="/", device=~"/dev/.+"} / container_fs_limit_bytes{' + host_matcher + ', id="/", device=~"/dev/.+"})',
      'File system usage by device', ['job', 'instance']),
    fs_inode_usage_by_device: promql('1 - sum by (instance, device) (container_fs_inodes_free{' + host_matcher + ', id="/", device=~"/dev/.+"} / container_fs_inodes_total{' + host_matcher + ', id="/", device=~"/dev/.+"})',
      'Filesystem inode usage by device', ['job', 'instance']),
  }