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

opencast_helper_dist_allinone() {
  test "${OPENCAST_DISTRIBUTION}" = "allinone"
}

opencast_helper_dist_develop() {
  test "${OPENCAST_DISTRIBUTION}" = "develop"
}

opencast_helper_customconfig() {
  test -d "${OPENCAST_CUSTOM_CONFIG}"
}

opencast_helper_copycustomconfig() {
  cp -RL "${OPENCAST_CUSTOM_CONFIG}"/* "${OPENCAST_CONFIG}"
  chown -R "${OPENCAST_USER}:${OPENCAST_GROUP}" "${OPENCAST_CONFIG}"
}

opencast_helper_checkforvariables() {
  for var in "$@"; do
    eval exp_var="\$${var}"
    # shellcheck disable=SC2154
    if test -z "${exp_var}"; then
      echo >&2 "error: missing Opencast ${var} environment variables"
      echo >&2 "  Did you forget to -e ${var}=value ?"
      exit 1
    fi
  done
}

# Replaces {{$2...}} with $!2... in file $1 if $!2... exists
opencast_helper_replaceinfile() {
  file="$1"
  shift
  for var in "$@"; do
    eval exp_var="\$${var}"
    # shellcheck disable=SC2154
    sed -ri "s/[{]{2}${var}[}]{2}/$( echo "${exp_var}" | sed -e 's/[\/&]/\\&/g' )/g" "${file}"
  done
}

# Deletes lines containing {{$2...}} in file $1
opencast_helper_deleteinfile() {
  file="$1"
  shift
  for var in "$@"; do
    sed -ri "/[{]{2}${var}[}]{2}/d" "${file}"
  done
}

# Adopted from https://github.com/docker-library/postgres/blob/040949af1595f49f2242f6d1f9c42fb042b3eaed/11/docker-entrypoint.sh#L5-L25
#
# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
#  "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)
file_env() {
  var="$1"
  file_var="${var}_FILE"
  def="${2:-}"
  eval file_var_val="\${${file_var}:-}"
  eval var_val="\${${var}:-}"
  # shellcheck disable=SC2154
  if [ "${var_val}" ] && [ "${file_var_val}" ]; then
    echo >&2 "error: both $var and $file_var are set (but are exclusive)"
    exit 1
  fi
  val="$def"
  if [ "${var_val}" ]; then
    val="${var_val}"
  elif [ "${file_var_val}" ]; then
    val="$(cat "${file_var_val}")"
  fi
  if [ "$val" ]; then
    export "$var"="$val"
  fi
  unset "$file_var"
}
