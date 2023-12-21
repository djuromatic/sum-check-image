#!/bin/bash

# Check if both arguments are provided
if [ $# -ne 2 ]; then
	echo "Usage: $0 <circuit_name> <proofs_directory>"
	exit 1
fi

# Assign arguments to variables
circuit_name=$1
proofs_directory=$2
node ${proofs_directory}/${circuit_name}_js/generate_witness.js ${proofs_directory}/${circuit_name}_js/${circuit_name}.wasm input.json ${proofs_directory}/witness.wtns
