#!/bin/bash

sudo yum repolist && \
sudo yum install epel-release -y && \
sudo yum install ansible -y
