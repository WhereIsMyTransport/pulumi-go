#!/bin/bash
set -x

pulumi login $PULUMI_BACKEND --non-interactive --color never --logtostderr

pulumi $@ --non-interactive --color never --logtostderr