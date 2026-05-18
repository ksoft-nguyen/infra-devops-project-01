#!/bin/sh
set -eu

deploy_branch="${GIT_BRANCH:-${DEPLOY_GIT_BRANCH:-main}}"
project_source_dir="${PROJECT_SOURCE_DIR:?PROJECT_SOURCE_DIR is required}"
app_stack_dir="${APP_STACK_DIR:-${project_source_dir}/resource}"
app_env_file="${APP_ENV_FILE:-${app_stack_dir}/.env}"
app_make_project="${APP_MAKE_PROJECT:-mern-todo}"

cd "${project_source_dir}"
git fetch --prune origin "${deploy_branch}"
git checkout -B "${deploy_branch}" "origin/${deploy_branch}"
git reset --hard "origin/${deploy_branch}"

cd "${app_stack_dir}"
make prod PROJECT="${app_make_project}" ENV_FILE="${app_env_file}"
make prod-ps PROJECT="${app_make_project}" ENV_FILE="${app_env_file}"
