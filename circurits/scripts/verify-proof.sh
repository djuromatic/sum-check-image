#!/bin/bash

# Check if both arguments are provided
if [ $# -ne 1 ]; then
	echo "Usage: $0 <circuit_name>"
	exit 1
fi

# Assign arguments to variables
circuit_name=$1
proofs_directory="tmp/${circuit_name}"

snarkjs groth16 verify ${proofs_directory}/verification_key.json ${proofs_directory}/public.json ${proofs_directory}/proof.json
