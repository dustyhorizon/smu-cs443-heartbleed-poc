# Proof of concept for CVE-2014-0160

## Setup

### Requirements

- docker
- docker-compose
- python3

### Steps

Run `docker-compose up -d --build`

A webserver should be running on localhost:8443 (forwarded to the vulnerable webserver)

## Reproduction

Run `bash curl.sh` to send dummy requests to the vulnerable webserver

Run `python3 expoit.py --port 8443 localhost` in order to "bleed" the curl request that was sent previously.
