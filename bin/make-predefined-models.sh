#!/bin/bash

if ! command -v openscad >/dev/null 2>&1; then
    echo "Error: OpenSCAD command 'openscad' not found. Please install OpenSCAD and ensure 'openscad' is in your PATH."
    exit 1
fi

export SCAD_FILE=$1
if [ -z "$SCAD_FILE" ]; then
    echo "Error: Missing input file. Usage: $0 <file.scad>"
    exit 1
fi

if [[ "$SCAD_FILE" != *.scad ]]; then
    echo "Error: Input file must have a .scad extension."
    exit 1
fi

export PARAM_FILE="${SCAD_FILE%.scad}.json"
if [ ! -f "$PARAM_FILE" ]; then
    echo "Error: Parameter file '$PARAM_FILE' not found."
    exit 1
fi

function export_model() {
    local param_set="$1"
    local output_file="${param_set}.stl"
    echo "Exporting model for parameter set '$param_set' to '$output_file'..."
    openscad -o "$output_file" -p "$PARAM_FILE" -P "$param_set" "$SCAD_FILE"
    
    if [ $? -ne 0 ]; then
        echo "Error: Failed to export model for parameter set '$param_set'."
        return 1
    fi

    echo "Model exported to '$output_file'."
    echo
}

export -f export_model

jq -r '.parameterSets|keys[]' < "$PARAM_FILE" | xargs -i bash -c 'export_model "$@"' _ {}