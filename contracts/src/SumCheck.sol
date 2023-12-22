// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IVerifier {
    function verifyProof(
        uint256[2] memory a,
        uint256[2][2] memory b,
        uint256[2] memory c,
        uint256[1] memory input
    ) external view returns (bool);
}

contract SumCheck {
 address public verifierAddress;

 event Proof(address sender, bool result);

 constructor(address _verifierAddress) {
   verifierAddress = _verifierAddress;
 }

  function submitProof(uint[2] memory _pA, 
                       uint[2][2] memory _pB, uint[2] memory _pC,
                       uint[1] memory _pubSignals) public {
    bool result = IVerifier(verifierAddress).verifyProof(_pA,_pB,_pC,_pubSignals);
    emit Proof(msg.sender, result);
  }
  
}
