#!/bin/bash

# Check if both arguments are provided
if [ $# -ne 1 ]; then
	echo "Usage: $0 <circuit_name>"
	exit 1
fi

# Assign arguments to variables
circuit_name=$1
proofs_directory="tmp/${circuit_name}"

snarkjs zkey export solidityverifier ${proofs_directory}/${circuit_name}_0001.zkey ${proofs_directory}/verifier.sol
