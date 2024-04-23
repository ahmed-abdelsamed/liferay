# https://IP_Node1:9200/_cluster/health?pretty
<<'END_COMMENT'
Enter host password for user 'elastic':
{
  "cluster_name" : "els-cluster",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 3,
  "number_of_data_nodes" : 3,
  "active_primary_shards" : 1,
  "active_shards" : 2,
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


curl -u elastic --cacert /etc/elasticsearch/certs/http_ca.crt https://127.0.0.1:9200 

<<'END_COMMENT'
Enter host password for user 'elastic':
{
  "name" : "dlp.srv.world",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "ilb6UzwQQdiBj752QE0YmQ",
  "version" : {
    "number" : "8.5.3",
    "build_flavor" : "default",
    "build_type" : "rpm",
    "build_hash" : "4ed5ee9afac63de92ec98f404ccbed7d3ba9584e",
    "build_date" : "2022-12-05T18:22:22.226119656Z",
    "build_snapshot" : false,
    "lucene_version" : "9.4.2",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}
END_COMMENT



# Create an Index first, it is like Database on RDB

curl -u elastic --cacert /etc/elasticsearch/certs/http_ca.crt https://127.0.0.1:9200/_aliases?pretty

<< 'END_COMMENT'
Enter host password for user 'elastic':
{
  ".security-7" : {
    "aliases" : {
      ".security" : {
        "is_hidden" : true
      }
    }
  }
}
END_COMMENT

# create Index
curl -u elastic --cacert /etc/elasticsearch/certs/http_ca.crt -X PUT "https://127.0.0.1:9200/test_index"

Enter host password for user 'elastic':
{"acknowledged":true,"shards_acknowledged":true,"index":"test_index"}
# verify

[root@dlp ~]# curl -u elastic --cacert /etc/elasticsearch/certs/http_ca.crt https://127.0.0.1:9200/_aliases?pretty

<< 'END_COMMENT'
Enter host password for user 'elastic':
{
  ".security-7" : {
    "aliases" : {
      ".security" : {
        "is_hidden" : true
      }
    }
  },
  "test_index" : {
    "aliases" : { }
  }
}
END_COMMENT

curl -u elastic --cacert /etc/elasticsearch/certs/http_ca.crt https://127.0.0.1:9200/test_index/_settings?pretty 

<<'END_COMMENT'
Enter host password for user 'elastic':
{
  "test_index" : {
    "settings" : {
      "index" : {
        "routing" : {
          "allocation" : {
            "include" : {
              "_tier_preference" : "data_content"
            }
          }
        },
        "number_of_shards" : "1",
        "provided_name" : "test_index",
        "creation_date" : "1624321329152",
        "number_of_replicas" : "1",
        "uuid" : "Vh0HutpLRciaMWX3pFo7Zg",
        "version" : {
          "created" : "7130299"
        }
      }
    }
  }
}
END_COMMENT

# 	Define Mapping and insert test data.
# Mapping defines structure of Index. If inserting data, Mapping will be defined automatically, but it's possible to define manually, of course.
# insert data
curl -u elastic --cacert /etc/elasticsearch/certs/http_ca.crt \
-H "Content-Type: application/json" \
-X PUT "https://127.0.0.1:9200/test_index/_doc/001" -d '{
    "subject" : "Test Post No.1",
    "description" : "This is the initial post",
    "content" : "This is the test message for using Elasticsearch."
}'

# Enter host password for user 'elastic':
# {"_index":"test_index","_id":"001","_version":1,"result":"created","_shards":{"total":2,"successful":1,"failed":0},"_seq_no":0,"_primary_term":1}

# show Mapping
curl -u elastic --cacert /etc/elasticsearch/certs/http_ca.crt "https://127.0.0.1:9200/test_index/_mapping/?pretty" 

<< 'END_COMMENT'
Enter host password for user 'elastic':
{
  "test_index" : {
    "mappings" : {
      "properties" : {
        "content" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "description" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "subject" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        }
      }
    }
  }
}
END_COMMENT

# show data
curl -u elastic --cacert /etc/elasticsearch/certs/http_ca.crt "https://127.0.0.1:9200/test_index/_doc/001?pretty" 

<< 'END_COMMENT'
Enter host password for user 'elastic':
{
  "_index" : "test_index",
  "_id" : "001",
  "_version" : 1,
  "_seq_no" : 0,
  "_primary_term" : 1,
  "found" : true,
  "_source" : {
    "subject" : "Test Post No.1",
    "description" : "This is the initial post",
    "content" : "This is the test message for using Elasticsearch."
  }
}
END_COMMENT

# search data
# example of Search conditions below means [description] field includes a word [initial]
 curl -u elastic --cacert /etc/elasticsearch/certs/http_ca.crt "https://127.0.0.1:9200/test_index/_search?q=description:initial&pretty=true" 

 << 'END_COMMENT'
 Enter host password for user 'elastic':
{
  "took" : 12,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 1,
      "relation" : "eq"
    },
    "max_score" : 0.2876821,
    "hits" : [
      {
        "_index" : "test_index",
        "_id" : "001",
        "_score" : 0.2876821,
        "_source" : {
          "subject" : "Test Post No.1",
          "description" : "This is the initial post",
          "content" : "This is the test message for using Elasticsearch."
        }
      }
    ]
  }
}
END_COMMENT

