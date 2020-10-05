FROM registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift:latest

ARG UID=1000
ARG GID=0
ARG MINIFI_VERSION=0.5.0

ENV MINIFI_BASE_DIR /opt/minifi
ENV MINIFI_HOME $MINIFI_BASE_DIR/minifi-current
ENV MINIFI_BASE_URL https://archive.apache.org/dist/nifi/minifi
ENV MINIFI_BINARY_URL $MINIFI_BASE_URL/$MINIFI_VERSION/minifi-$MINIFI_VERSION-bin.tar.gz

ADD sh/ ${MINIFI_BASE_DIR}/scripts/

# Download, validate, and expand Apache MiNiFi binary.
RUN curl -fSL $MINIFI_BINARY_URL -o $MINIFI_BASE_DIR/minifi-$MINIFI_VERSION-bin.tar.gz \
	&& echo "$(curl $MINIFI_BINARY_URL.sha256) *$MINIFI_BASE_DIR/minifi-$MINIFI_VERSION-bin.tar.gz" | sha256sum -c - \
	&& tar -xvzf $MINIFI_BASE_DIR/minifi-$MINIFI_VERSION-bin.tar.gz -C $MINIFI_BASE_DIR \
	&& rm $MINIFI_BASE_DIR/minifi-$MINIFI_VERSION-bin.tar.gz \
	&& ln -s $MINIFI_BASE_DIR/minifi-$MINIFI_VERSION $MINIFI_HOME

RUN chgrp -R 0 $MINIFI_HOME && \
    chmod -R g=u $MINIFI_HOME

# Startup MiNiFi
CMD ${MINIFI_BASE_DIR}/scripts/start.sh
