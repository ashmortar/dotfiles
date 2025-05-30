#!/bin/bash
echo "🔍 Testing new configuration..."
echo ""
echo "This will show what changes will be made:"
echo ""
chezmoi diff
echo ""
echo "To apply these changes, run:"
echo "  chezmoi apply -v"
