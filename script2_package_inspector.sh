#!/bin/bash
# ============================================================
# Script 2: FOSS Package Inspector
# Author: VIDHI LUNIYA | Reg No: 24BSA100077
# Course: Open Source Software | OSS NGMC Capstone
# Description: Checks if a FOSS package is installed,
#              displays version/license info, and prints
#              a philosophy note via a case statement.
# Usage: ./script2_package_inspector.sh [package_name]
#        If no argument given, defaults to python3
# ============================================================

# --- Set package name from argument or default to python3 ---
PACKAGE=${1:-python3}

echo "================================================================"
echo "           FOSS Package Inspector                               "
echo "================================================================"
echo "  Inspecting package: $PACKAGE"
echo ""

# --- Detect package manager and check installation ---
# Different Linux distros use different package managers
if command -v rpm &>/dev/null; then
    # RPM-based systems (Fedora, RHEL, CentOS)
    PKG_MANAGER="rpm"
elif command -v dpkg &>/dev/null; then
    # Debian-based systems (Ubuntu, Debian, Mint)
    PKG_MANAGER="dpkg"
else
    PKG_MANAGER="unknown"
fi

echo "[ INSTALLATION CHECK — using $PKG_MANAGER ]"

# --- Check if package is installed using if-then-else ---
if [ "$PKG_MANAGER" = "rpm" ]; then
    if rpm -q "$PACKAGE" &>/dev/null; then
        echo "  Status  : INSTALLED"
        # Use grep with pipe to extract key fields from rpm info
        echo ""
        echo "[ PACKAGE DETAILS ]"
        rpm -qi "$PACKAGE" | grep -E "^(Name|Version|License|Summary|URL)" | \
            awk -F': ' '{printf "  %-10s: %s\n", $1, $2}'
    else
        echo "  Status  : NOT INSTALLED"
        echo "  Tip     : Install with: sudo dnf install $PACKAGE"
    fi

elif [ "$PKG_MANAGER" = "dpkg" ]; then
    if dpkg -l "$PACKAGE" 2>/dev/null | grep -q "^ii"; then
        echo "  Status  : INSTALLED"
        echo ""
        echo "[ PACKAGE DETAILS ]"
        # Use pipe and grep to filter relevant lines from dpkg output
        dpkg -s "$PACKAGE" 2>/dev/null | grep -E "^(Package|Version|Maintainer|Homepage|Description)" | \
            awk -F': ' '{printf "  %-12s: %s\n", $1, $2}'
    else
        echo "  Status  : NOT INSTALLED"
        echo "  Tip     : Install with: sudo apt install $PACKAGE"
    fi

else
    # Fallback: try the 'command' check for any system
    if command -v "$PACKAGE" &>/dev/null; then
        echo "  Status  : Found via PATH ($(which $PACKAGE))"
    else
        echo "  Status  : Not found on this system."
    fi
fi

echo ""

# --- Case statement: print philosophy note for known FOSS packages ---
echo "[ OPEN SOURCE PHILOSOPHY NOTE ]"
case "$PACKAGE" in
    python3 | python)
        echo "  Python: Born from Guido van Rossum's belief that code"
        echo "  should be readable and accessible to everyone. Governed"
        echo "  by the PSF — a community, not a corporation."
        ;;
    httpd | apache2)
        echo "  Apache: The web server that democratised the internet."
        echo "  Built collaboratively since 1995, it proved that open"
        echo "  communities could outbuild proprietary rivals."
        ;;
    mysql | mariadb)
        echo "  MySQL/MariaDB: A lesson in dual licensing and community"
        echo "  forks. When Oracle acquired MySQL, the community forked"
        echo "  it into MariaDB — open source protecting itself."
        ;;
    git)
        echo "  Git: Linus Torvalds built Git in 2005 when BitKeeper"
        echo "  revoked its free license. Open source creating the very"
        echo "  infrastructure that open source depends on."
        ;;
    firefox)
        echo "  Firefox: A nonprofit browser fighting for an open web"
        echo "  against the dominance of proprietary browsers."
        echo "  Built by Mozilla — proof that mission can beat margin."
        ;;
    vlc)
        echo "  VLC: Started by students at École Normale Supérieure"
        echo "  in Paris. Plays anything because freedom means no"
        echo "  format left behind."
        ;;
    *)
        # Default case for packages not explicitly listed
        echo "  $PACKAGE is part of the open source ecosystem that"
        echo "  powers modern computing. Its source is available for"
        echo "  anyone to read, improve, and share."
        ;;
esac

echo ""
echo "================================================================"
