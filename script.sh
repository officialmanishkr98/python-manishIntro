#!/bin/bash

# Determine the appropriate python and pip commands
if command -v python3 &> /dev/null; then
    PYTHON_CMD="python3"
    PIP_CMD="pip3"
elif command -v python &> /dev/null; then
    PYTHON_CMD="python"
    PIP_CMD="pip"
else
    echo "Error: Python not found. Please install Python 3." >&2
    exit 1
fi

# Inform the user about the binary generation process
echo "Generating binaries for the Python package..."
sleep 2
$PYTHON_CMD setup.py sdist bdist_wheel

# Ask the user if they want to upload the package to PyPI.org
read -p "Do you want to upload the package to PyPI.org now? (yes or no): " ans

# Check the user's response
if [ "$ans" == "yes" ]; then
    # Check if 'twine' is not installed, then install it
    if ! command -v twine &> /dev/null; then
        echo "Installing twine..."
        sleep 2
        $PIP_CMD install twine -y
    fi

    # Create a file named .pypirc in the home folder on Ubuntu/Linux machine
    # The file should have the following structure:
    # [pypi]
    # username = __token__
    # password = <paste your pypi.org token here>

    echo "Uploading the package to PyPI.org using twine..."
    sleep 2
    twine upload dist/*
else
    # If the user doesn't want to upload, inform them
    echo "Not uploading the package."
    sleep 2
fi

# Ask the user if they want to delete binaries for this package
read -p "Do you want to delete binaries for this package? (yes or no): " delBin
if [ "$delBin" == "yes" ]; then
    echo "Deleting Binaries (build dist *.egg-info)..."
    sleep 2
    rm -r build dist *.egg-info
fi

# Ask the user if they want to install this Python package now
read -p "Do you want to install this Python package now? (yes or no): " installCheck
if [ "$installCheck" == "yes" ]; then
    # Use the determined pip command to install the package from the current directory
    echo "Installing the python package from current directory..."
    sleep 2
    $PIP_CMD install .
fi

# Note: An alternate command for installing from setup.py is 'python setup.py install'.
# Keep in mind that using 'pip' is generally recommended,
# as it provides better dependency management and integration with virtual environments.
# Additionally, using 'python setup.py install' might not handle certain situations as well as 'pip'.
