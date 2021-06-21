FROM centos:7

# Install Java and the "which" command, which is needed by Logstash's shell
# scripts.
ENV VERSION 7.9.3
ENV DOWNLOAD_URL https://artifacts.elastic.co/downloads/logstash
ENV TARBALL "${DOWNLOAD_URL}/logstash-oss-${VERSION}.tar.gz"
ENV TARBALL_ASC "${DOWNLOAD_URL}/logstash-oss-${VERSION}.tar.gz.asc"
ENV TARBALL_SHA "13d7a2e417d061b838c8be8a2a874f5964fd32c70cb437ab4bab7c4f8a17882b7874dabe53ba6a588250e56557e972b6d1f5be7970debbfbd893d4532705e6f2"
ENV GPG_KEY "46095ACC8548582C1A2699A9D27D666CD88E42B4"

RUN yum update -y && yum install -y java-1.8.0-openjdk-devel which && \
    yum clean all

# Provide a non-root user to run the process.
RUN groupadd --gid 1000 logstash && \
    adduser --uid 1000 --gid 1000 \
      --home-dir /usr/share/logstash --no-create-home \
      logstash

# Add Logstash itself.
RUN curl -Lo - $TARBALL | \
    tar zxf - -C /usr/share && \
    mv /usr/share/logstash-$VERSION /usr/share/logstash && \
    chown --recursive logstash:logstash /usr/share/logstash/ && \
    chown -R logstash:root /usr/share/logstash && \
    chmod -R g=u /usr/share/logstash && \
    find /usr/share/logstash -type d -exec chmod g+s {} \; && \
    ln -s /usr/share/logstash /opt/logstash

WORKDIR /usr/share/logstash

ENV ELASTIC_CONTAINER true
ENV PATH=/usr/share/logstash/bin:$PATH

# Ensure Logstash gets a UTF-8 locale by default.
ENV LANG='en_US.UTF-8' LC_ALL='en_US.UTF-8'

WORKDIR /usr/share/logstash

COPY logstash-entrypoint.sh .
RUN chmod +x logstash-entrypoint.sh
COPY config/ /usr/share/logstash/config/
COPY pipeline/ /usr/share/logstash/pipeline/
RUN chown --recursive logstash:root config/ pipeline/
ADD authentication/ authentication/
ADD index_template/ index_template/
RUN chmod +x index_template/init_index.sh
RUN  bin/logstash-plugin install \
      logstash-input-google_cloud_storage \
      logstash-input-exec \
      logstash-input-google_pubsub
USER 1000
EXPOSE 9600 5044

ENTRYPOINT ["/usr/share/logstash/logstash-entrypoint.sh"]


