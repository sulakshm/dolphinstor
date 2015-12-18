#!/bin/bash

# Update below MINIONS count macro as per your need.
MINIONS=3

sed -i.bak "s/\(.*\)count=.*/\1count=${MINIONS}/" minion-install.tf

echo "Ensure terraform.tfvars is updated with right DO credentials"
echo "Running Cluster creation will take significant time..."
echo "Script has been successfully setup, for your configuration"
echo "Apply \"terraform apply\" to create the cluster"
echo "If failures are seen, then one can retry with \"terraform destroy\" and rerun \"apply\" again"
echo "Cluster script setup OK."
