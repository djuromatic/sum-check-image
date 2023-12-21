#!/bin/bash

# Check if both arguments are provided
if [ $# -ne 2 ]; then
	echo "Usage: $0 <circuit_name> <proofs_directory>"
	exit 1
fi

# Assign arguments to variables
circuit_name=$1
proofs_directory=$2
snarkjs groth16 prove ${proofs_directory}/${circuit_name}_0001.zkey ${proofs_directory}/witness.wtns ${proofs_directory}/proof.json ${proofs_directory}/public.json
