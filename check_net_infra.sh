#!/bin/bash

set -euo pipefail

# DNS (DNS=192.168.0.123)
dig +short api.redfin.dev @192.168.0.123
dif +short mongo.redfin.dev @192.168.0.123

