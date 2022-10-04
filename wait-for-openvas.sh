#!/bin/sh
# helper script to wait until the deployment openvas is running

while [ "$(kubectl get pods | awk '/openvas/{print $3}')" != "Running" ]; do
  echo "waiting for openvas" && sleep 5
done
