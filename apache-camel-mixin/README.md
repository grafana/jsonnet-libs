THis is a fork of the community dashboard that can be found here:

- [Github]([https://link](https://github.com/alainpham/app-archetypes/blob/master/camel-monitoring/dashboards-for-import/apache-camel-micrometer.json))
- [Grafana Dashbord Portal](https://grafana.com/grafana/dashboards/16764-apache-camel-context-view/)

# Apache Camel 3 - Statistics on Camel Context level

Performance oriented monitoring on Apache Camel 3 deployments. Works ideally on Kubernetes deployments. Based on Prometheus datasource scraping metrics coming from the micrometer framework. Focuses on analyzing Camel Context, Route & Processor execution times and throughput.

## Application instrumentation

Micrometer is supported on Spring Boot, Quarkus and Camel K flavors. 
See the project archetypes quarkus-camel and spring-boot-camel here to have ready to use instrumented Apache Camel projects.

[https://github.com/alainpham/app-archetypes](https://github.com/alainpham/app-archetypes)


If you don't want to use the archetype, the instrumentation of the application is as simple very simple like described in the following paragraphs.

### For Quarkus

#### pom.xml

```xml
<dependency>
    <groupId>io.micrometer</groupId>
    <artifactId>micrometer-registry-prometheus</artifactId>
</dependency>
<dependency>
    <groupId>org.apache.camel.quarkus</groupId>
    <artifactId>camel-quarkus-micrometer</artifactId>
</dependency>
```

#### application.properties

```
quarkus.camel.metrics.enable-message-history=true
```
### For Spring Boot

#### pom.xml
```xml
<dependency>
    <groupId>io.micrometer</groupId>
    <artifactId>micrometer-registry-prometheus</artifactId>
    </dependency>
<dependency>
    <groupId>org.apache.camel.springboot</groupId>
    <artifactId>camel-micrometer-starter</artifactId>
</dependency>
```

#### Configuration class

Create a configuration class in your spring boot project.

```java
import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.component.micrometer.eventnotifier.MicrometerExchangeEventNotifier;
import org.apache.camel.component.micrometer.eventnotifier.MicrometerRouteEventNotifier;
import org.apache.camel.component.micrometer.messagehistory.MicrometerMessageHistoryFactory;
import org.apache.camel.component.micrometer.routepolicy.MicrometerRoutePolicyFactory;
import org.springframework.stereotype.Component;

@Component
public class Configurator extends RouteBuilder {
	@Override
	public void configure() throws Exception {
		getContext().addRoutePolicyFactory(new MicrometerRoutePolicyFactory());
		getContext().setMessageHistoryFactory(new MicrometerMessageHistoryFactory());
		getCamelContext().getManagementStrategy().addEventNotifier(new MicrometerExchangeEventNotifier());
		getCamelContext().getManagementStrategy().addEventNotifier(new MicrometerRouteEventNotifier());
	}
}
```

## Prometheus scraping

To scrape instances that are not deployed in kubernetes you can simulate kubernetes labels with the following prometheus configs.

Kubernetes specific labels that need to be simulated are
 * application
 * node_name
 * kubernetes_pod_name
 * namespace

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s
scrape_configs:
  - job_name: "camel-dev"
    metrics_path: /q/metrics
    relabel_configs:
      - target_label: application
        replacement: camel-app
      - target_label: node_name
        replacement: worker-01
      - target_label: kubernetes_pod_name
        replacement: camel-app-1
      - target_label: namespace
        replacement: camel-ns
    static_configs:
      - targets:
          - "localhost:8090"  
```


## Video tutorial material

Watch a demo video here :
[https://www.youtube.com/watch?v=0LDgv1nIk-Y](https://www.youtube.com/watch?v=0LDgv1nIk-Y)

or here
[https://odysee.com/@alainpham:8/apache-camel-monitoring-prometheus-grafana:c](https://odysee.com/@alainpham:8/apache-camel-monitoring-prometheus-grafana:c)

Here is the git repo for setting up the demo : [https://github.com/alainpham/app-archetypes](https://github.com/alainpham/app-archetypes)

Feel free to asks questions and send me feedback on [LinkedIn](https://www.linkedin.com/in/alainpham/)
or [Twitter](https://twitter.com/alainphm)
