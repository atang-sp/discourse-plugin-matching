#!/bin/bash

echo "Development Environment Test"
echo "============================"

echo "1. Testing plugin endpoint..."
if curl -s "http://localhost:4200/practice-matching" > /dev/null; then
    echo "✅ Plugin endpoint is accessible"
else
    echo "❌ Plugin endpoint is not accessible"
    echo "   Make sure Discourse is running and plugin is deployed"
fi

echo ""
echo "2. Testing navigation bar..."
echo "   Check if '实践配对' appears in the navigation bar"

echo ""
echo "3. Testing browser console..."
echo "   Open browser console (F12) and check for any errors"

echo ""
echo "4. Quick restart commands:"
echo "   cd ../discourse"
echo "   bin/docker/discourse restart"
echo "   # or for frontend only:"
echo "   bin/docker/ember-cli"
echo "   # or use quick dev script:"
echo "   ./quick-dev.sh"

echo ""
echo "Test completed!" 