#!/bin/bash

# Register git deploy key with ssh-agent.
function add_ssh_creds () {
  local GIT_PRIVATE_KEY=$1
  local APP_DIR=$2

  if [ -n "$GIT_PRIVATE_KEY" ]; then
    eval `ssh-agent -s`
    GIT_PRIVATE_KEY_FILE=$APP_DIR/.creds
    echo "$GIT_PRIVATE_KEY" > $GIT_PRIVATE_KEY_FILE
    chmod 600 $GIT_PRIVATE_KEY_FILE
    ssh-add $GIT_PRIVATE_KEY_FILE ; EXIT_STATUS=$?
    rm -f $GIT_PRIVATE_KEY_FILE
    if [ $EXIT_STATUS != "0" ] ; then
      echo "Git deploy key register with ssh-agent failed (EXIT_STATUS=$EXIT_STATUS)"
      exit 1
    fi
  fi
}

# De-register git deploy key with ssh-agent.
function remove_ssh_creds () {
  local GIT_PRIVATE_KEY=$1

  if [ -n "$GIT_PRIVATE_KEY" ]; then
    ssh-agent -k
  fi
}

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
add_ssh_creds "$GIT_PRIVATE_KEY" "$app_dir"

if [ ! -z "$BRANCH_NAME" ]; then
  git clone $GIT_URL -b $BRANCH_NAME $app_dir
else
  git clone $GIT_URL $app_dir
fi

remove_ssh_creds "$GIT_PRIVATE_KEY"
#cat | tar -xC $app_dir
pushd $app_dir
$TEST_CMD
