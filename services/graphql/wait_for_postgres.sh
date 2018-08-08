#!/bin/bash

set -e

connection="$1"
shift
cmd="$@"

until psql ${connection} -c '\q' 2>/dev/null; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 5
done

>&2 echo "Postgres is up - executing command"
exec ${cmd}
