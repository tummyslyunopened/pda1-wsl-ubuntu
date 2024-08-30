#!bin/bash

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

    # Check if the destination file exists
    if [[ ! -f "$dest_file" ]]; then
        echo "Destination file not found: $dest_file" >&2
        continue
    fi

    # Perform the copy operation forcefully
    cp -f "$dest_file" "$local_file"
    if [[ $? -eq 0 ]]; then
        echo "Copied '$dest_file' to '$local_file'"
    else
        echo "Failed to copy '$dest_file' to '$local_file'" >&2
    fi
done < "$csv_file"
