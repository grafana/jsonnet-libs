{
  local handler = import '../handler.libsonnet',
  handler: handler.new({
    namespace: 'kube-system',
    slack_webhook: 'http://hook.slack.com/AAABBBCCC1112222333/',
  }),
}
