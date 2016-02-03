#!/bin/bash
set -x
swift --os-auth-token ${OSTK}  --os-storage-url ${OSURL} $@
