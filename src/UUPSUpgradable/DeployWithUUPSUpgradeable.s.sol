// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

//! If we want to use UUPSUpgradeable, here is the script sample

contract MarketplaceScript is Initializable, OwnableUpgradeable, UUPSUpgradeable{
    // proxy -> deploy implimentation -> call some initializable function
    uint256 internal s_tokenCounter;

    ///@custom:oz-upgrades-unsafe-allow constructor (this is also a constructor or we can use below constructor)
    constructor(){
        _disableInitializers();
    }

    function initialize() public initializer(){
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();
    }

    //all the other functions..

    function _authorizeUpgrade(address newImplimentation) internal virtual override {}
    
}