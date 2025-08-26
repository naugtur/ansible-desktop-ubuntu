#!/bin/bash

##
# Modern Ansible Desktop Setup Runner
# Compatible with Ansible 2.9+
##

set -euo pipefail  # Exit on error, undefined vars, and pipe failures

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on Ubuntu/Debian
check_system() {
    if ! command -v lsb_release &> /dev/null; then
        print_error "lsb_release not found. Are you running on Ubuntu/Debian?"
        exit 1
    fi

    local distro=$(lsb_release -si)
    if [[ "$distro" != "Ubuntu" ]]; then
        print_warning "This playbook is designed for Ubuntu, but detected: $distro"
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

# Check if ansible is installed
check_ansible() {
    if ! command -v ansible-playbook &> /dev/null; then
        print_error "ansible-playbook not found. Please install Ansible first:"
        echo "  sudo apt update"
        echo "  sudo apt install -y python3-pip"
        echo "  sudo pip3 install ansible"
        exit 1
    fi

    local ansible_version=$(ansible-playbook --version | head -n1 | cut -d' ' -f2)
    print_status "Found Ansible version: $ansible_version"
}

# Check if inventory file exists
check_inventory() {
    if [[ ! -f "hosts" ]]; then
        print_error "Inventory file 'hosts' not found in current directory"
        exit 1
    fi
}

# Main execution
main() {
    print_status "Starting Ansible Desktop Setup"

    # Change to script directory
    cd "$(dirname "${BASH_SOURCE[0]}")"

    # Pre-flight checks
    check_system
    check_ansible
    check_inventory

    # Parse command line arguments
    VERBOSITY=""
    TAGS=""
    SKIP_TAGS=""
    DRY_RUN=""

    while [[ $# -gt 0 ]]; do
        case $1 in
            -v|--verbose)
                VERBOSITY="-v"
                shift
                ;;
            -vv|--very-verbose)
                VERBOSITY="-vv"
                shift
                ;;
            -vvv|--debug)
                VERBOSITY="-vvv"
                shift
                ;;
            --tags)
                TAGS="--tags $2"
                shift 2
                ;;
            --skip-tags)
                SKIP_TAGS="--skip-tags $2"
                shift 2
                ;;
            --check|--dry-run)
                DRY_RUN="--check"
                shift
                ;;
            -h|--help)
                echo "Usage: $0 [OPTIONS]"
                echo ""
                echo "Options:"
                echo "  -v, --verbose        Verbose output"
                echo "  -vv, --very-verbose  Very verbose output"
                echo "  -vvv, --debug        Debug output"
                echo "  --tags TAGS          Only run plays and tasks tagged with these values"
                echo "  --skip-tags TAGS     Skip plays and tasks with these tags"
                echo "  --check, --dry-run   Don't make changes, just show what would be done"
                echo "  -h, --help           Show this help message"
                echo ""
                echo "Examples:"
                echo "  $0                   # Run full playbook"
                echo "  $0 --tags packages   # Only install packages"
                echo "  $0 --check           # Dry run mode"
                echo "  $0 -vv --tags ppas   # Install PPAs with verbose output"
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                echo "Use --help for usage information"
                exit 1
                ;;
        esac
    done

    # Build ansible-playbook command
    local cmd="ansible-playbook"
    cmd="$cmd --inventory hosts"
    cmd="$cmd --connection local"
    cmd="$cmd --ask-become-pass"

    if [[ -n "$VERBOSITY" ]]; then
        cmd="$cmd $VERBOSITY"
    fi

    if [[ -n "$TAGS" ]]; then
        cmd="$cmd $TAGS"
    fi

    if [[ -n "$SKIP_TAGS" ]]; then
        cmd="$cmd $SKIP_TAGS"
    fi

    if [[ -n "$DRY_RUN" ]]; then
        cmd="$cmd $DRY_RUN"
        print_status "Running in dry-run mode (no changes will be made)"
    fi

    cmd="$cmd laptop.yml"

    print_status "Executing: $cmd"
    print_status "You will be prompted for your sudo password..."

    # Execute the command
    if eval "$cmd"; then
        print_status "Ansible playbook completed successfully!"
    else
        local exit_code=$?
        print_error "Ansible playbook failed with exit code: $exit_code"
        exit $exit_code
    fi
}

# Run main function with all arguments
main "$@"
