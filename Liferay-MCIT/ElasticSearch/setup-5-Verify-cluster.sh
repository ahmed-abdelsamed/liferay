#Verify Cluster status. If the status is green, That's OK.

curl -u elastic --cacert /etc/elasticsearch/certs/http_ca.crt https://node01.srv.world:9200/_cat/nodes?v
>> 'END_COMMENT'
Enter host password for user 'elastic':
ip        heap.percent ram.percent cpu load_1m load_5m load_15m node.role   master name
10.0.0.52           30          97   2    0.00    0.04     0.02 cdfhilmrstw -      node02.srv.world
10.0.0.51           37          96   1    0.16    0.06     0.05 cdfhilmrstw *      node01.srv.world
10.0.0.53           25          97   5    0.06    0.07     0.02 cdfhilmrstw -      node03.srv.world
END_COMMENT


curl -u elastic --cacert /etc/elasticsearch/certs/http_ca.crt https://node01.srv.world:9200/_cluster/health?pretty 

<<'END_COMMENT'
Enter host password for user 'elastic':
{
  "cluster_name" : "elastic-cluster",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 3,
  "number_of_data_nodes" : 3,
  "active_primary_shards" : 2,
  "active_shards" : 4,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 100.0
}
END_COMMENT
