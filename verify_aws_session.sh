#!/usr/bin/env bash

if /snap/bin/aws sts get-caller-identity --output json; then
	printf '%s\n' '[SUCCESS] AWS Session is active and secure.'
else
	printf '%s\n' '[ERROR] AWS Token expired or missing. Please run: /snap/bin/aws configure sso --use-device-code'
fi
