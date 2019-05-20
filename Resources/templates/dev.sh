#!/bin/sh
link=$1
navigation="list"

# Link with navigation form of choice
cd list/Sources/Forms
if [[ $link ]]; then
  ln -s ../../../navigation/$navigation/Sources/Forms/Navigation
else
  if [ -L "Navigation" ]; then
    rm "Navigation"
  fi
fi
