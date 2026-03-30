#!/bin/bash
# ============================================================
# Script 4: Log File Analyzer
# Author: VIDHI LUNIYA | Reg No: 24BSA100077
# Course: Open Source Software | OSS NGMC Capstone
# Description: Reads a log file line by line, counts keyword
#              occurrences, shows last 5 matches, and retries
#              with a fallback if the file is empty.
# Usage: ./script4_log_analyzer.sh <logfile> [keyword]
#        Example: ./script4_log_analyzer.sh /var/log/syslog error
# ============================================================

# --- Accept log file path and optional keyword from arguments ---
LOGFILE=$1                  # First argument: path to log file
KEYWORD=${2:-"error"}       # Second argument: keyword (default: "error")
COUNT=0                     # Counter for matching lines
MAX_RETRIES=3               # Maximum retry attempts if file is empty

echo "================================================================"
echo "              Log File Analyzer                                 "
echo "================================================================"
echo "  Log file : $LOGFILE"
echo "  Keyword  : $KEYWORD"
echo ""

# --- Validate that a log file argument was provided ---
if [ -z "$LOGFILE" ]; then
    echo "  ERROR: No log file specified."
    echo "  Usage: $0 <logfile> [keyword]"
    echo "  Example: $0 /var/log/syslog error"
    exit 1
fi

# --- Check that the file exists and is a regular file ---
if [ ! -f "$LOGFILE" ]; then
    echo "  ERROR: File '$LOGFILE' not found."
    echo "  Tip: Try /var/log/syslog, /var/log/messages, or /var/log/auth.log"
    exit 1
fi

# ---------------------------------------------------------------
# RETRY LOOP: Check if file is empty; retry up to MAX_RETRIES times
# This simulates a do-while pattern using a while loop with a counter
# ---------------------------------------------------------------
ATTEMPT=0
while [ $ATTEMPT -lt $MAX_RETRIES ]; do
    ATTEMPT=$((ATTEMPT + 1))    # Increment attempt counter

    # Check if file has content (non-zero size)
    if [ -s "$LOGFILE" ]; then
        echo "  File check : OK (non-empty, attempt $ATTEMPT)"
        break   # Exit retry loop — file has content
    else
        echo "  WARNING: File is empty (attempt $ATTEMPT of $MAX_RETRIES)"

        # On last attempt, try a fallback log file
        if [ $ATTEMPT -eq $MAX_RETRIES ]; then
            # Try common alternative log locations
            for FALLBACK in /var/log/syslog /var/log/messages /var/log/kern.log; do
                if [ -s "$FALLBACK" ]; then
                    echo "  Falling back to: $FALLBACK"
                    LOGFILE=$FALLBACK    # Switch to fallback log
                    break
                fi
            done
        else
            sleep 1     # Brief pause before retrying
        fi
    fi
done

echo ""

# ---------------------------------------------------------------
# MAIN LOOP: Read file line by line using while-read
# Count lines that match the keyword (case-insensitive)
# ---------------------------------------------------------------
echo "[ SCANNING FILE: $LOGFILE ]"
echo "----------------------------------------------------------------"

# Temporary file to store matching lines
TMPFILE=$(mktemp)

# Read each line from the log file
while IFS= read -r LINE; do
    # Use grep with -i for case-insensitive matching and -q for quiet mode
    if echo "$LINE" | grep -iq "$KEYWORD"; then
        COUNT=$((COUNT + 1))        # Increment match counter
        echo "$LINE" >> "$TMPFILE"  # Save matching line to temp file
    fi
done < "$LOGFILE"

echo ""

# ---------------------------------------------------------------
# RESULTS: Print summary and last 5 matching lines
# ---------------------------------------------------------------
echo "[ RESULTS ]"
echo "  Keyword '$KEYWORD' found $COUNT time(s) in $LOGFILE"
echo ""

# Show last 5 matching lines if any were found
if [ $COUNT -gt 0 ]; then
    echo "[ LAST 5 MATCHING LINES ]"
    echo "----------------------------------------------------------------"
    # Use tail to get last 5 lines from the collected matches
    tail -5 "$TMPFILE" | while IFS= read -r MATCH_LINE; do
        echo "  >> $MATCH_LINE"
    done
else
    echo "  No lines matching '$KEYWORD' were found."
    echo "  Try a different keyword: error, warning, failed, denied"
fi

echo ""

# ---------------------------------------------------------------
# BONUS: Show basic log file statistics
# ---------------------------------------------------------------
echo "[ FILE STATISTICS ]"
TOTAL_LINES=$(wc -l < "$LOGFILE")   # Total number of lines in the file
FILE_SIZE=$(du -sh "$LOGFILE" | cut -f1)
echo "  Total lines    : $TOTAL_LINES"
echo "  Matching lines : $COUNT"
echo "  File size      : $FILE_SIZE"

# Calculate match percentage if there are lines to count
if [ $TOTAL_LINES -gt 0 ]; then
    PERCENT=$(awk "BEGIN {printf \"%.1f\", ($COUNT/$TOTAL_LINES)*100}")
    echo "  Match rate     : $PERCENT%"
fi

# Clean up temporary file
rm -f "$TMPFILE"

echo ""
echo "================================================================"
