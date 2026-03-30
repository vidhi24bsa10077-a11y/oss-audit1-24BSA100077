#!/bin/bash
# ============================================================
# Script 5: Open Source Manifesto Generator
# Author: VIDHI LUNIYA | Reg No: 24BSA100077
# Course: Open Source Software | OSS NGMC Capstone
# Description: Asks the user three questions interactively
#              and generates a personalised open source
#              philosophy statement saved to a .txt file.
# ============================================================

# --- Alias concept demonstrated via a comment and function ---
# In a real shell session you might define:
#   alias greet='echo "Hello, open source world!"'
# Here we use a shell function as the scripting equivalent:
greet_user() {
    echo "  Welcome, $1. Let us capture your open source philosophy."
}

# --- Display header ---
echo "================================================================"
echo "        Open Source Manifesto Generator                        "
echo "================================================================"
echo ""

# --- Greet the current user ---
greet_user "$(whoami)"
echo ""
echo "  Answer three questions. Your answers will be woven into"
echo "  a personal open source manifesto and saved to a file."
echo ""
echo "----------------------------------------------------------------"

# ---------------------------------------------------------------
# INTERACTIVE INPUT: Read three responses from the user
# using the 'read' built-in with -p for inline prompts
# ---------------------------------------------------------------

# Question 1: A tool they use daily
read -p "  1. Name one open-source tool you use every day: " TOOL

# Question 2: What freedom means to them (single word)
read -p "  2. In one word, what does 'freedom' mean to you? " FREEDOM

# Question 3: Something they would build and share
read -p "  3. Name one thing you would build and share freely: " BUILD

echo ""
echo "  Generating your manifesto..."
echo ""

# --- Metadata ---
DATE=$(date '+%d %B %Y')            # e.g. 01 January 2025
TIME=$(date '+%H:%M')               # e.g. 14:35
AUTHOR=$(whoami)                    # Current user's login name
OUTPUT="manifesto_${AUTHOR}.txt"   # Output filename includes username

# ---------------------------------------------------------------
# STRING CONCATENATION: Build the manifesto paragraph
# by combining variables with fixed text using echo and >>
# ---------------------------------------------------------------

# Write title and metadata to output file (> overwrites, >> appends)
echo "================================================================" > "$OUTPUT"
echo "  MY OPEN SOURCE MANIFESTO" >> "$OUTPUT"
echo "  Generated on $DATE at $TIME by $AUTHOR" >> "$OUTPUT"
echo "================================================================" >> "$OUTPUT"
echo "" >> "$OUTPUT"

# Write the main manifesto paragraph using the user's three answers
echo "  Every day, I rely on $TOOL — a tool I did not pay for," >> "$OUTPUT"
echo "  did not have to ask permission to use, and can inspect" >> "$OUTPUT"
echo "  down to its last line of code. To me, that is $FREEDOM." >> "$OUTPUT"
echo "" >> "$OUTPUT"
echo "  Open source software is not just a licensing model." >> "$OUTPUT"
echo "  It is an act of trust — a belief that knowledge shared" >> "$OUTPUT"
echo "  is knowledge multiplied. When I build something, I want" >> "$OUTPUT"
echo "  it to outlast me. That is why I would share $BUILD freely:" >> "$OUTPUT"
echo "  so that someone, somewhere, can stand on what I built" >> "$OUTPUT"
echo "  and reach further than I ever could." >> "$OUTPUT"
echo "" >> "$OUTPUT"
echo "  The greatest software in the world — Linux, Python, Git —" >> "$OUTPUT"
echo "  was not locked in a boardroom. It was released into the" >> "$OUTPUT"
echo "  commons. I choose to be part of that tradition." >> "$OUTPUT"
echo "" >> "$OUTPUT"

# Write a closing signature
echo "  — $AUTHOR | $DATE" >> "$OUTPUT"
echo "" >> "$OUTPUT"
echo "================================================================" >> "$OUTPUT"

# ---------------------------------------------------------------
# OUTPUT: Confirm save location and display the file contents
# ---------------------------------------------------------------
echo "  Manifesto saved to: $OUTPUT"
echo ""
echo "================================================================"

# Display the generated manifesto using cat
cat "$OUTPUT"

echo ""
echo "================================================================"
echo "  Tip: Add this to your GitHub repo README or profile page."
echo "================================================================"
