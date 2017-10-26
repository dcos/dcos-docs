#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

# mime-type -> extension
declare -A TYPE_MAP
TYPE_MAP[svg+xml]='svg'
TYPE_MAP[jpeg]='jpg'

FILES="$(find . -type f -name '*' -print | grep -v '^./.git' | grep -v '^./.idea' | grep -v '.md$')"

while read -r FILE_PATH; do
  TYPE="$(file -b --mime-type "${FILE_PATH}")"
  if [[ "${TYPE}" == "image/"* ]]; then
    FILE_NAME=$(basename "${FILE_PATH}")
    FILE_EXT="${FILE_NAME##*.}"
    IMG_TYPE="${TYPE##*/}"
    if [[ -n "${TYPE_MAP[$IMG_TYPE]:-}" ]]; then
      IMG_TYPE="${TYPE_MAP[$IMG_TYPE]:-}"
    fi
    if [[ "${FILE_EXT}" != "${IMG_TYPE}" ]]; then
      EXPECTED_PATH="$(dirname "${FILE_PATH}")/${FILE_NAME%.*}.${IMG_TYPE}"
      echo "${FILE_PATH} ${EXPECTED_PATH}"
    fi
  fi
done <<< "${FILES}"
