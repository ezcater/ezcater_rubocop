#!/bin/bash

# Checks the validity of RuboCop config files in `conf/` directory (excluding the base config).

CONFIGS=(
  "conf/rubocop_gem.yml"
  "conf/rubocop_rails.yml"
)

exit_code=0

for config in "${CONFIGS[@]}"; do
  if ! output=$(bundle exec rubocop --show-cops -c "$config" 2>&1); then
    echo "❌ Error in $config"
    echo "$output"
    exit_code=1
  fi
done

if [[ $exit_code -eq 0 ]]; then
  echo "✅ All configs are valid"
fi
exit $exit_code
