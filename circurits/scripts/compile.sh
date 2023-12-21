#!/bin/bash

# Check if both arguments are provided
if [ $# -ne 1 ]; then
	echo "Usage: $0 <circuit_name>"
	exit 1
fi

# Assign arguments to variables
circuit_name=$1
proofs_directory="tmp/${circuit_name}"

# Check if the "tmp" folder exists, create it if not
if [ ! -d "tmp" ]; then
	echo "Creating 'tmp' directory..."
	mkdir tmp
fi

# Display friendly messages
echo "Cleaning up existing proofs directory..."
rm -rf ${proofs_directory}
echo "Creating a new proofs directory..."
mkdir ${proofs_directory}

echo "Generating R1CS, WASM, SYM, and C files from ${circuit_name}..."
circom ${circuit_name}.circom --r1cs --wasm --sym --c -o ${proofs_directory}

echo "Process completed successfully!"
