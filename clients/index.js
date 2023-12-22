const { groth16 } = require("snarkjs");
const fs = require("fs");
require('dotenv').config();
const contract = require("../contracts/out/SumCheck.sol/SumCheck.json");
const { ethers } = require("ethers");

const PRIVATE_KEY = process.env.PRIVATE_KEY;
const CONTRACT_ADDRESS = process.env.CONTRACT_ADDRESS;
const RPC_URL = process.env.RPC_URL;

//GET Provider
const provider = new ethers.providers.JsonRpcProvider(RPC_URL);
const signer = new ethers.Wallet(PRIVATE_KEY, provider);

//Set contract instance
const sumcheckContract = new ethers.Contract(
  CONTRACT_ADDRESS,
  contract.abi,
  signer
);

async function run() {
  const { proof, publicSignals } = await groth16.fullProve({
    "a": [
      [
        "0",
        "1",
        "0",
        "0",
        "1",
        "1",
        "0",
        "0"
      ],
      [
        "1",
        "0",
        "1",
        "1",
        "0",
        "0",
        "1",
        "1"
      ],
      [
        "1",
        "1",
        "0",
        "1",
        "0",
        "0",
        "1",
        "1"
      ],
      [
        "1",
        "1",
        "1",
        "1",
        "0",
        "0",
        "0",
        "1"
      ]
    ],
    "b": "0x2C"
  }, "../circurits/tmp/sum-check/sum-check_js/sum-check.wasm", "../circurits/tmp/sum-check/sum-check_0001.zkey");

  console.log("Proof: ");
  console.log(JSON.stringify(proof, null, 1));

  console.log("Public inputs: ");
  console.log(JSON.stringify(publicSignals, null, 1));

  const calldata = await groth16.exportSolidityCallData(proof, publicSignals);
  console.log(calldata);
  const argv = calldata
    .replace(/["[\]\s]/g, "")
    .split(",")
    .map((x) => BigInt(x).toString());

  const a = [argv[0], argv[1]];
  const b = [
    [argv[2], argv[3]],
    [argv[4], argv[5]],
  ];
  const c = [argv[6], argv[7]];
  const Input = [];

  for (let i = 8; i < argv.length; i++) {
    Input.push(argv[i]);
  }

  console.log(a);
  console.log(b);
  console.log(c);
  console.log(Input);

  console.log("Sending proof...");
  const tx = await sumcheckContract.submitProof(a, b, c, Input);
  const receipt = await tx.wait();
  console.log("Tx ", receipt);
  const event = receipt.events.find(event => event.event === "Proof");
  console.log(event);
}

run().then(() => {
  process.exit(0);
});
