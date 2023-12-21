#!/bin/bash

# Check if both arguments are provided
if [ $# -ne 1 ]; then
	echo "Usage: $0 <circuit_name>"
	exit 1
fi

# Assign arguments to variables
circuit_name=$1

echo "######### Compiling Circuit ###########"
./scripts/compile.sh ${circuit_name}
echo "######### Computing witness ###########"
./scripts/compute-witness.sh ${circuit_name}

echo "######### Power of Tau Ceremony ###########"
./scripts/powers-of-tau-ceremony.sh ${circuit_name}
echo "######### Proof Generate ###########"
./scripts/generate-proof.sh ${circuit_name}
echo "######### Proof Verify ###########"
./scripts/verify-proof.sh ${circuit_name}
echo "######### Generate Solidity File ###########"
./scripts/generate-solidity.sh ${circuit_name}
