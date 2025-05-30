#!/bin/bash
GITHUB_USERNAME="ashmortar"
REPO_NAME="dotfiles"

echo "🚀 Setting up GitHub repository..."
echo ""
echo "1. Create a new repository at: https://github.com/new"
echo "   - Name: ${REPO_NAME}"
echo "   - Keep it public or private as you prefer"
echo "   - DO NOT initialize with README, .gitignore, or license"
echo ""
read -p "Press Enter once you've created the repository..."

# Initialize git and push
git init
git add .
git commit -m "Initial modern dotfiles setup"
git remote add origin "https://github.com/${GITHUB_USERNAME}/${REPO_NAME}.git"
git branch -M main
git push -u origin main

echo ""
echo "✅ Repository setup complete!"
echo ""
echo "Your dotfiles are now at: https://github.com/${GITHUB_USERNAME}/${REPO_NAME}"
echo ""
echo "To install on a new machine:"
echo "  chezmoi init --apply ${GITHUB_USERNAME}/${REPO_NAME}"
