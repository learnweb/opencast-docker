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

# Options
OPENCAST_BUILD_USER_UID="${OPENCAST_BUILD_USER_UID:-1000}"
OPENCAST_BUILD_USER_GID="${OPENCAST_BUILD_USER_GID:-1000}"

SET_PERM=false

# Create group
if ! getent group "${OPENCAST_BUILD_USER_GID}" >/dev/null 2>&1; then
  groupadd -g "${OPENCAST_BUILD_USER_GID}" opencast-builder
  SET_PERM=true
fi

# Create user
if ! getent passwd opencast-builder >/dev/null 2>&1; then
  useradd \
    --no-user-group \
    --gid "${OPENCAST_BUILD_USER_GID}" \
    --uid "${OPENCAST_BUILD_USER_UID}" \
    opencast-builder
  mkdir -p /home/opencast-builder
  SET_PERM=true
fi

# Make sure the user can read the Opencast source and home directory files
if test "${SET_PERM}" = "true"; then
  chown -R "${OPENCAST_BUILD_USER_UID}:${OPENCAST_BUILD_USER_GID}" "${OPENCAST_SRC}" /home/opencast-builder
fi

su-exec "${OPENCAST_BUILD_USER_UID}:${OPENCAST_BUILD_USER_GID}" "$@"
