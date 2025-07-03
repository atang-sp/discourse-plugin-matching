#!/bin/bash

echo "Testing Avatar Fix"
echo "=================="

echo "1. Checking if the plugin is properly loaded..."
if curl -s "http://localhost:4200/practice-matching" | grep -q "practice_interests"; then
    echo "✅ Plugin endpoint is responding"
else
    echo "❌ Plugin endpoint is not responding correctly"
fi

echo ""
echo "2. Testing avatar data format..."
curl -s "http://localhost:4200/practice-matching" | jq '.practice_interests[0]' 2>/dev/null || echo "No practice interests found or jq not available"

echo ""
echo "3. Checking browser console for avatar errors..."
echo "Please check the browser console (F12) for any remaining avatar-related errors"

echo ""
echo "Test completed!" 