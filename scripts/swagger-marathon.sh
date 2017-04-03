#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

DCOS_VERSION=${1}
EMAIL=${2}
PASSWORD=${3}

XTMP_DIR="$(mktemp -d temp-XXX)"
cd "${XTMP_DIR}"

curl --fail --location --silent --show-error "https://raw.githubusercontent.com/dcos/dcos/${DCOS_VERSION}/packages/marathon/buildinfo.json" | jq --raw-output '.single_source.url' | xargs curl --fail --location --silent --show-error | tar -zx --strip-components=6 */docs/docs/rest-api/public/api

zip -q -r api.zip .

apimatic-cli transform fromuser --email "${EMAIL}" --password "${PASSWORD}" --file api.zip --format SwaggerYaml --download-to . --download-as marathon.yaml

cat marathon.yaml

cd ..
rm -rf "${XTMP_DIR}"
