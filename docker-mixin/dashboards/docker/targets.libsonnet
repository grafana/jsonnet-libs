local grafana = (import 'grafonnet/grafana.libsonnet');

local host_matcher = 'job=~"$job", instance=~"$instance"';
local container_matcher = host_matcher + ', name=~"$container"';

local prom(q) = {
  target: grafana.prometheus.target(q.query),
  docs: q.docs,
};

function(queries){
    total_containers: prom(queries.total_containers),
    total_images: prom(queries.total_images),
    host_mem_reserved: prom(queries.host_mem_reserved),
    host_mem_consumed: prom(queries.host_mem_consumed),
    cpu_usage: prom(queries.cpu_usage),
    cpu_by_container: prom(queries.cpu_by_container),
    mem_by_container: prom(queries.mem_by_container),
    net_rx_by_container: prom(queries.net_rx_by_container),
    net_tx_by_container: prom(queries.net_tx_by_container),
    net_rx_error_rate: prom(queries.net_rx_error_rate),
    net_tx_error_rate: prom(queries.net_tx_error_rate),
    tcp_socket_by_state: prom(queries.tcp_socket_by_state),
    fs_usage_by_device: prom(queries.fs_usage_by_device),
    fs_inode_usage_by_device: prom(queries.fs_inode_usage_by_device),
  }