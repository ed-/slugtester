#!/bin/bash

if [ -z "$GIT_REPO" ]; then
  echo GIT_REPO unspecified
        exit 1
fi

if [ -z "$TEST_CMD" ]; then
  echo TEST_CMD unspecified
        exit 1
fi

app_dir=/app
mkdir -p $app_dir
cat | tar -xC $app_dir
pushd $app_dir
$TEST_CMD
