#!/usr/bin/env bash

# Generates Ngindox html by pulling the latest yaml from the adminrouter package in the dcos github repo.
#
# Usage: scripts/update-ngindox.sh <version-prefix> [org/repo]
# Example: scripts/update-ngindox.sh 1.10

set -o errexit -o nounset -o pipefail

project_dir=$(cd "$(dirname "${BASH_SOURCE}")/.." && pwd -P)
cd "${project_dir}"

DCOS_VERSION="${1:-}"
if [[ -z "${DCOS_VERSION}" ]]; then
  echo >&2 "ERROR: Must provide a DC/OS version (ex: update-ngindox.sh 1.10)"
  exit 2
fi
if [[ ! -d "${DCOS_VERSION}/api" ]]; then
  echo >&2 "ERROR: Invalid DC/OS version - <repo>/${DCOS_VERSION}/api not found"
  exit 2
fi

DCOS_REPO="${2:-dcos/dcos}"
DCOS_VERSION_TAG="${DCOS_VERSION}.x"

for FILE_PREFIX in "nginx.master" "nginx.agent"; do
  # download ngindox yaml
  echo "Downloading ${FILE_PREFIX}.yaml (${DCOS_VERSION_TAG})..."
  curl --fail --location --silent --show-error \
       -o "${DCOS_VERSION}/api/${FILE_PREFIX}.yaml" \
       "https://raw.githubusercontent.com/${DCOS_REPO}/${DCOS_VERSION_TAG}/packages/adminrouter/extra/src/docs/api/${FILE_PREFIX}.yaml"

  # generate ngindox html
  echo "Generating ${DCOS_VERSION}/api/${FILE_PREFIX}.html..."
  docker run --rm -v "$PWD/${DCOS_VERSION}/api:/api" \
         karlkfi/ngindox ui --css '' --javascript '' -f "/api/${FILE_PREFIX}.yaml" > "${DCOS_VERSION}/api/${FILE_PREFIX}.html"

  # delete ngindox yaml
  echo "Deleting ${FILE_PREFIX}.yaml..."
  rm "${DCOS_VERSION}/api/${FILE_PREFIX}.yaml"
done

echo "Complete!"
