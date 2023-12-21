#!/bin/bash

# Check if both arguments are provided
if [ $# -ne 2 ]; then
	echo "Usage: $0 <circuit_name> <proofs_directory>"
	exit 1
fi

# Assign arguments to variables
circuit_name=$1
proofs_directory=$2

snarkjs powersoftau new bn128 12 ${proofs_directory}/pot12_0000.ptau -v
snarkjs powersoftau contribute ${proofs_directory}/pot12_0000.ptau ${proofs_directory}/pot12_0001.ptau --name="First contribution" -v

# Phase 2
#

snarkjs powersoftau prepare phase2 ${proofs_directory}/pot12_0001.ptau ${proofs_directory}/pot12_final.ptau -v
snarkjs groth16 setup ${proofs_directory}/${circuit_name}.r1cs ${proofs_directory}/pot12_final.ptau ${proofs_directory}/${circuit_name}_0000.zkey

# Contribute to Phase phase2
snarkjs zkey contribute ${proofs_directory}/${circuit_name}_0000.zkey ${proofs_directory}/${circuit_name}_0001.zkey --name="1st Contributor Name" -v
snarkjs zkey export verificationkey ${proofs_directory}/${circuit_name}_0001.zkey ${proofs_directory}/verification_key.json
