#!/bin/bash
set -e

echo "=== AI Engineering Lab Setup for Linux Mint ==="
echo ""

# Install system dependencies for graphviz
echo "Installing system dependencies..."
sudo apt-get update
sudo apt-get install -y graphviz wget

# Download Miniconda installer
INSTALLER="Miniconda3-latest-Linux-x86_64.sh"
URL="https://repo.anaconda.com/miniconda/$INSTALLER"

echo ""
echo "Downloading Miniconda installer..."
wget -q --show-progress "$URL" -O "/tmp/$INSTALLER"

# Run installer
echo ""
echo "Running Miniconda installer..."
bash "/tmp/$INSTALLER" -b -p "$HOME/miniconda3"

# Initialize conda for bash
echo ""
echo "Initializing conda..."
"$HOME/miniconda3/bin/conda" init bash

# Source to use conda in this script
source "$HOME/miniconda3/etc/profile.d/conda.sh"

# Create ai_engineering environment
echo ""
echo "Creating ai_engineering environment..."
conda create -n ai_engineering python=3.14 -y

# Activate environment
echo ""
echo "Activating ai_engineering environment..."
conda activate ai_engineering

# Install base packages
echo ""
echo "Installing base packages (numpy, scipy, matplotlib, seaborn, pandas, scikit-learn)..."
conda install -y numpy scipy matplotlib seaborn pandas scikit-learn

# Install JupyterLab
echo ""
echo "Installing JupyterLab..."
conda install -c conda-forge -y jupyterlab

# Install additional required packages
echo ""
echo "Installing featuretools..."
conda install -c conda-forge -y featuretools

echo "Installing graphviz and pydot..."
conda install -c anaconda -y graphviz pydot

echo "Installing phik..."
conda install -c conda-forge -y phik

echo "Installing pingouin..."
conda install -c conda-forge -y pingouin

# Install dtale last (can cause dependency conflicts)
echo ""
echo "Installing dtale (this may take a while)..."
conda install -c conda-forge -y dtale

# Clean up
rm "/tmp/$INSTALLER"

# Install VS Code extensions
echo ""
echo "Installing VS Code extensions for Python and Jupyter..."
code --install-extension ms-python.python --force
code --install-extension ms-toolsai.jupyter --force

echo ""
echo "=== Installation Complete ==="
echo ""
echo "Next steps:"
echo "1. Run: source ~/.bashrc"
echo "2. Activate environment: conda activate ai_engineering"
echo "3. Verify with: python -c 'import numpy; print(numpy.__version__)'"
echo ""
echo "VS Code extensions installed. To use:"
echo "  - Open VS Code: code"
echo "  - Press Ctrl+Shift+P and select 'Python: Select Interpreter'"
echo "  - Choose the 'ai_engineering' conda environment"
echo ""
echo "To launch JupyterLab: jupyter lab"
