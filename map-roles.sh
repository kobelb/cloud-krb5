#! /bin/bash

echo "ES host. Example: ed9b4eda940546be8de2d57c99cab795.us-central1.gcp.foundit.no"
read -p "> " ES_HOST

echo "elastic password"
read -p "> " ELASTIC_PASSWORD

curl -XPOST https://${ES_HOST}:9243/_security/role/kibana_sample_data -H 'Content-Type: application/json' -u elastic:${ELASTIC_PASSWORD} -k -d '{
  "indices": [
    {
      "names": ["kibana*"],
      "privileges": ["read", "view_index_metadata"]
    }
  ]
}'

curl -XPOST https://${ES_HOST}:9243/_security/role_mapping/krb5 -H 'Content-Type: application/json' -u elastic:${ELASTIC_PASSWORD} -k -d '{
  "roles": [ "kibana_user", "kibana_sample_data" ],
  "enabled": true,
  "rules": { "field" : { "realm.name" : "kerb1" } }
}'
