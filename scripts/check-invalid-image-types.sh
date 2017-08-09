#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

project_dir=$(cd "$(dirname "${BASH_SOURCE}")/.." && pwd -P)
cd "${project_dir}"

# copy STDOUT file descriptor to allow capture while streaming
exec 5>&1
# close extra file descriptor on exit
trap "exec 5>&-" EXIT

INVALID="$(scripts/invalid-image-types.sh | tee /dev/fd/5)"

if [[ "${INVALID}" != "" ]]; then
  exit 1
fi
