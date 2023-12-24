import { ethers } from 'ethers';
import React, { ChangeEvent, useEffect, useState } from 'react';
// import { groth16 } from 'snarkjs';
import contract from '../SumCheck.json';
import testInput from '../input.json';
import styles from './ImageUpload.module.css';
declare global {
  interface Window {
    ethereum: any
  }
}
let signer: ethers.providers.JsonRpcSigner;
const CONTRACT_ADDRESS = "0x046bf76b07c1a4824f6d1506336688fb590b8cef";
declare var snarkjs: any;


const ImageUpload: React.FC = () => {
  const [imagePreviewUrl, setImagePreviewUrl] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState<boolean>(false);
  const [statusText, setStatusText] = useState('Please upload an image');

  useEffect(() => {
    const provider = new ethers.providers.Web3Provider(window.ethereum)
    // Check if the user has MetaMask installed
    if (typeof window.ethereum !== 'undefined') {
      console.log('MetaMask is installed!');
    }
    const setupSigner = async () => {
      if (!signer) signer = await provider.getSigner();
      console.log(signer);
    }
    setupSigner();
  })

  const verify = async (input?: any) => {
    try {
      const inputSumTest = testInput;
      const inputSum = input;
      const groth16 = snarkjs.groth16;
      const { proof, publicSignals } = await groth16.fullProve(inputSum, "sum-check.wasm", "sum-check_0001.zkey");

      console.log("Proof: ");
      console.log(JSON.stringify(proof, null, 1));

      console.log("Public inputs: ");
      console.log(JSON.stringify(publicSignals, null, 1));

      const calldata = await groth16.exportSolidityCallData(proof, publicSignals);
      console.log(calldata);
      const argv = calldata
        .replace(/["[\]\s]/g, "")
        .split(",")
        .map((x: string | number | bigint | boolean) => BigInt(x).toString());

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
      const sumcheckContract = new ethers.Contract(
        CONTRACT_ADDRESS,
        contract.abi,
        signer
      );
      setIsLoading(false);
      const tx = await sumcheckContract.submitProof(a, b, c, Input);
      setStatusText(`Proof submitted! Please wait transaction to be mined...`);
      const receipt = await tx.wait();
      console.log("Tx ", receipt);
      const event = receipt.events.find((event: { event: string; }) => event.event === "Proof");
      console.log(event);
      setStatusText(`Result: ${event.args[1]}`);
    } catch (error) {
      setIsLoading(false);
      setStatusText(`Error: ${error}`);
      console.error('Error:', error);
    }

  }

  const handleImageChange = (event: ChangeEvent<HTMLInputElement>) => {
    if (event.target.files && event.target.files[0]) {
      const file = event.target.files[0];

      const reader = new FileReader();
      reader.onloadend = () => {
        setImagePreviewUrl(reader.result as string);
        uploadImageBinary(file); // Call upload function after setting preview
      };
      reader.readAsDataURL(file);
    }
  };

  const uploadImageBinary = async (file: File) => {
    setIsLoading(true);
    setStatusText('Uploading image...');

    // Set up the form data
    const formData = new FormData();
    formData.append('image', file);

    try {
      const reader = new FileReader();
      reader.onload = async (event) => {
        const buffer = event.target!.result;
        const response = await fetch(process.env.REACT_APP_API_URL + '/upload', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/octet-stream',
          },
          body: buffer,
        });

        // Check if the upload was successful
        if (!response.ok) {
          console.error(response);
          throw new Error('Upload failed');
        }

        // Handle the server response here
        const data = await response.json() as { a: number[], b: number, length?: number };

        console.log(data);
        await verify(data);
        setIsLoading(false);
      };
      reader.readAsArrayBuffer(file);

    } catch (error) {
      console.error('Error:', error);
      setIsLoading(false);
    }
  };

  return (
    <div className="flex flex-col items-center">
      {/* Hidden File Input */}
      <input
        type="file"
        id="image-upload"
        accept="image/*"
        onChange={handleImageChange}
        className="hidden"
      />

      {/* Styled Button to Trigger File Input */}
      <label
        htmlFor="image-upload"
        className="cursor-pointer inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-blue-500 hover:bg-blue-700 my-2"
      >
        Upload Image
      </label>

      {/* Image Preview Container */}
      {imagePreviewUrl && (
        <div className="mt-4">
          <img src={imagePreviewUrl} alt="Preview" className="max-w-xs max-h-60" />
        </div>
      )}
      {isLoading && (
        <div className={styles.loader}></div> // Loader displayed while fetching
      )}
      <div className="text-center mt-2">{statusText}</div>
    </div>
  );
};

export default ImageUpload;
