#!/usr/bin/env bash
cd $(dirname $0)

# warm up the compiler
cat targets.txt | vegeta attack -rate 100 -duration 1s > /dev/null

# perform the stress test
cat targets.txt | timeout 7s vegeta attack -rate 200 -duration 5s | vegeta report
exit ${PIPESTATUS[1]}
