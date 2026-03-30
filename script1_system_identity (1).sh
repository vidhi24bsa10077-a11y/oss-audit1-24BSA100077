#!/bin/bash
# ============================================================
# Script 1: System Identity Report
# Author: VIDHI LUNIYA | Reg No: 24BSA100077
# Course: Open Source Software | OSS NGMC Capstone
# Description: Displays a welcome screen with system info
#              and open-source license details for the OS.
# ============================================================

# --- Student and project variables ---
STUDENT_NAME="VIDHI LUNIYA"
REG_NO="24BSA100077"
SOFTWARE_CHOICE="Python"
SOFTWARE_LICENSE="PSF License (Python Software Foundation License)"

# --- Gather system information using command substitution ---
KERNEL=$(uname -r)                          # Linux kernel version
DISTRO=$(lsb_release -d 2>/dev/null | cut -f2 || cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '"')
USER_NAME=$(whoami)                         # Current logged-in user
HOME_DIR=$HOME                              # Home directory of current user
UPTIME=$(uptime -p)                         # Human-readable uptime
CURRENT_DATE=$(date '+%A, %d %B %Y')        # e.g. Monday, 01 January 2025
CURRENT_TIME=$(date '+%H:%M:%S')            # e.g. 14:35:22
OS_LICENSE="GPL v2 (GNU General Public License version 2)"  # Linux kernel license

# --- Display formatted welcome banner ---
echo "================================================================"
echo "         Open Source Audit — System Identity Report             "
echo "================================================================"
echo "  Student  : $STUDENT_NAME"
echo "  Reg No   : $REG_NO"
echo "  Software : $SOFTWARE_CHOICE"
echo "================================================================"
echo ""

# --- System information section ---
echo "[ SYSTEM INFORMATION ]"
echo "  Distribution : $DISTRO"
echo "  Kernel       : $KERNEL"
echo "  User         : $USER_NAME"
echo "  Home Dir     : $HOME_DIR"
echo ""

# --- Time and uptime section ---
echo "[ TIME & UPTIME ]"
echo "  Date         : $CURRENT_DATE"
echo "  Time         : $CURRENT_TIME"
echo "  Uptime       : $UPTIME"
echo ""

# --- License information section ---
echo "[ OPEN SOURCE LICENSE INFO ]"
echo "  OS License      : $OS_LICENSE"
echo "  This means: You are free to run, study, modify, and"
echo "  redistribute the Linux kernel, but any modifications"
echo "  must also be released under the GPL v2."
echo ""
echo "  Audited Software : $SOFTWARE_CHOICE"
echo "  Software License : $SOFTWARE_LICENSE"
echo "  This means: Python is free to use, modify, and distribute"
echo "  even for commercial purposes, with minimal restrictions."
echo ""

# --- Python-specific check ---
echo "[ PYTHON INSTALLATION CHECK ]"
# Check if python3 is available on this system
if command -v python3 &>/dev/null; then
    PY_VERSION=$(python3 --version)         # Get installed Python version
    PY_PATH=$(which python3)                # Get path to Python binary
    echo "  Python found : $PY_VERSION"
    echo "  Binary path  : $PY_PATH"
else
    echo "  Python3 is not installed on this system."
fi

echo ""
echo "================================================================"
echo "  Open source is not just a license. It is a philosophy."
echo "================================================================"
