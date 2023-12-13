// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {NftMarketplace2} from "../src/NftMarketplace2.sol";

contract MarketplaceScript is Script {

    function run() public returns(NftMarketplace2) {
        
        uint privateKey = vm.envUint("PRIVATE_KEY");
        address account = vm.addr(privateKey);
        console.log("Account: ", account);

        vm.startBroadcast(privateKey);
        NftMarketplace2 nftMarketplace = new NftMarketplace2();
        vm.stopBroadcast();
        return nftMarketplace;
    }
}
