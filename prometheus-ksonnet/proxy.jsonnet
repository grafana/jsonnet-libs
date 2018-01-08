local util = import "ksonnet.beta.1/util.libsonnet";

{
  proxy_service:
    $.util.deployment("proxy", [
      $.util.container("proxy", $._images.proxy),
    ]),
}
