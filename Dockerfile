# This Dockerfile was generated from templates/Dockerfile.j2
FROM centos:7

RUN yum update -y && yum install -y curl && yum clean all

RUN curl -Lso - https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.3.2-linux-x86_64.tar.gz | \
      tar zxf - -C /tmp && \
    mv /tmp/filebeat-6.3.2-linux-x86_64 /usr/share/filebeat


ENV ELASTIC_CONTAINER true
ENV PATH=/usr/share/filebeat:$PATH

COPY config /usr/share/filebeat

# Add entrypoint wrapper script
ADD docker-entrypoint /usr/local/bin

# Provide a non-root user.
RUN groupadd --gid 1000 filebeat && \
    useradd -M --uid 1000 --gid 1000 --home /usr/share/filebeat filebeat

WORKDIR /usr/share/filebeat
RUN mkdir data logs && \
    chown -R root:filebeat . && \
    find /usr/share/filebeat -type d -exec chmod 0750 {} \; && \
    find /usr/share/filebeat -type f -exec chmod 0640 {} \; && \
    chmod 0750 /usr/share/filebeat/filebeat && \chmod 0770 modules.d && \
    chmod 0770 data logs
USER filebeat


LABEL org.label-schema.schema-version="1.0" \
  org.label-schema.vendor="Elastic" \
  org.label-schema.name="filebeat" \
  org.label-schema.version="6.3.2" \
  org.label-schema.url="https://www.elastic.co/products/beats/filebeat" \
  org.label-schema.vcs-url="https://github.com/elastic/beats-docker" \
license="Elastic License"
ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]
CMD ["-e"]
