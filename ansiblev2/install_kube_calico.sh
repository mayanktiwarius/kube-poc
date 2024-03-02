#!/bin/bash
ansible-playbook -i ./inventory/inventory.ini -e @/vagrant/settings.yaml kube-master-setup.yml --skip-tags "cilium,calico_vpp"