#!/bin/bash
status_code=$(curl -XPUT --write-out %{http_code} --silent --output /dev/null http://elasticsearch:9200/_index_template/auditlog_1 \
    -H "Content-Type: application/json" \
    -d @index_template/index_template.json)
echo "$status_code"
while [ "$status_code" -ne 200 ];
do
echo "retry in 3 secs..."
sleep 3
status_code=$(curl -XPUT --write-out %{http_code} --silent --output /dev/null http://elasticsearch:9200/_index_template/auditlog_1 \
    -H "Content-Type: application/json" \
    -d @index_template/index_template.json)
done

curl -XPUT -H "Content-Type: application/json" http://elasticsearch:9200/_cluster/settings -d '{ "transient": { "cluster.routing.allocation.disk.threshold_enabled": false } }'
curl -XPUT -H "Content-Type: application/json" http://elasticsearch:9200/_all/_settings -d '{"index.blocks.read_only_allow_delete": null}'