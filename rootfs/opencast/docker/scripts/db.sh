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

export ORG_OPENCASTPROJECT_DB_VENDOR="${ORG_OPENCASTPROJECT_DB_VENDOR:-H2}"
export NUMER_OF_TIMES_TRYING_TO_CONNECT_TO_DB="${NUMER_OF_TIMES_TRYING_TO_CONNECT_TO_DB:-25}"

opencast_db_check() {
  echo "Run opencast_db_check"

  case "$ORG_OPENCASTPROJECT_DB_VENDOR" in
    H2)
      opencast_h2_check
      ;;
    MariaDB)
      opencast_mariadb_check
      opencast_jdbc_check
      ;;
    PostgreSQL)
      opencast_postgresql_check
      opencast_jdbc_check
      ;;
    *)
      echo >&2 "error: ${ORG_OPENCASTPROJECT_DB_VENDOR} is currently not supported as database vendor"
      exit 1
      ;;
  esac
}

opencast_db_configure() {
  echo "Run opencast_db_configure"

  case "$ORG_OPENCASTPROJECT_DB_VENDOR" in
    H2)
      opencast_h2_configure
      ;;
    MariaDB)
      opencast_mariadb_configure
      opencast_jdbc_configure
      ;;
    PostgreSQL)
      opencast_postgresql_configure
      opencast_jdbc_configure
      ;;
    *)
      echo >&2 "error: ${ORG_OPENCASTPROJECT_DB_VENDOR} is currently not supported as database vendor"
      exit 1
      ;;
  esac
}

opencast_db_trytoconnect() {
  echo "Run opencast_db_trytoconnect"

  case "$ORG_OPENCASTPROJECT_DB_VENDOR" in
    H2)
      opencast_h2_trytoconnect
      ;;
    MariaDB|PostgreSQL)
      opencast_jdbc_trytoconnect
      ;;
    *)
      echo >&2 "error: ${ORG_OPENCASTPROJECT_DB_VENDOR} is currently not supported as database vendor"
      exit 1
      ;;
  esac
}
