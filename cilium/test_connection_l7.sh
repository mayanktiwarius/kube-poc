#!/bin/bash

echo "Requesting landing from tiefighter to deathstar on enabled api"
timeout 2 kubectl exec tiefighter -- curl -s -XPOST deathstar.default.svc.cluster.local/v1/request-landing
if [ $? -ne 0 ]; then
    echo "Request for landing of tiefighter to deathstar failed"
fi


echo "Requesting landing from tiefighter to deathstar on disabled api"
timeout 2 kubectl exec tiefighter -- curl -s -XPUT deathstar.default.svc.cluster.local/v1/exhaust-port
if [ $? -ne 0 ]; then
    echo "Request for landing of tiefighter to deathstar failed"
fi