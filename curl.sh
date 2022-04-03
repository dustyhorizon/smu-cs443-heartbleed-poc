#!/bin/bash

curl \
    --silent \
    --insecure \
    --max-time .1 \
    --data THISISHEARTBLEEDSTRING=SUPERSECRET \
    https://localhost:8443
