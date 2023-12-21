// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./interface/IVerifier.sol";

contract SumCheck {
 address public verifierAddress;

 event Proof(address sender, bool result);

 constructor(address _verifierAddress) {
   verifierAddress = _verifierAddress;
 }

  function submitProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[1] calldata _pubSignals) public {
    bool result = IVerifier(verifierAddress).verifyProof(_pA,_pB,_pC,_pubSignals);
    emit Proof(msg.sender, result);
  }
  
}
