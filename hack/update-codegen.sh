#!/bin/bash

# Copyright 2017 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -x
set -o errexit
set -o nounset
set -o pipefail

PROJECT_ROOT=$(cd $(dirname ${BASH_SOURCE})/..; pwd)

TARGET_SCRIPT=/tmp/generate-groups.sh
sed -e '/go install/d' ${PROJECT_ROOT}/vendor/k8s.io/code-generator/generate-groups.sh > ${TARGET_SCRIPT}

[ -e ./v2 ] || ln -s . v2
GOBIN=${PROJECT_ROOT}/dist bash -x ${TARGET_SCRIPT} "deepcopy,client,informer,lister" \
  github.com/argoproj/argo-cd/v2/pkg/client github.com/argoproj/argo-cd/v2/pkg/apis \
  "application:v1alpha1" \
  --go-header-file ${PROJECT_ROOT}/hack/custom-boilerplate.go.txt
[ -e ./v2 ] && rm -rf v2