#!/bin/sh

env=$1
fails=""

inspect() {
  if [ $1 -ne 0 ]; then
    fails="${fails} $2"
  fi
}

# run client and server-side tests
dev() {
  docker-compose -f docker-compose-dev.yml up -d --build
  docker-compose -f docker-compose-dev.yml run users python manage.py test
  inspect $? users
  docker-compose -f docker-compose-dev.yml run users flake8 project
  inspect $? users-lint
  docker-compose -f docker-compose-dev.yml run client npm test -- --coverage
  inspect $? client
  docker-compose -f docker-compose-dev.yml down
}

# run e2e tests
e2e() {
  docker-compose -f docker-compose-dev.yml up -d --build
  ./node_modules/.bin/cypress run
  inspect $? e2e
  docker-compose -f docker-compose-dev.yml down
}

# run appropriate tests
if [[ "${env}" == "development" ]]; then
  echo "\n"
  echo "Running client and server-side tests!\n"
  dev
elif [[ "${env}" == "staging" ]]; then
  echo "\n"
  echo "Running e2e tests!\n"
  e2e
elif [[ "${env}" == "production" ]]; then
  echo "\n"
  echo "Running e2e tests!\n"
  e2e
else
  echo "\n"
  echo "Running client and server-side tests!\n"
  dev
fi

# return proper code
if [ -n "${fails}" ]; then
  echo "Tests failed: ${fails}"
  exit 1
else
  echo "Tests passed!"
  exit 0
fi
