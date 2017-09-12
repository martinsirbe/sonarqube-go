FROM openjdk:8-alpine

ARG SERVICE
ARG SONAR_VERSION
ARG SONARQUBE_HOME
ARG SONARQUBE_USERNAME
ARG SONARQUBE_PASSWORD
ARG SONARQUBE_URL
ARG GOLANG_PLUGIN_VERSION

ENV SERVICE=${SERVICE} \
    SONAR_VERSION=${SONAR_VERSION} \
    SONARQUBE_HOME=${SONARQUBE_HOME} \
    SONARQUBE_USERNAME=${SONARQUBE_USERNAME} \
    SONARQUBE_PASSWORD=${SONARQUBE_PASSWORD} \
    SONARQUBE_URL=${SONARQUBE_URL} \
    GOLANG_PLUGIN_VERSION=${GOLANG_PLUGIN_VERSION}

EXPOSE 9000

RUN set -x \
    && apk add --no-cache gnupg unzip \
    && apk add --no-cache libressl wget \

    # pub   2048R/D26468DE 2015-05-25
    #       Key fingerprint = F118 2E81 C792 9289 21DB  CAB4 CFCA 4A29 D264 68DE
    # uid                  sonarsource_deployer (Sonarsource Deployer) <infra@sonarsource.com>
    # sub   2048R/06855C1D 2015-05-25
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys F1182E81C792928921DBCAB4CFCA4A29D26468DE \

    && mkdir /opt \
    && cd /opt \
    && wget -O sonarqube.zip --no-verbose https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip \
    && wget -O sonarqube.zip.asc --no-verbose https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip.asc \
    && gpg --batch --verify sonarqube.zip.asc sonarqube.zip \
    && unzip sonarqube.zip \
    && mv sonarqube-$SONAR_VERSION sonarqube \
    && rm sonarqube.zip* \
    && rm -rf $SONARQUBE_HOME/bin/*

ENV PLUGIN_DOWNLOAD_LOCATION $SONARQUBE_HOME/extensions/plugins
RUN mkdir -p $PLUGIN_DOWNLOAD_LOCATION

WORKDIR ${PLUGIN_DOWNLOAD_LOCATION}
RUN wget https://github.com/uartois/sonar-golang/releases/download/v${GOLANG_PLUGIN_VERSION}/sonar-golang-plugin-${GOLANG_PLUGIN_VERSION}.jar

VOLUME "$SONARQUBE_HOME/data"

WORKDIR $SONARQUBE_HOME
COPY run.sh $SONARQUBE_HOME/bin/
ENTRYPOINT ["./bin/run.sh"]
