// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/sumcheckVerifier.sol";
import "../src/SumCheck.sol";

contract SumCheckScript is Script {
    function setUp() public {}

    function run() public {
      uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
      vm.startBroadcast(deployerPrivateKey);

      Verifier verifier = new Verifier();
      SumCheck _sumCheck = new SumCheck(address(verifier));

      vm.stopBroadcast();
    }
}
