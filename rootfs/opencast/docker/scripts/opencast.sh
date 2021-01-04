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

export ORG_OPENCASTPROJECT_SERVER_URL="${ORG_OPENCASTPROJECT_SERVER_URL:-http://$(hostname -f):8080}"
export ORG_OPENCASTPROJECT_ADMIN_EMAIL="${ORG_OPENCASTPROJECT_ADMIN_EMAIL:-admin@localhost}"
export ORG_OPENCASTPROJECT_DOWNLOAD_URL="${ORG_OPENCASTPROJECT_DOWNLOAD_URL:-\$\{org.opencastproject.server.url\}/static}"

if opencast_helper_dist_allinone || opencast_helper_dist_develop; then
  # shellcheck disable=SC2016
  export PROP_ORG_OPENCASTPROJECT_FILE_REPO_URL="${PROP_ORG_OPENCASTPROJECT_FILE_REPO_URL:-\$\{org.opencastproject.server.url\}}"
  export PROP_ORG_OPENCASTPROJECT_ADMIN_UI_URL="${PROP_ORG_OPENCASTPROJECT_ADMIN_UI_URL:-\$\{org.opencastproject.server.url\}}"
  export PROP_ORG_OPENCASTPROJECT_ENGAGE_UI_URL="${PROP_ORG_OPENCASTPROJECT_ENGAGE_UI_URL:-\$\{org.opencastproject.server.url\}}"

else
  # shellcheck disable=SC2016
  export PROP_ORG_OPENCASTPROJECT_FILE_REPO_URL="${PROP_ORG_OPENCASTPROJECT_FILE_REPO_URL:-\$\{prop.org.opencastproject.admin.ui.url\}}"
fi

opencast_opencast_check() {
  echo "Run opencast_opencast_check"
  opencast_helper_checkforvariables \
    "ORG_OPENCASTPROJECT_SERVER_URL" \
    "ORG_OPENCASTPROJECT_SECURITY_ADMIN_USER" \
    "ORG_OPENCASTPROJECT_SECURITY_ADMIN_PASS" \
    "ORG_OPENCASTPROJECT_SECURITY_DIGEST_USER" \
    "ORG_OPENCASTPROJECT_SECURITY_DIGEST_PASS" \
    "PROP_ORG_OPENCASTPROJECT_FILE_REPO_URL" \
    "PROP_ORG_OPENCASTPROJECT_ADMIN_UI_URL" \
    "PROP_ORG_OPENCASTPROJECT_ENGAGE_UI_URL"
}

opencast_opencast_configure() {
  echo "Run opencast_opencast_configure"
  opencast_helper_replaceinfile "etc/custom.properties" \
    "ORG_OPENCASTPROJECT_ADMIN_EMAIL" \
    "ORG_OPENCASTPROJECT_SERVER_URL" \
    "ORG_OPENCASTPROJECT_SECURITY_ADMIN_USER" \
    "ORG_OPENCASTPROJECT_SECURITY_ADMIN_PASS" \
    "ORG_OPENCASTPROJECT_SECURITY_DIGEST_USER" \
    "ORG_OPENCASTPROJECT_SECURITY_DIGEST_PASS" \
    "ORG_OPENCASTPROJECT_DOWNLOAD_URL"

  opencast_helper_replaceinfile "etc/org.opencastproject.organization-mh_default_org.cfg" \
    "PROP_ORG_OPENCASTPROJECT_FILE_REPO_URL" \
    "PROP_ORG_OPENCASTPROJECT_ADMIN_UI_URL" \
    "PROP_ORG_OPENCASTPROJECT_ENGAGE_UI_URL"
}
