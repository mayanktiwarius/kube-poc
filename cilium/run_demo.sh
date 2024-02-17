#!/bin/bash
set -x
./bring_up_setup.sh
./test_connection.sh
./apply_l4_policy.sh
./test_connection.sh
./apply_l7_policy.sh
./test_connection.sh
./cleanup_setup.sh