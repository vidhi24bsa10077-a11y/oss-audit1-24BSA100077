#!/bin/bash
# ============================================================
# Script 3: Disk and Permission Auditor
# Author: VIDHI LUNIYA | Reg No: 24BSA100077
# Course: Open Source Software | OSS NGMC Capstone
# Description: Loops through key system directories and
#              reports permissions, owner, and disk usage.
#              Also checks Python-specific directories.
# ============================================================

# --- Define list of standard system directories to audit ---
DIRS=("/etc" "/var/log" "/home" "/usr/bin" "/tmp" "/usr/lib" "/opt")

# --- Define Python-specific directories to check separately ---
PYTHON_DIRS=("/usr/lib/python3" "/usr/lib64/python3" "/usr/local/lib/python3"
             "/usr/lib/python3.10" "/usr/lib/python3.11" "/usr/lib/python3.12")

echo "================================================================"
echo "           Disk and Permission Auditor                          "
echo "================================================================"
echo ""

# ---------------------------------------------------------------
# SECTION 1: Standard system directory audit using a for loop
# ---------------------------------------------------------------
echo "[ SYSTEM DIRECTORY AUDIT ]"
echo "  Format: path => permissions owner group | size"
echo "----------------------------------------------------------------"

for DIR in "${DIRS[@]}"; do
    # Check if the directory actually exists before inspecting it
    if [ -d "$DIR" ]; then
        # Use ls -ld and awk to extract permission string, owner, group
        PERMS=$(ls -ld "$DIR" | awk '{print $1}')   # e.g. drwxr-xr-x
        OWNER=$(ls -ld "$DIR" | awk '{print $3}')   # e.g. root
        GROUP=$(ls -ld "$DIR" | awk '{print $4}')   # e.g. root

        # Use du -sh to get human-readable directory size; suppress errors
        SIZE=$(du -sh "$DIR" 2>/dev/null | cut -f1)

        printf "  %-20s => %-12s %-8s %-8s | %s\n" \
               "$DIR" "$PERMS" "$OWNER" "$GROUP" "$SIZE"
    else
        # Directory does not exist on this system
        printf "  %-20s => [does not exist on this system]\n" "$DIR"
    fi
done

echo ""

# ---------------------------------------------------------------
# SECTION 2: Python-specific configuration and library directories
# ---------------------------------------------------------------
echo "[ PYTHON INSTALLATION DIRECTORIES ]"
echo "  Checking for Python library paths..."
echo "----------------------------------------------------------------"

FOUND_PYTHON_DIR=false  # Flag to track if any Python dir was found

for PYDIR in "${PYTHON_DIRS[@]}"; do
    # Check each candidate Python directory
    if [ -d "$PYDIR" ]; then
        PERMS=$(ls -ld "$PYDIR" | awk '{print $1}')
        OWNER=$(ls -ld "$PYDIR" | awk '{print $3}')
        SIZE=$(du -sh "$PYDIR" 2>/dev/null | cut -f1)
        printf "  %-35s => %s  owner:%-8s  size:%s\n" \
               "$PYDIR" "$PERMS" "$OWNER" "$SIZE"
        FOUND_PYTHON_DIR=true
    fi
done

# If none of the candidate paths exist, try to find Python dynamically
if [ "$FOUND_PYTHON_DIR" = false ]; then
    echo "  Standard Python library paths not found."
    # Use python3 itself to report its library location
    if command -v python3 &>/dev/null; then
        PY_LIB=$(python3 -c "import sys; print(sys.prefix)" 2>/dev/null)
        echo "  Python prefix reported as: $PY_LIB"
        ls -ld "$PY_LIB" 2>/dev/null
    else
        echo "  Python3 is not installed on this system."
    fi
fi

echo ""

# ---------------------------------------------------------------
# SECTION 3: Python binary location and permissions
# ---------------------------------------------------------------
echo "[ PYTHON BINARY PERMISSIONS ]"
echo "----------------------------------------------------------------"

# Check the python3 binary specifically
if command -v python3 &>/dev/null; then
    PY_BIN=$(which python3)                         # Full path to binary
    BIN_PERMS=$(ls -l "$PY_BIN" | awk '{print $1, $3, $4}')
    BIN_SIZE=$(ls -lh "$PY_BIN" | awk '{print $5}')
    echo "  Binary   : $PY_BIN"
    echo "  Perms    : $BIN_PERMS"
    echo "  Size     : $BIN_SIZE"
    echo ""
    echo "  Why this matters for security:"
    echo "  Python runs as the invoking user by default. Scripts with"
    echo "  world-write permission on /usr/bin/python3 would allow any"
    echo "  user to replace the interpreter — a serious privilege-"
    echo "  escalation risk. Open source makes this auditable."
else
    echo "  python3 binary not found in PATH."
fi

echo ""
echo "================================================================"
echo "  Audit complete. Review permissions for any world-writable"
echo "  directories — these may pose a security risk."
echo "================================================================"
