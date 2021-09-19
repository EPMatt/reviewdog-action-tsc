#!/bin/bash

cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit 1

TEMP_PATH="$(mktemp -d)"
PATH="${TEMP_PATH}:$PATH"
export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

echo "::group::🐶 Installing reviewdog ... https://github.com/reviewdog/reviewdog"
curl -sfL https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh | sh -s -- -b "${TEMP_PATH}" "${REVIEWDOG_VERSION}" 2>&1
echo "::endgroup::"

if [ ! -f "$(npm bin)/tsc" ]; then
  echo "::group::🔄 Running `npm install` to install tsc ..."
  npm install
  echo "::endgroup::"
fi

if [ ! -f "$(npm bin)/tsc" ]; then
  echo "❌ Unable to locate or install tsc. Did you provide a workdir which contains a valide package.json?"
  exit 1
else

  echo "ℹ️ tsc version:"$("$(npm bin)"/tsc --version)""

  echo "::group::📝 Running tsc with reviewdog 🐶 ..."

  "$(npm bin)"/tsc ${INPUT_TSC_FLAGS:-"."} \
    | reviewdog -f=tsc \
      -name="${INPUT_TOOL_NAME}" \
      -reporter="${INPUT_REPORTER:-github-pr-review}" \
      -filter-mode="${INPUT_FILTER_MODE}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
      -level="${INPUT_LEVEL}" \
      ${INPUT_REVIEWDOG_FLAGS}

  reviewdog_rc=$?
  echo "::endgroup::"
  exit $reviewdog_rc

fi