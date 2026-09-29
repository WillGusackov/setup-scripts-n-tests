#!/bin/bash
set -e

echo "=== AI Engineering Lab Setup for Fedora ==="
echo ""

# Install system dependencies for graphviz
echo "Installing system dependencies..."
sudo dnf install -y graphviz wget

# Download Miniconda installer
echo ""
echo "Downloading Miniconda installer..."
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh

# Run installer
echo ""
echo "Running Miniconda installer..."
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm ~/miniconda3/miniconda.sh

# Initialize conda
echo ""
echo "Initializing conda..."
source ~/miniconda3/bin/activate
conda init --all

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
