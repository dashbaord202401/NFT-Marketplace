// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

// if you want to create and integrate separate nft collection contract then you have to approve it after mintings
contract NftCollection is ERC721URIStorage {
   
    error NFTCollection__MaxSupplyReached();
    error NFTCollection__NotMarketplaceContract();

    uint256 private _tokenIdentifiers;
    address public marketplaceContract;
    uint256 public MAX_SUPPLY = 2 ** 256 - 1;

    modifier onlyMarketplaceContract() {
        if(msg.sender != marketplaceContract){
            revert NFTCollection__NotMarketplaceContract();
        }
        _;
    }

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _maxSupply
    ) ERC721(_name, _symbol) {
        MAX_SUPPLY = _maxSupply;
        marketplaceContract = msg.sender;
    }

    function MintNFT(
        address _to
    ) external onlyMarketplaceContract returns (uint256) {
        if(!(_tokenIdentifiers < MAX_SUPPLY)){
            revert NFTCollection__MaxSupplyReached();
        }
        unchecked {
            _tokenIdentifiers++;
        }
        _mint(_to, _tokenIdentifiers);
        return _tokenIdentifiers;
    }

    
}
