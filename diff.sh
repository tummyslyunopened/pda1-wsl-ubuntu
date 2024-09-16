#!/bin/bash

# Import the utilty functions
source ./util.sh

# Get the CSV file path from command line argument or use the default
csv_file_path=$(get_csv_file_path "$1")

# Run the Python script
invoke_python_script "diff.py" "$csv_file_path"
