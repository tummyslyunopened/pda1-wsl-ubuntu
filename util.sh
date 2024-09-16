#!/bin/bash

# Define the default path to the CSV file
default_csv_file_path="deploy-destinations.csv"

# Function to get the CSV file path
get_csv_file_path() {

    if [ -z "$1" ]; then
        echo "$default_csv_file_path"
    else
        echo "$1"
    fi
}

# Function to invoke Python script
invoke_python_script() {
    local script_name="$1"
    local csv_file_path="$2"
    local submodule_path="./config-manager"
    local venv_path="$submodule_path/.venv"
    local python_script_path="$submodule_path/$script_name"

    # Check if the CSV file exists
    if [ ! -f "$csv_file_path" ]; then
        echo "Error: CSV file not found: $csv_file_path" >&2
        exit 1
    fi

    # Check if the Python script exists

    if [ ! -f "$python_script_path" ]; then
        echo "Error: Python script not found: $python_script_path" >&2

        exit 1
    fi

    # Activate the virtual environment

    if [ -f "$venv_path/bin/activate" ]; then
        source "$venv_path/bin/activate"
    else
        echo "Error: Virtual environment not found. Please create it first." >&2
        exit 1
    fi

    # Run the Python script with the CSV file as an argument
    python "$python_script_path" "$csv_file_path"

    # Deactivate the virtual environment
    deactivate
}
