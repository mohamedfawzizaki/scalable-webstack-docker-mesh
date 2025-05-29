#!/bin/bash

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout localhost.key -out localhost.crt \
  -subj "/CN=localhost" -addext "subjectAltName=DNS:localhost"

echo "Certificates generated:"
ls -l localhost.*