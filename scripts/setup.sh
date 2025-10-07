#!/bin/bash

# AI Demo App Setup Script
# This script sets up the development environment for the AI Demo App

set -e

echo "🤖 Setting up AI Demo App..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Node.js is installed
check_node() {
    if ! command -v node &> /dev/null; then
        print_error "Node.js is not installed. Please install Node.js 18 or higher."
        exit 1
    fi
    
    NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$NODE_VERSION" -lt 18 ]; then
        print_error "Node.js version 18 or higher is required. Current version: $(node -v)"
        exit 1
    fi
    
    print_success "Node.js $(node -v) is installed"
}

# Check if npm is installed
check_npm() {
    if ! command -v npm &> /dev/null; then
        print_error "npm is not installed. Please install npm."
        exit 1
    fi
    
    print_success "npm $(npm -v) is installed"
}

# Install dependencies
install_dependencies() {
    print_status "Installing dependencies..."
    npm install
    print_success "Dependencies installed successfully"
}

# Run type checking
run_type_check() {
    print_status "Running TypeScript type checking..."
    npx tsc --noEmit
    print_success "Type checking passed"
}

# Run linting
run_lint() {
    print_status "Running ESLint..."
    if command -v npx &> /dev/null; then
        npx eslint src/ --ext .ts,.tsx || print_warning "ESLint found some issues"
    else
        print_warning "ESLint not available, skipping..."
    fi
}

# Build the application
build_app() {
    print_status "Building application..."
    npm run build
    print_success "Application built successfully"
}

# Test the API
test_api() {
    print_status "Testing API server..."
    npm run api &
    API_PID=$!
    
    # Wait for server to start
    sleep 5
    
    # Test health endpoint
    if curl -f http://localhost:3001/api/health > /dev/null 2>&1; then
        print_success "API server is running and healthy"
    else
        print_error "API server health check failed"
    fi
    
    # Test demo endpoint
    if curl -f http://localhost:3001/api/demo > /dev/null 2>&1; then
        print_success "API demo endpoint is working"
    else
        print_error "API demo endpoint failed"
    fi
    
    # Stop the API server
    kill $API_PID 2>/dev/null || true
}

# Main setup function
main() {
    echo "🚀 Starting AI Demo App setup..."
    echo ""
    
    check_node
    check_npm
    install_dependencies
    run_type_check
    run_lint
    build_app
    test_api
    
    echo ""
    print_success "🎉 Setup completed successfully!"
    echo ""
    echo "📋 Next steps:"
    echo "  1. Start the development server: npm run dev"
    echo "  2. Start the API server: npm run api"
    echo "  3. Open http://localhost:3000 in your browser"
    echo "  4. Open http://localhost:3001/api/demo to test the API"
    echo ""
    echo "📚 Documentation:"
    echo "  - README.md: Complete setup and usage guide"
    echo "  - CONTRIBUTING.md: How to contribute to the project"
    echo "  - CHANGELOG.md: Project history and changes"
    echo ""
    echo "🐳 Docker:"
    echo "  - Build: docker build -t ai-demo-app ."
    echo "  - Run: docker run -p 3000:3000 -p 3001:3001 ai-demo-app"
    echo "  - Compose: docker-compose up"
}

# Run main function
main "$@"
