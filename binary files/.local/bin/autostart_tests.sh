#!/bin/bash

while sleep 0.2
do
    fd .go | entr -d go test
done
