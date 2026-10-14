#!/usr/bin/env bash

set +e
output=$(uv run validate-all --files "data/*/*.xml" --rng "schema/tei_all.rng" --schematron "schema/schematron.sch" 2>&1)
status=$?
set -e

printf '%s\n' "$output"

if [[ "$output" == *"ERRORS!!!!"* ]]; then
	echo "Validation output contains ERRORS!!!!" >&2
	exit 1
fi

exit "$status"