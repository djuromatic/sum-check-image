#!/bin/bash

# Check if both arguments are provided
if [ $# -ne 2 ]; then
	echo "Usage: $0 <circuit_name> <proofs_directory>"
	exit 1
fi

# Assign arguments to variables
circuit_name=$1
proofs_directory=$2

snarkjs zkey export solidityverifier ${proofs_directory}/${circuit_name}_0001.zkey ${proofs_directory}/verifier.sol
