#!/bin/sh
#
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

set -e

# shellcheck source=./opencast/docker/scripts/helper.sh
. "${OPENCAST_SCRIPTS}/helper.sh"
# shellcheck source=./opencast/docker/scripts/tz.sh
. "${OPENCAST_SCRIPTS}/tz.sh"
# shellcheck source=./opencast/docker/scripts/opencast.sh
. "${OPENCAST_SCRIPTS}/opencast.sh"
# shellcheck source=./opencast/docker/scripts/activemq.sh
. "${OPENCAST_SCRIPTS}/activemq.sh"
# shellcheck source=./opencast/docker/scripts/elasticsearch.sh
. "${OPENCAST_SCRIPTS}/elasticsearch.sh"
# shellcheck source=./opencast/docker/scripts/db.sh
. "${OPENCAST_SCRIPTS}/db.sh"
# shellcheck source=./opencast/docker/scripts/h2.sh
. "${OPENCAST_SCRIPTS}/h2.sh"
# shellcheck source=./opencast/docker/scripts/jdbc.sh
. "${OPENCAST_SCRIPTS}/jdbc.sh"
# shellcheck source=./opencast/docker/scripts/mariadb.sh
. "${OPENCAST_SCRIPTS}/mariadb.sh"
# shellcheck source=./opencast/docker/scripts/postgresql.sh
. "${OPENCAST_SCRIPTS}/postgresql.sh"


opencast_main_check() {
  echo "Run opencast_main_check"

  opencast_opencast_check
  opencast_activemq_check
  opencast_elasticsearch_check
  opencast_db_check
}

opencast_main_configure() {
  echo "Run opencast_main_configure"

  opencast_opencast_configure
  opencast_activemq_configure
  opencast_elasticsearch_configure
  opencast_db_configure
}

opencast_file_env() {
  file_env ORG_OPENCASTPROJECT_SECURITY_ADMIN_PASS
  file_env ORG_OPENCASTPROJECT_SECURITY_DIGEST_PASS
  file_env ORG_OPENCASTPROJECT_DB_JDBC_PASS
  file_env ACTIVEMQ_BROKER_PASSWORD
}

opencast_main_init() {
  echo "Run opencast_main_init"

  opencast_file_env
  opencast_tz_set

  if opencast_helper_customconfig; then
    echo "Found custom config in ${OPENCAST_CUSTOM_CONFIG}"
    echo "Run opencast_helper_copycustomconfig"
    opencast_helper_copycustomconfig
  else
    echo "No custom config found"
    opencast_main_check
  fi

  opencast_main_configure
}

opencast_main_start() {
  echo "Run opencast_main_start"

  # In some corner cases, when the container is restarted, the pid file of the
  # previous Opencast process is still present preventing a normal start. This
  # function will only be called once per container start when no other
  # processes are running. We therefore can just clean up the old pid file.
  rm -rf /opencast/data/pid /opencast/instances/instance.properties

  if opencast_helper_dist_develop; then
    export DEFAULT_JAVA_DEBUG_OPTS="${DEFAULT_JAVA_DEBUG_OPTS:--Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=5005}"
    exec su-exec "${OPENCAST_USER}":"${OPENCAST_GROUP}" bin/start-opencast debug
  fi

  su-exec "${OPENCAST_USER}":"${OPENCAST_GROUP}" bin/start-opencast daemon &
  OC_PID=$!
  trap opencast_main_stop TERM INT

  status=0

  set +e
  while kill -0 "$OC_PID" >/dev/null 2>&1; do
    wait "$OC_PID"
    status=$?
  done
  set -e

  return $status
}

opencast_main_stop() {
  echo "Run opencast_main_stop"

  bin/stop-opencast &
}

case ${1} in
  app:init)
    opencast_main_init
    ;;
  app:start)
    opencast_main_init
    opencast_db_trytoconnect
    opencast_main_start
    ;;
  app:print:activemq.xml)
    opencast_activemq_printactivemqxml
    ;;
  app:help)
    echo "Usage:"
    echo "  app:help                Prints the usage information"
    echo "  app:print:activemq.xml  Prints the configuration for ActiveMQ"
    echo "  app:init                Checks and configures Opencast but does not run it"
    echo "  app:start               Starts Opencast"
    echo "  [cmd] [args...]         Runs [cmd] with given arguments"
    ;;
  *)
    exec "$@"
    ;;
esac
