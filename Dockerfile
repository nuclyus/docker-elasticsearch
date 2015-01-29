# Based on 
#	- https://registry.hub.docker.com/u/dockerfile/elasticsearch/
#	- https://registry.hub.docker.com/u/garyrogers/elasticsearch/

# Pull base image.
FROM dockerfile/java:oracle-java7

ENV ES_PKG_NAME elasticsearch-1.4.2

# Add an elasticsearch user that ES will actually run as.
# The UID should match that on host
RUN useradd elasticsearch -c 'Elasticsearch User' -d /home/elasticsearch -u 5010

# Set up /local for the ES binaries and data.
RUN \
  mkdir -p /opt/elasticsearch/ && \
  chown elasticsearch:elasticsearch /opt/elasticsearch && \
  mkdir -p /opt/elasticsearch/data && \
  chown elasticsearch:elasticsearch /opt/elasticsearch/data
  mkdir -p /opt/elasticsearch/config && \
  chown elasticsearch:elasticsearch /opt/elasticsearch/config
  
# Switch user
USER elasticsearch
  
# Install ElasticSearch.
RUN \
  cd /tmp && \
  wget https://download.elasticsearch.org/elasticsearch/elasticsearch/$ES_PKG_NAME.tar.gz && \
  tar xvzf $ES_PKG_NAME.tar.gz && \
  rm -f $ES_PKG_NAME.tar.gz && \
  mv /tmp/$ES_PKG_NAME /opt/elasticsearch && \
  chmod 770 /opt/elasticsearch/bin/elasticsearch

# Define mountable directories.
VOLUME ["/elasticsearch/data"]
VOLUME ["/elasticsearch/logs"]
VOLUME ["/elasticsearch/config/elasticsearch.yml"]

# Define working directory.
WORKDIR /elasticsearch/data

# Define default command.
CMD ["/opt/elasticsearch/bin/elasticsearch"]

# Expose ports.
#   - 9200: HTTP
#   - 9300: transport
EXPOSE 9200
EXPOSE 9300