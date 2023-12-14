// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;
import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {NftMarketplace2} from "../src/NftMarketplace2.sol";


contract MintNft is Script {
     string public constant URI = ""; //if we have URI implimentation

    function mintNftOnContract(address contractAddress) public {
        vm.startBroadcast();
        NftMarketplace2(contractAddress).mintNft(URI);
        vm.stopBroadcast();
    }

    function run() external {
        address mostRecentlyDeploy = DevOpsTools.get_most_recent_deployment("NftMarketplace2", block.chainid);
        mintNftOnContract(mostRecentlyDeploy);
    }
    
}