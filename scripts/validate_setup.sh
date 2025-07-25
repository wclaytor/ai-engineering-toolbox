#!/bin/bash
set -e

echo "🧪 Testing Dev Container setup..."

# Check Ruby version
echo "✅ Ruby version:"
ruby --version

# Check if bundler is available
echo "✅ Bundler available:"
bundle --version

# Check if SQLite is available
echo "✅ SQLite available:"
sqlite3 --version

# Check if gems are installed
echo "✅ Checking gems..."
if [ -d "vendor/bundle" ]; then
    echo "   Gems are installed in vendor/bundle"
else
    echo "   Installing gems..."
    bundle config set --local path 'vendor/bundle'
    bundle install
fi

# Test the CLI tool
echo "✅ Testing CLI tool..."
bundle exec ./toolbox version

echo "✅ Initializing database..."
bundle exec ./toolbox init

echo "✅ Loading demo data..."
bundle exec ./toolbox demo

echo "✅ Checking stats..."
bundle exec ./toolbox stats

echo "✅ Generating demo README..."
bundle exec ./toolbox generate --output=validation_demo.md

echo ""
echo "🎉 All tests passed! Dev Container is working correctly."
echo "📝 Generated demo file: validation_demo.md"
echo ""
echo "Quick start commands:"
echo "  bundle exec ./toolbox help     # Show all commands"
echo "  bundle exec ./toolbox stats    # Show database stats"
echo "  bundle exec ./toolbox generate # Generate README.md"