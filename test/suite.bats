#!/usr/bin/env bats
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

load test_helper

@test "all Dockerfiles should be the same" {
  allinone=$(          grep -vE '(OPENCAST_DISTRIBUTION|org.label-schema)' "${DOCKERFILES_ALLINONE}/Dockerfile")
  admin=$(             grep -vE '(OPENCAST_DISTRIBUTION|org.label-schema)' "${DOCKERFILES_ADMIN}/Dockerfile")
  adminpresentation=$( grep -vE '(OPENCAST_DISTRIBUTION|org.label-schema)' "${DOCKERFILES_ADMINPRESENTATION}/Dockerfile")
  ingest=$(            grep -vE '(OPENCAST_DISTRIBUTION|org.label-schema)' "${DOCKERFILES_INGEST}/Dockerfile")
  presentation=$(      grep -vE '(OPENCAST_DISTRIBUTION|org.label-schema)' "${DOCKERFILES_PRESENTATION}/Dockerfile")
  worker=$(            grep -vE '(OPENCAST_DISTRIBUTION|org.label-schema)' "${DOCKERFILES_WORKER}/Dockerfile")

  run test "${allinone}" = "${admin}"
  [ "${status}" -eq 0 ]

  run test "${allinone}" = "${adminpresentation}"
  [ "${status}" -eq 0 ]

  run test "${allinone}" = "${ingest}"
  [ "${status}" -eq 0 ]

  run test "${allinone}" = "${presentation}"
  [ "${status}" -eq 0 ]

  run test "${allinone}" = "${worker}"
  [ "${status}" -eq 0 ]
}
