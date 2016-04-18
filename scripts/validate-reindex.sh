#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE}")/.." && pwd -P)"

reindex_out="$(${REPO_ROOT}/scripts/reindex.sh)"
if [[ -n "${reindex_out}" ]]; then
  echo "Invalid index: file name matches directory name" >&2
  echo "${reindex_out}" >&2
  echo "Please run 'scripts/reindex.sh'" >&2
  exit 1
fi
