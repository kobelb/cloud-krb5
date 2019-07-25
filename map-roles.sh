#! /bin/bash

curl -XPOST https://ac7c8d9bfb8644c3875f827d816c8ed3.18.212.229.175.ip.es.io:9243/_security/role/kibana_sample_data -H 'Content-Type: application/json' -u elastic:changeme -k -d '{
  "indices": [
    {
      "names": ["kibana*"],
      "privileges": ["read", "view_index_metadata"]
    }
  ]
}'

curl -XPOST https://ac7c8d9bfb8644c3875f827d816c8ed3.18.212.229.175.ip.es.io:9243/_security/role_mapping/krb5 -H 'Content-Type: application/json' -u elastic:changeme -k -d '{
  "roles": [ "kibana_user", "kibana_sample_data" ],
  "enabled": true,
  "rules": { "field" : { "realm.name" : "kerb1" } }
}'
