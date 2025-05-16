#!/bin/bash

cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit 1

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

if [ ! -f "$(npm root)"/.bin/tsc ]; then
  echo "::group::🔄 Running npm install to install tsc ..."
  npm install
  echo "::endgroup::"
fi

if [ ! -f "$(npm root)"/.bin/tsc ]; then
  echo "❌ Unable to locate or install tsc. Did you provide a workdir which contains a valid package.json?"
  exit 1
else

  echo ℹ️ tsc version: "$("$(npm root)"/.bin/tsc --version)"

  echo "::group::📝 Running tsc with reviewdog 🐶 ..."

  # shellcheck disable=SC2086
  "$(npm root)"/.bin/tsc ${INPUT_TSC_FLAGS} |
    reviewdog -f=tsc \
      -name="${INPUT_TOOL_NAME}" \
      -reporter="${INPUT_REPORTER}" \
      -filter-mode="${INPUT_FILTER_MODE}" \
      -fail-level="${INPUT_FAIL_LEVEL}" \
      -level="${INPUT_LEVEL}" \
      ${INPUT_REVIEWDOG_FLAGS}

  reviewdog_rc=$?
  echo "::endgroup::"
  exit $reviewdog_rc

fi
