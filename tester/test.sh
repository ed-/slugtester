#!/bin/bash

if [ -z "$GIT_URL" ]; then
  echo GIT_URL unspecified
        exit 1
fi

if [ -z "$TEST_CMD" ]; then
  echo TEST_CMD unspecified
        exit 1
fi

app_dir=/app
mkdir -p $app_dir
if [ ! -z "$BRANCH_NAME" ]; then
  git clone $GIT_URL -b $BRANCH_NAME $app_dir
else
  git clone $GIT_URL $app_dir
fi
#cat | tar -xC $app_dir
pushd $app_dir
$TEST_CMD
