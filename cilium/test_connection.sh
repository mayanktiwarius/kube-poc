#!/bin/bash
echo "Requesting landing from xwing to deathstar"
timeout 2 kubectl exec xwing -- curl -s -XPOST deathstar.default.svc.cluster.local/v1/request-landing
if [ $? -ne 0 ]; then
    echo "Request for landing of xwing to deathstar failed"
fi
echo "Requesting landing from tiefighter to deathstar"
timeout 2 kubectl exec tiefighter -- curl -s -XPOST deathstar.default.svc.cluster.local/v1/request-landing
if [ $? -ne 0 ]; then
    echo "Request for landing of tiefighter to deathstar failed"
fi