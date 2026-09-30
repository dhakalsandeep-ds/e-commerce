#!/usr/bin/env bash

set -o errexit

bundle install
npm install

echo "===== BEFORE BUILD ====="
ls -la app/assets/builds || true

echo "===== MASTER KEY CHECK ====="

if [ -n "$RAILS_MASTER_KEY" ]; then
  echo "RAILS_MASTER_KEY is present"
else
  echo "RAILS_MASTER_KEY is MISSING"
fi


echo "===== ASSET PATHS ====="
RAILS_ENV=production bin/rails runner \
  'puts Rails.application.config.assets.paths'

echo "===== PRECOMPILE ====="
RAILS_ENV=production bin/rails assets:precompile

echo "===== BUILDS ====="
ls -la app/assets/builds

echo "===== PUBLIC TAILWIND ====="
find public/assets -name '*tailwind*' -ls || true
