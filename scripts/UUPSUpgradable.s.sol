// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;
import {Script} from "forge-std/Script.sol";
import {NFTMarketplace2} from "../src/NFTMarketplace2.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";


//! This is how we can impliment this proxy.
contract DeployBox is Script {
    function run() external returns (address) {
        address proxy = deployBox(); 
        return proxy;
    }

    function deployMarketplace() public returns (address) {
        vm.startBroadcast();
        NFTMarketplace2 market = new NFTMarketplace2(); //implimentation (logic)
        ERC1967Proxy proxy = new ERC1967Proxy(address(market), "");
        vm.stopBroadcast();
        return address(proxy);
    }
}