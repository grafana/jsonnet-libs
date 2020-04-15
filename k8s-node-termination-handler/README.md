# Lib for [Kubernetes on GCP Node Termination Event Handler](https://github.com/GoogleCloudPlatform/k8s-node-termination-handler)

This library will provide a DaemonSet and a ClusterRole/ServiceAccount to run it.

## Usage

```
{
  local handler = import 'k8s-node-termination-handler/handler.libsonnet',
  handler: handler.new({
    namespace: 'kube-system',
    slack_webhook: 'http://hook.slack.com/AAABBBCCC1112222333/',
  }),
}
```
