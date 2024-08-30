#!/bin/bash

# Define the path to the CSV file
csv_file="deploy-destinations.csv"

# Check if the CSV file exists
if [[ ! -f "$csv_file" ]]; then
    echo "CSV file not found: $csv_file" >&2
    exit 1
fi

# Read the CSV file line by line
while IFS=',' read -r local_file dest_file; do
    # Skip the header line
    if [[ "$local_file" == "local-file" ]]; then
        continue
    fi

    # Trim whitespace from the file paths
    local_file=$(echo "$local_file" | xargs)
    dest_file=$(echo "$dest_file" | xargs)

    # Check if the local file exists
    if [[ ! -f "$local_file" ]]; then
        echo "Local file not found: $local_file" >&2
        continue
    fi

    # Ensure the destination directory exists
    dest_dir=$(dirname "$dest_file")
    if [[ ! -d "$dest_dir" ]]; then
        mkdir -p "$dest_dir"
        if [[ $? -ne 0 ]]; then
            echo "Failed to create directory: $dest_dir" >&2
            continue
        fi
        echo "Created directory: $dest_dir"
    fi

    # Perform the copy operation forcefully
    cp -f "$local_file" "$dest_file"
    if [[ $? -eq 0 ]]; then
        echo "Copied '$local_file' to '$dest_file'"
    else
        echo "Failed to copy '$local_file' to '$dest_file'" >&2
    fi
done < "$csv_file"

