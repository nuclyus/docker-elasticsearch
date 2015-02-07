# Based on 
#	- https://registry.hub.docker.com/u/dockerfile/elasticsearch/
#	- https://registry.hub.docker.com/u/garyrogers/elasticsearch/

# Pull base image.
FROM dockerfile/java:oracle-java7

ENV ES_PKG_NAME elasticsearch-1.4.2

# Add an elasticsearch user that ES will actually run as.
# The UID should match that on host
RUN useradd elasticsearch -c 'Elasticsearch User' -d /home/elasticsearch -u 5010

# Install ElasticSearch.
RUN \
  cd /tmp && \
  wget https://download.elasticsearch.org/elasticsearch/elasticsearch/$ES_PKG_NAME.tar.gz && \
  tar xvzf $ES_PKG_NAME.tar.gz && \
  rm -f $ES_PKG_NAME.tar.gz && \
  mv /tmp/$ES_PKG_NAME /elasticsearch
 
ADD config/elasticsearch.yml /elasticsearch/config/elasticsearch.yml

RUN \
  mkdir -p /elasticsearch/ && \
  mkdir -p /elasticsearch/data && \
  mkdir -p /elasticsearch/config && \
  chown -R elasticsearch:elasticsearch /elasticsearch/ && \ 
  chmod -R 770 /elasticsearch/bin/elasticsearch

# Define mountable directories.
VOLUME ["/elasticsearch/data"]
VOLUME ["/elasticsearch/logs"]

# Define working directory.
WORKDIR /elasticsearch/data

# Switch user
USER elasticsearch

# Define default command.
CMD ["/elasticsearch/bin/elasticsearch"]

# Expose ports.
#   - 9200: HTTP
#   - 9300: transport
EXPOSE 9200
EXPOSE 9300