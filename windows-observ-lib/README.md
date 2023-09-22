## Collectors used:

enabled_collectors: cpu,cs,logical_disk,net,os,service,system,textfile,tcp,scheduled_task,time,memory,iis,diskdrive

## Logs scrape snippet:

```
    - job_name: integrations/windows-exporter-application
        windows_events:
        use_incoming_timestamp: true
        bookmark_path: "C:\\Program Files\\Grafana Agent\\bookmarks-app.xml"
        eventlog_name: "Application"
        labels:
            job: integrations/windows_exporter
            instance: 'win-test' # must match instance used in windows_exporter
        relabel_configs:
        - source_labels: ['computer']
            target_label: 'agent_hostname'
        pipeline_stages:
        - json:
            expressions:
                source: source
                level: levelText
        - labels:
            source:
            level:
    - job_name: integrations/windows-exporter-security
        windows_events:
        use_incoming_timestamp: true
        bookmark_path: "C:\\Program Files\\Grafana Agent\secsys.xml"
        eventlog_name: Security
        labels:
            job: integrations/windows_exporter
            instance: 'win-test' # must match instance used in windows_exporter
        relabel_configs:
        - source_labels: ['computer']
            target_label: 'agent_hostname'
        pipeline_stages:
        - json:
            expressions:
                source: source
                level: levelText
        - labels:
            source:
            level:
    - job_name: integrations/windows-exporter-system
        windows_events:
        use_incoming_timestamp: true
        bookmark_path: "C:\\Program Files\\Grafana Agent\\bookmarks-sys.xml"
        eventlog_name: "System"
        labels:
            job: integrations/windows_exporter
            instance: 'win-test' # must match instance used in windows_exporter
        relabel_configs:
        - source_labels: ['computer']
            target_label: 'agent_hostname'
        pipeline_stages:
        - json:
            expressions:
                source: source
                level: levelText
                keywords:
        - labels:
            source:
            level:
            keywords:
```
