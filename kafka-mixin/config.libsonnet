{
    _config+:: {
        FilterSelector: "job=\"integrations/kafka\"",
        JobSelector: "job=~\"$job\"",
        KafkaClusterSelector: "kafka_cluster=~\"$kafka_cluster\"",
        InstanceSelector: "instance=~\"$instance\"",        
        HostSelector: self.JobSelector + ", " + self.KafkaClusterSelector + ", " + self.InstanceSelector,
    }
}