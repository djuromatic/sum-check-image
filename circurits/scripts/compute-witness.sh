#!/bin/bash

# Check if both arguments are provided
if [ $# -ne 1 ]; then
	echo "Usage: $0 <circuit_name>"
	exit 1
fi

# Assign arguments to variables
circuit_name=$1
proofs_directory="tmp/${circuit_name}"

node ${proofs_directory}/${circuit_name}_js/generate_witness.js ${proofs_directory}/${circuit_name}_js/${circuit_name}.wasm input.json ${proofs_directory}/witness.wtns
