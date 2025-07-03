#!/bin/bash

echo "Testing Practice Matching Plugin Endpoints"
echo "=========================================="

# Test the main endpoint
echo "1. Testing /practice-matching endpoint..."
curl -s -X GET "http://localhost:4200/practice-matching" \
  -H "Content-Type: application/json" \
  -H "X-CSRF-Token: $(curl -s -c cookies.txt http://localhost:4200/session/csrf | grep -o 'csrf-token.*' | cut -d'"' -f3)" \
  -b cookies.txt

echo -e "\n\n2. Testing add interest endpoint..."
curl -s -X POST "http://localhost:4200/practice-matching/add" \
  -H "Content-Type: application/json" \
  -H "X-CSRF-Token: $(curl -s -c cookies.txt http://localhost:4200/session/csrf | grep -o 'csrf-token.*' | cut -d'"' -f3)" \
  -d '{"username":"testuser"}' \
  -b cookies.txt

echo -e "\n\n3. Testing remove interest endpoint..."
curl -s -X DELETE "http://localhost:4200/practice-matching/remove" \
  -H "Content-Type: application/json" \
  -H "X-CSRF-Token: $(curl -s -c cookies.txt http://localhost:4200/session/csrf | grep -o 'csrf-token.*' | cut -d'"' -f3)" \
  -d '{"username":"testuser"}' \
  -b cookies.txt

echo -e "\n\nTest completed!" 