#!/bin/bash

echo "=== Debugging AJAX Issue ==="
echo

# Check if we're in the right directory
if [ ! -f "plugin.rb" ]; then
    echo "Error: Please run this script from the discourse-plugin-matching directory"
    exit 1
fi

echo "1. Checking current controller implementation..."
if [ -f "app/controllers/practice_matching_controller.rb" ]; then
    echo "   - Controller exists: YES"
    echo "   - Has logging: $(grep -c "Rails.logger" "app/controllers/practice_matching_controller.rb") lines"
    echo "   - Has case statement: $(grep -c "case result" "app/controllers/practice_matching_controller.rb") lines"
    echo "   - Has error handling: $(grep -c "rescue" "app/controllers/practice_matching_controller.rb") lines"
else
    echo "   - Controller exists: NO"
fi
echo

echo "2. Checking user extension implementation..."
if [ -f "lib/practice_matching/user_extension.rb" ]; then
    echo "   - User extension exists: YES"
    echo "   - Has specific error codes: $(grep -c "self_user\|already_exists\|creation_failed" "lib/practice_matching/user_extension.rb") lines"
    echo "   - Uses create instead of create!: $(grep -c "practice_interests.create" "lib/practice_matching/user_extension.rb") lines"
else
    echo "   - User extension exists: NO"
fi
echo

echo "3. Checking frontend error handling..."
if [ -f "assets/javascripts/discourse/controllers/practice-matching.js" ]; then
    echo "   - Frontend controller exists: YES"
    echo "   - Has detailed logging: $(grep -c "console.log\|console.error" "assets/javascripts/discourse/controllers/practice-matching.js") lines"
    echo "   - Has error object structure logging: $(grep -c "Error object structure" "assets/javascripts/discourse/controllers/practice-matching.js") lines"
    echo "   - Has multiple error format handling: $(grep -c "jqXHR\|responseJSON\|responseText" "assets/javascripts/discourse/controllers/practice-matching.js") lines"
else
    echo "   - Frontend controller exists: NO"
fi
echo

echo "4. Checking routes..."
if [ -f "plugin.rb" ]; then
    echo "   - Routes defined: $(grep -c "practice-matching" "plugin.rb") lines"
    echo "   - POST route for add: $(grep -c "post.*practice-matching/add" "plugin.rb") lines"
fi
echo

echo "5. Issue analysis:"
echo "   The error 'Cannot read properties of undefined (reading 'success')' suggests:"
echo "   - The AJAX request is not returning the expected response"
echo "   - The 'result' variable is undefined"
echo "   - This could be due to:"
echo "     a) Backend not responding properly"
echo "     b) Network/connection issues"
echo "     c) Route not found"
echo "     d) Backend error preventing response"
echo

echo "6. Debugging steps:"
echo "   a) Check browser Network tab for the AJAX request"
echo "   b) Check browser Console for detailed logs"
echo "   c) Check Rails logs for backend processing"
echo "   d) Verify the route is accessible"
echo

echo "7. Quick fixes applied:"
echo "   - Added detailed logging to frontend and backend"
echo "   - Improved error handling with multiple format support"
echo "   - Added null/undefined checks"
echo "   - Enhanced debugging information"
echo

echo "8. Next steps:"
echo "   - Restart Discourse server"
echo "   - Try adding a user again"
echo "   - Check browser console for detailed logs"
echo "   - Check Rails logs for backend processing"
echo "   - Look for any error messages in both logs"
echo

echo "=== Debug script completed ===" 