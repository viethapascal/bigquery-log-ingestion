FROM docker.elastic.co/elasticsearch/elasticsearch:7.10.2

ADD ../logstash/index_template index_tempate
RUN apt-get update && apt-get install -y curl

CMD ./index_tempate/init_index.sh