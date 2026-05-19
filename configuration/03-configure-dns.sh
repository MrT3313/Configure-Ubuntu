#!/bin/bash
# ============================================================================
# Module: DNS Configuration
# ============================================================================
# Purpose: Configures reliable DNS servers for the system
# Replaces systemd-resolved with Cloudflare and Google DNS servers
# This ensures all domains (including specialized ones) can be resolved
#
# WHY THIS IS NEEDED:
# The default systemd-resolved DNS (127.0.0.53) may not be able to resolve
# all domains, particularly smaller or newer domains. By switching to
# public DNS servers (Cloudflare 1.1.1.1 and Google 8.8.8.8), we ensure
# reliable domain resolution for all internet services.
# ============================================================================

set -e  # Exit on any error

echo "[3/7] Configuring DNS..."

# Function to check if DNS is correctly configured
is_dns_configured_correctly() {
    # Check if /etc/resolv.conf exists and is a regular file (not a symlink)
    if [ ! -f /etc/resolv.conf ] || [ -L /etc/resolv.conf ]; then
        return 1  # Not configured correctly
    fi
    
    # Check if it contains our required nameservers
    if grep -q "nameserver 1.1.1.1" /etc/resolv.conf && \
       grep -q "nameserver 8.8.8.8" /etc/resolv.conf; then
        return 0  # Configured correctly
    else
        return 1  # Not configured correctly
    fi
}

# Check current DNS configuration
if is_dns_configured_correctly; then
    echo "DNS is already configured correctly. Skipping..."
else
    echo "DNS configuration needs to be updated..."
    echo "Updating DNS configuration for reliable domain resolution..."
    
    # SUBSTEP 3.1: Backup existing DNS configuration
    # This allows us to restore the original config if needed
    # Only create backup if it doesn't already exist
    if [ -f /etc/resolv.conf ] && [ ! -f /etc/resolv.conf.backup ]; then
        sudo cp /etc/resolv.conf /etc/resolv.conf.backup
        echo "Backed up existing DNS configuration"
    fi
    
    # SUBSTEP 3.2: Stop and disable systemd-resolved
    # systemd-resolved can have issues resolving certain domains
    # We'll replace it with direct DNS server configuration
    echo "Stopping systemd-resolved service..."
    sudo systemctl stop systemd-resolved 2>/dev/null || true
    sudo systemctl disable systemd-resolved 2>/dev/null || true
    
    # SUBSTEP 3.3: Remove the systemd-resolved symlink or existing file
    # systemd-resolved creates a symlink at /etc/resolv.conf
    # We need to remove it to create our own configuration file
    # First, make it mutable if it was previously made immutable
    sudo chattr -i /etc/resolv.conf 2>/dev/null || true
    sudo rm -f /etc/resolv.conf
    
    # SUBSTEP 3.4: Create new DNS configuration
    # We use multiple DNS servers for redundancy:
    # - 1.1.1.1 (Cloudflare): Fast, privacy-focused, primary DNS
    # - 1.0.0.1 (Cloudflare): Backup for primary
    # - 8.8.8.8 (Google): Secondary DNS for maximum reliability
    # - 8.8.4.4 (Google): Backup for secondary
    echo "Writing new DNS configuration..."
    sudo bash -c 'cat > /etc/resolv.conf << EOF
# Configured by environment setup
# Using Cloudflare and Google DNS for reliable domain resolution
nameserver 1.1.1.1
nameserver 1.0.0.1
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF'
    
    # SUBSTEP 3.5: Make the file immutable
    # This prevents other processes (like NetworkManager or systemd) from
    # automatically overwriting our DNS configuration
    # Use +i to make immutable, -i to remove immutability later if needed
    sudo chattr +i /etc/resolv.conf
    
    # SUBSTEP 3.6: Verify DNS is working
    echo "Testing DNS resolution..."
    
    # Wait a moment for DNS to be ready
    sleep 1
    
    # Test with a common domain
    if nslookup google.com > /dev/null 2>&1; then
        echo "✓ DNS configured successfully"
        echo "  - Primary DNS: 1.1.1.1 (Cloudflare)"
        echo "  - Secondary DNS: 8.8.8.8 (Google)"
    else
        echo "Warning: DNS test failed, but continuing anyway..."
    fi
fi