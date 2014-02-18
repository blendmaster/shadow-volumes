#!/usr/bin/env bash

viewer "$@"&
PID=$!

inotifywait --monitor --format '%f %e' --event MODIFY shaders/* | \
while read change event; do
  echo $change $event
  kill $PID
  viewer "$@"&
  PID=$!
done
