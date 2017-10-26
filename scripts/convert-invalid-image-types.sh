#!/usr/bin/env bash

# Use imagemagick's convert to convert invalid images to the type of their suffix.
# http://www.imagemagick.org/script/convert.php
# brew install imagemagick

set -o errexit -o nounset -o pipefail

project_dir=$(cd "$(dirname "${BASH_SOURCE}")/.." && pwd -P)
cd "${project_dir}"

while read -r line; do
  CURRENT="$(echo "${line}" | cut -d' ' -f1)"
  EXPECTED="$(echo "${line}" | cut -d' ' -f2)"
  echo "Converting: ${CURRENT}"
  mv "${CURRENT}" "${CURRENT}.bak"
  convert "${CURRENT}.bak" "${CURRENT}"
  rm "${CURRENT}.bak"
done <<< "$(scripts/invalid-image-types.sh)"
