#!/bin/bash

# CampusFit Application - API Testing Script
# This script tests all endpoints of the application

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
BASE_URL="${1:-http://localhost:3000}"

echo "=========================================="
echo "  CampusFit Application - API Tests"
echo "=========================================="
echo "Base URL: $BASE_URL"
echo ""

# Function to test endpoint
test_endpoint() {
    local test_name="$1"
    local method="$2"
    local endpoint="$3"
    local data="$4"
    local expected_status="$5"

    echo -e "${YELLOW}Test: $test_name${NC}"

    if [ "$method" = "GET" ]; then
        response=$(curl -s -w "\n%{http_code}" "$BASE_URL$endpoint")
    else
        response=$(curl -s -w "\n%{http_code}" -X "$method" "$BASE_URL$endpoint" \
            -H "Content-Type: application/json" \
            -d "$data")
    fi

    # Extract status code (last line)
    status_code=$(echo "$response" | tail -n1)

    # Extract body (all but last line)
    body=$(echo "$response" | sed '$d')

    # Check status code
    if [ "$status_code" = "$expected_status" ]; then
        echo -e "${GREEN}✓ PASSED${NC} - Status: $status_code"
    else
        echo -e "${RED}✗ FAILED${NC} - Expected: $expected_status, Got: $status_code"
    fi

    # Pretty print JSON response
    echo "$body" | python3 -m json.tool 2>/dev/null || echo "$body"
    echo ""
}

# Wait for application to be ready
echo "Checking if application is ready..."
max_attempts=30
attempt=0

while [ $attempt -lt $max_attempts ]; do
    if curl -s "$BASE_URL/health" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Application is ready!${NC}"
        echo ""
        break
    fi
    attempt=$((attempt + 1))
    echo "Waiting for application... ($attempt/$max_attempts)"
    sleep 1
done

if [ $attempt -eq $max_attempts ]; then
    echo -e "${RED}✗ Application is not responding${NC}"
    exit 1
fi

# Run tests
echo "Running API tests..."
echo ""

# Test 1: Health Check
test_endpoint \
    "Health Check" \
    "GET" \
    "/health" \
    "" \
    "200"

# Test 2: Register Valid Student
test_endpoint \
    "Register Valid Student (Premium)" \
    "POST" \
    "/student" \
    '{"name":"Rahul Kumar","membership":"Premium"}' \
    "201"

# Test 3: Register Another Student
test_endpoint \
    "Register Valid Student (Elite)" \
    "POST" \
    "/student" \
    '{"name":"Priya Sharma","membership":"Elite"}' \
    "201"

# Test 4: Register Basic Member
test_endpoint \
    "Register Valid Student (Basic)" \
    "POST" \
    "/student" \
    '{"name":"Amit Patel","membership":"Basic"}' \
    "201"

# Test 5: Missing Name Field
test_endpoint \
    "Validation - Missing Name" \
    "POST" \
    "/student" \
    '{"membership":"Premium"}' \
    "400"

# Test 6: Missing Membership Field
test_endpoint \
    "Validation - Missing Membership" \
    "POST" \
    "/student" \
    '{"name":"Test Student"}' \
    "400"

# Test 7: Both Fields Missing
test_endpoint \
    "Validation - Both Fields Missing" \
    "POST" \
    "/student" \
    '{}' \
    "400"

# Test 8: Invalid Membership Type
test_endpoint \
    "Validation - Invalid Membership (Gold)" \
    "POST" \
    "/student" \
    '{"name":"Test Student","membership":"Gold"}' \
    "400"

# Test 9: Invalid Membership Type
test_endpoint \
    "Validation - Invalid Membership (Diamond)" \
    "POST" \
    "/student" \
    '{"name":"Test Student","membership":"Diamond"}' \
    "400"

# Test 10: Empty Name
test_endpoint \
    "Validation - Empty Name" \
    "POST" \
    "/student" \
    '{"name":"","membership":"Premium"}' \
    "400"

# Test 11: Name Too Short
test_endpoint \
    "Validation - Name Too Short" \
    "POST" \
    "/student" \
    '{"name":"A","membership":"Premium"}' \
    "400"

# Test 12: Invalid Route
test_endpoint \
    "Invalid Route - 404" \
    "GET" \
    "/invalid-route" \
    "" \
    "404"

# Summary
echo "=========================================="
echo -e "${GREEN}All tests completed!${NC}"
echo "=========================================="
echo ""
echo "To verify data in MongoDB, run:"
echo "  docker exec -it campusfit-mongodb mongosh -u campusfit_user -p campusfit_password --authenticationDatabase admin"
echo "  > use campusfit_db"
echo "  > db.students.find().pretty()"
echo ""
