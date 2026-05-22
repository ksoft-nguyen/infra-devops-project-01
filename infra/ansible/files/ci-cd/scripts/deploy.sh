#!/bin/sh
set -eu

step_name="initializing"

log() {
  printf '\n[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

fail() {
  status=$?
  printf '\n[ERROR] Step failed: %s (exit code %s)\n' "${step_name}" "${status}" >&2
  exit "${status}"
}

trap fail EXIT

step_name="resolve deploy configuration"
deploy_branch="${DEPLOY_BRANCH:-${DEPLOY_GIT_BRANCH:-main}}"
deploy_branch="${deploy_branch#refs/heads/}"
deploy_branch="${deploy_branch#origin/}"
project_source_dir="${PROJECT_SOURCE_DIR:?PROJECT_SOURCE_DIR is required}"
app_stack_dir="${APP_STACK_DIR:-${project_source_dir}/resource}"
app_env_file="${APP_ENV_FILE:-${app_stack_dir}/.env}"
app_make_project="${APP_MAKE_PROJECT:-mern-todo}"

log "Deploy branch: ${deploy_branch}"
log "Project source directory: ${project_source_dir}"
log "Application stack directory: ${app_stack_dir}"
log "Application env file: ${app_env_file}"
log "Docker Compose project: ${app_make_project}"

step_name="enter project source directory"
log "Entering project source directory"
cd "${project_source_dir}"

step_name="fetch branch from origin"
log "Fetching origin/${deploy_branch}"
git fetch --prune origin "${deploy_branch}"

step_name="checkout branch"
log "Checking out ${deploy_branch}"
git checkout -B "${deploy_branch}" "origin/${deploy_branch}"

step_name="reset branch to origin"
log "Resetting ${deploy_branch} to origin/${deploy_branch}"
git reset --hard "origin/${deploy_branch}"

step_name="enter application stack directory"
log "Entering application stack directory"
cd "${app_stack_dir}"

step_name="deploy production stack"
log "Starting production stack"
make prod PROJECT="${app_make_project}" ENV_FILE="${app_env_file}"

step_name="show production stack status"
log "Showing production stack status"
make prod-ps PROJECT="${app_make_project}" ENV_FILE="${app_env_file}"

trap - EXIT
log "Deployment completed successfully"
