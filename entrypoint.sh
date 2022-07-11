#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /myapp/tmp/pids/server.pid

# create db and run migrations if they don't exits
bin/rails db:create
bin/rails db:migrate
bin/rails db:migrate:status

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
