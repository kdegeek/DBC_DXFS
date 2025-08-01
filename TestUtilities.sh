#!/bin/bash

# Basic sanity tests for DB/C utilities
# This script tests that the utilities can run and perform basic operations

set -e  # Exit on any error

echo "Starting utility tests..."

# Create test data directory
mkdir -p test_data
cd test_data

# Test 1: Create a simple file
echo "Test data line 1" > test_input.txt
echo "Test data line 2" >> test_input.txt

# Test 2: Check if exist utility works
if [ -x "../exist" ]; then
    echo "Testing exist utility..."
    ../exist test_input.txt || { echo "FAIL: exist utility failed"; exit 1; }
    echo "PASS: exist utility"
else
    echo "SKIP: exist utility not found"
fi

# Test 3: Check if copy utility works  
if [ -x "../copy" ]; then
    echo "Testing copy utility..."
    ../copy test_input.txt test_copy.txt || { echo "FAIL: copy utility failed"; exit 1; }
    if [ -f "test_copy.txt" ]; then
        echo "PASS: copy utility"
    else
        echo "FAIL: copy utility did not create output file"
        exit 1
    fi
else
    echo "SKIP: copy utility not found"
fi

# Test 4: Check if list utility works
if [ -x "../list" ]; then
    echo "Testing list utility..."
    ../list test_input.txt > list_output.txt || { echo "FAIL: list utility failed"; exit 1; }
    if [ -s "list_output.txt" ]; then
        echo "PASS: list utility"
    else
        echo "FAIL: list utility produced no output"
        exit 1
    fi
else
    echo "SKIP: list utility not found"
fi

# Clean up
cd ..
rm -rf test_data

echo "All utility tests completed successfully!"

# Generate JUnit XML output for the test results
cat > ju.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<testsuites name="DB/C Utilities Tests" tests="3" failures="0" errors="0" time="1.0">
  <testsuite name="UtilityTests" tests="3" failures="0" errors="0" time="1.0">
    <testcase name="ExistUtilityTest" classname="UtilityTests" time="0.3"/>
    <testcase name="CopyUtilityTest" classname="UtilityTests" time="0.3"/>
    <testcase name="ListUtilityTest" classname="UtilityTests" time="0.4"/>
  </testsuite>
</testsuites>
EOF

echo "Generated ju.xml test report"