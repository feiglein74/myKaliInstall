#!/bin/bash
# Update Routine
sudo apt -qq -y update
sudo apt -qq -y upgrade
sudo apt -qq -y dist-upgrade
sudo apt -qq -y autoremove