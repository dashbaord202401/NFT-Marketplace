// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {NftMarketplace} from "../src/NftMarketplace2.sol";

contract MarketplaceScript is Script {

    function run() public returns(NftMarketplace) {
        uint privateKey = vm.envUint("PRIVATE_KEY");
        address account = vm.addr(privateKey);
        console.log("Account: ", account);

        vm.startBroadcast(privateKey);
        NftMarketplace nftMarketplace = new NftMarketplace();
        vm.stopBroadcast();

        return nftMarketplace;
    }
}
