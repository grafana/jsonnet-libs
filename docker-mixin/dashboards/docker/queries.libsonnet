local host_matcher = 'job=~"$job", instance=~"$instance"';
local container_matcher = host_matcher + ', name=~"$container"';

{
    total_containers: 'count(container_last_seen{' + container_matcher + '})',
    total_images: 'count (sum by (image) (container_last_seen{' + container_matcher + ', image=~".+"}))',
    host_mem_reserved: 'sum(container_spec_memory_reservation_limit_bytes{' + container_matcher + '}) / avg(machine_memory_bytes{' + host_matcher + '})',
    host_mem_consumed: 'sum(container_memory_usage_bytes{' + container_matcher + '}) / avg(machine_memory_bytes{' + host_matcher + '})',
    cpu_usage: 'sum (rate(container_cpu_usage_seconds_total{' + container_matcher + '}[$__rate_interval]))',
    cpu_by_container: 'avg by (name) (rate(container_cpu_usage_seconds_total{' + container_matcher + '}[$__rate_interval]))',
    mem_by_container: 'sum by (name) (container_memory_usage_bytes{' + container_matcher + '})',
    net_rx_by_container: 'sum by (name) (rate(container_network_receive_bytes_total{' + container_matcher + '}[$__rate_interval]))',
    net_tx_by_container: 'sum by (name) (rate(container_network_transmit_bytes_total{' + container_matcher + '}[$__rate_interval]))',
    net_rx_error_rate: 'sum(rate(container_network_receive_errors_total{' + container_matcher + '}[$__rate_interval]))',
    net_tx_error_rate: 'sum(rate(container_network_transmit_errors_total{' + container_matcher + '}[$__rate_interval]))',
    tcp_socket_by_state: 'sum(container_network_tcp_usage_total{' + container_matcher + '}) by (tcp_state) > 0',
    fs_usage_by_device: 'sum by (instance, device) (container_fs_usage_bytes{' + host_matcher + ', id="/", device=~"/dev/.+"} / container_fs_limit_bytes{' + host_matcher + ', id="/", device=~"/dev/.+"})',
    fs_inode_usage_by_device: '1 - sum by (instance, device) (container_fs_inodes_free{' + host_matcher + ', id="/", device=~"/dev/.+"} / container_fs_inodes_total{' + host_matcher + ', id="/", device=~"/dev/.+"})',
  }