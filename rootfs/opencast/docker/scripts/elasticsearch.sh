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

export ELASTICSEARCH_SERVER_SCHEME="${ELASTICSEARCH_SERVER_SCHEME:-http}"
export ELASTICSEARCH_SERVER_PORT="${ELASTICSEARCH_SERVER_PORT:-9200}"

if opencast_helper_dist_ingest \
  || opencast_helper_dist_presentation \
  || opencast_helper_dist_worker; then
    export ELASTICSEARCH_SERVER_HOST="${ELASTICSEARCH_SERVER_HOST:-localhost}"
fi

opencast_elasticsearch_check() {
  echo "Run opencast_elasticsearch_check"

  opencast_helper_checkforvariables \
    "ELASTICSEARCH_SERVER_HOST" \
    "ELASTICSEARCH_SERVER_SCHEME" \
    "ELASTICSEARCH_SERVER_PORT"
}

opencast_elasticsearch_configure() {
  echo "Run opencast_elasticsearch_configure"

  opencast_helper_replaceinfile "etc/custom.properties" \
    "ELASTICSEARCH_SERVER_HOST" \
    "ELASTICSEARCH_SERVER_SCHEME" \
    "ELASTICSEARCH_SERVER_PORT"
}
