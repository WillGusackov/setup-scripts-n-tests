#!/bin/bash
set -e

echo "=== Docker Test for Fedora Miniconda Setup ==="
echo ""
echo "This will:"
echo "1. Build a Fedora base image"
echo "2. Run the installation script in a container"
echo "3. Verify all packages installed correctly"
echo "4. Clean up containers and images"
echo ""

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Check if installation script exists
INSTALL_SCRIPT="$PROJECT_ROOT/install/miniconda-fedora.sh"
if [ ! -f "$INSTALL_SCRIPT" ]; then
    echo "Error: Installation script not found at $INSTALL_SCRIPT"
    exit 1
fi

# Build the base Fedora image
echo "Step 1: Building Fedora base image..."
docker build -t fedora-base -f "$SCRIPT_DIR/Dockerfile.fedora" "$SCRIPT_DIR"

# Run installation in container
echo ""
echo "Step 2: Running installation in container..."
echo "(This will take several minutes...)"
echo ""

# Create a temporary script that runs the installation without VS Code extensions
docker run --name fedora-test-run fedora-base /bin/bash -c "
    # Copy and run installer (simulated - we'll mount it)
    cat > /tmp/install.sh << 'INSTALLER'
$(cat "$INSTALL_SCRIPT" | sed '/code --install-extension/d')
INSTALLER
    chmod +x /tmp/install.sh
    /tmp/install.sh
"

# Verify the installation
echo ""
echo "Step 3: Verifying installation..."
docker run --name fedora-test-verify fedora-base /bin/bash -c "
    source ~/.bashrc && \
    conda activate ai_engineering && \
    python -c 'import numpy; print(\"✓ numpy:\", numpy.__version__)' && \
    python -c 'import scipy; print(\"✓ scipy:\", scipy.__version__)' && \
    python -c 'import pandas; print(\"✓ pandas:\", pandas.__version__)' && \
    python -c 'import sklearn; print(\"✓ scikit-learn:\", sklearn.__version__)' && \
    python -c 'import matplotlib; print(\"✓ matplotlib:\", matplotlib.__version__)' && \
    python -c 'import seaborn; print(\"✓ seaborn:\", seaborn.__version__)' && \
    python -c 'import jupyterlab; print(\"✓ jupyterlab:\", jupyterlab.__version__)' && \
    python -c 'import featuretools; print(\"✓ featuretools:\", featuretools.__version__)' && \
    python -c 'import pydot; print(\"✓ pydot:\", pydot.__version__)' && \
    python -c 'import phik; print(\"✓ phik:\", phik.__version__)' && \
    python -c 'import pingouin; print(\"✓ pingouin:\", pingouin.__version__)' && \
    python -c 'import dtale; print(\"✓ dtale:\", dtale.__version__)' && \
    echo '' && \
    echo '✓ All packages installed successfully!'
"

# Clean up
echo ""
echo "Step 4: Cleaning up..."
docker rm fedora-test-run fedora-test-verify 2>/dev/null || true
docker rmi fedora-base

echo ""
echo "=== Test Complete! ==="
echo ""
echo "The installation script works! You can now use it on your real system."
