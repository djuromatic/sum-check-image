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
# Update the solidity version in the Solidity verifier
sed 's/0.6.11;/0.8.19;/g' ${proofs_directory}/verifier.sol >>${proofs_directory}/sumcheckVerifier.sol
rm ${proofs_directory}/verifier.sol

cp ${proofs_directory}/sumcheckVerifier.sol ../contracts/src/sumcheckVerifier.sol
