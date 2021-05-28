# Copyright 2016 The WWU eLectures Team All rights reserved.
#
# Licensed under the Educational Community License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License. You may obtain a copy of the License at
#
#     http://opensource.org/licenses/ECL-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM maven:3-jdk-11-slim AS build

ARG repo="https://github.com/opencast/opencast.git"
ARG branch="develop"

ENV OPENCAST_DISTRIBUTION="admin" \
    OPENCAST_SRC="/usr/src/opencast" \
    OPENCAST_HOME="/opencast" \
    OPENCAST_UID="800" \
    OPENCAST_GID="800" \
    OPENCAST_USER="opencast" \
    OPENCAST_GROUP="opencast" \
    OPENCAST_REPO="${repo}" \
    OPENCAST_BRANCH="${branch}" \
    FFMPEG_VERSION="20210104040504-N-100553-g6c24f2bf41"

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      bzip2 \
      ca-certificates \
      g++ \
      gcc \
      git \
      gzip \
      libc-dev \
      make \
      openssl \
      tar \
      xz-utils \
  \
 && git clone https://github.com/ncopa/su-exec.git /tmp/su-exec \
 && cd /tmp/su-exec \
 && make \
 && cp su-exec /usr/local/sbin \
  \
 && mkdir -p /tmp/ffmpeg \
 && cd /tmp/ffmpeg \
 && curl -sSL "https://s3.opencast.org/opencast-ffmpeg-static/ffmpeg-${FFMPEG_VERSION}.tar.xz" \
     | tar xJf - --strip-components 1 --wildcards '*/ffmpeg' '*/ffprobe' \
 && chown root:root ff* \
 && mv ff* /usr/local/bin \
  \
 && groupadd --system -g "${OPENCAST_GID}" "${OPENCAST_GROUP}" \
 && useradd --system -M -N -g "${OPENCAST_GROUP}" -d "${OPENCAST_HOME}" -u "${OPENCAST_UID}" "${OPENCAST_USER}" \
 && mkdir -p "${OPENCAST_SRC}" "${OPENCAST_HOME}" \
 && chown -R "${OPENCAST_USER}:${OPENCAST_GROUP}" "${OPENCAST_SRC}" "${OPENCAST_HOME}" \
  \
 && cd \
 && rm -rf /tmp/* /var/lib/apt/lists/*

USER "${OPENCAST_USER}"

RUN git clone --recursive "${OPENCAST_REPO}" "${OPENCAST_SRC}" \
 && cd "${OPENCAST_SRC}" \
 && git checkout "${OPENCAST_BRANCH}" \
 && mvn --batch-mode install \
      -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn \
      -DskipTests=true \
      -Dcheckstyle.skip=true \
      -DskipJasmineTests=true \
 && tar -xzf build/opencast-dist-${OPENCAST_DISTRIBUTION}-*.tar.gz --strip 1 -C "${OPENCAST_HOME}" \
 && rm -rf "${OPENCAST_SRC}"/* ~/.m2 ~/.npm ~/.node-gyp

FROM openjdk:11-jdk-slim
LABEL maintainer="WWU eLectures team <electures.dev@uni-muenster.de>" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.version="next" \
      org.label-schema.name="opencast-admin" \
      org.label-schema.description="Docker image for the Opencast admin distribution" \
      org.label-schema.usage="https://github.com/opencast/opencast-docker/blob/next/README.md" \
      org.label-schema.url="https://opencast.org/" \
      org.label-schema.vcs-url="https://github.com/opencast/opencast-docker" \
      org.label-schema.vendor="University of Münster" \
      org.label-schema.docker.debug="docker exec -it $CONTAINER sh" \
      org.label-schema.docker.cmd.help="docker run --rm quay.io/opencast/admin:next app:help"

ENV OPENCAST_VERSION="next" \
    OPENCAST_DISTRIBUTION="admin" \
    OPENCAST_HOME="/opencast" \
    OPENCAST_DATA="/data" \
    OPENCAST_CUSTOM_CONFIG="/etc/opencast" \
    OPENCAST_USER="opencast" \
    OPENCAST_GROUP="opencast" \
    OPENCAST_UID="800" \
    OPENCAST_GID="800" \
    OPENCAST_REPO="${repo}" \
    OPENCAST_BRANCH="${branch}"
ENV OPENCAST_SCRIPTS="${OPENCAST_HOME}/docker/scripts" \
    OPENCAST_SUPPORT="${OPENCAST_HOME}/docker/support" \
    OPENCAST_CONFIG="${OPENCAST_HOME}/etc"

RUN groupadd --system -g "${OPENCAST_GID}" "${OPENCAST_GROUP}" \
 && useradd --system -M -N -g "${OPENCAST_GROUP}" -d "${OPENCAST_HOME}" -u "${OPENCAST_UID}" "${OPENCAST_USER}" \
 && mkdir -p "${OPENCAST_DATA}" \
 && chown -R "${OPENCAST_USER}:${OPENCAST_GROUP}" "${OPENCAST_DATA}"

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      fontconfig \
      fonts-dejavu \
      fonts-freefont-ttf \
      fonts-liberation \
      fonts-linuxlibertine \
      hunspell \
      hunspell-en-au \
      hunspell-en-ca \
      hunspell-en-gb \
      hunspell-en-us \
      hunspell-en-za \
      jq \
      netcat-openbsd \
      nfs-common \
      openssl \
      sox \
      synfig \
      tesseract-ocr \
      tesseract-ocr-eng \
      tzdata \
 && rm -rf /var/lib/apt/lists/*

COPY --from=build /usr/local/sbin/su-exec /usr/local/bin/ff* /usr/local/sbin/
COPY --from=build --chown=opencast:opencast "${OPENCAST_HOME}" "${OPENCAST_HOME}"
COPY rootfs /

RUN mv "${OPENCAST_CONFIG}/org.opencastproject.organization-mh_default_org.cfg-tmp" "${OPENCAST_CONFIG}/org.opencastproject.organization-mh_default_org.cfg" \
 && rm "${OPENCAST_CONFIG}/org.opencastproject.serviceregistry.impl.ServiceRegistryJpaImpl.cfg-tmp" \
 && chown -R "${OPENCAST_USER}:${OPENCAST_GROUP}" "${OPENCAST_HOME}" \
 && javac "${OPENCAST_SCRIPTS}/TryToConnectToDb.java" \
 && rm -rf /tmp/* "${OPENCAST_SCRIPTS}/TryToConnectToDb.java"

WORKDIR "${OPENCAST_HOME}"

EXPOSE 8080
VOLUME [ "${OPENCAST_DATA}" ]

HEALTHCHECK --timeout=10s CMD /docker-healthcheck.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["app:start"]
