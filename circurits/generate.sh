#!/bin/bash

# Check if both arguments are provided
if [ $# -ne 2 ]; then
	echo "Usage: $0 <circuit_name> <proofs_directory>"
	exit 1
fi

# Assign arguments to variables
circuit_name=$1
proofs_directory=$2

echo "######### Compiling Circuit ###########"
./scripts/compile.sh ${circuit_name} ${proofs_directory}
echo "######### Computing witness ###########"
./scripts/compute-witness.sh ${circuit_name} ${proofs_directory}

echo "######### Power of Tau Ceremony ###########"
./scripts/powers-of-tau-ceremony.sh ${circuit_name} ${proofs_directory}
echo "######### Proof Generate ###########"
./scripts/generate-proof.sh ${circuit_name} ${proofs_directory}
echo "######### Proof Verify ###########"
./scripts/verify-proof.sh ${circuit_name} ${proofs_directory}
echo "######### Generate Solidity File ###########"
./scripts/generate-solidity.sh ${circuit_name} ${proofs_directory}
