#!/bin/bash
# kernel build script by thehacker911
KERNEL_DIR=$(pwd)

echo "Make Changelog from Github Repo"
github_changelog_generator HRTKernel/Hacker_Kernel_SM-G92X
echo "Done!"