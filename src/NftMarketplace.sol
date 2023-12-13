// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {INftMarketplace} from "./Interface/INftMarketplace.sol";
import {NftCollection} from "./NFTCollection.sol";


//This smart contract is based on mapping
contract NftMarketplace is ERC721, AccessControl, INftMarketplace {

    uint256 private s_tokenCounter;
    uint256 public constant LISTING_PRICE = 0.0001 ether;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    mapping(uint256 => uint256) public auctionEndTime;
    mapping(uint256 => uint256) public auctionHighestBid;
    mapping(uint256 => address) public auctionHighestBidder;

    modifier onlyMinter() {
        if (!hasRole(MINTER_ROLE, msg.sender)) {
            revert NftMarketplace__NotMinter();
        }
        _;
    }

    constructor() ERC721("MyToken", "MTK"){
        _grantRole(MINTER_ROLE, msg.sender);
    }


    function mint(address to) external onlyMinter {
        _mint(to, s_tokenCounter);
        unchecked {
            s_tokenCounter++;
        }
    }

    //if you want to import collection contract then you have to approve it in your test cases
    function createCollection(string memory name, string memory symbol, uint256 supply) external payable {
        if(msg.value != LISTING_PRICE){
            revert NftMarketplace__InvalidPrice();
        }
        if (!(supply > 0)) {
            revert NftMarketplace__MaxSupplyReached();
        }
        NftCollection nftCollection = new NftCollection(name, symbol, supply);
        nftCollection.MintNFT(msg.sender);     
    }

    function listForSale(uint256 _tokenId, uint256 price) external payable override {
        if(msg.value != LISTING_PRICE){
            revert NftMarketplace__InvalidPrice();
        }
        transferFrom(msg.sender, address(this), _tokenId);
        emit listForSaleEvent(_tokenId, price);
    }

    function listForAuction(uint256 _tokenId, uint256 duration) external override {
        if(duration <= 0){
            revert NftMarketplace__InvalidDuration();
        }
        transferFrom(msg.sender, address(this), _tokenId);
        auctionEndTime[_tokenId] = block.timestamp + duration;
        emit listForAuctionEvent(_tokenId, duration);
    }

    function bid(uint256 _tokenId) external payable override {
        if (auctionEndTime[_tokenId] < block.timestamp) {
            revert NftMarketplace__AuctionEnded();
        }

        if (msg.value <= auctionHighestBid[_tokenId]) {
            revert NftMarketplace__BidTooLow();
        }

        if (auctionHighestBidder[_tokenId] != address(0)) {
            payable(auctionHighestBidder[_tokenId]).transfer(auctionHighestBid[_tokenId]);
        }

        auctionHighestBid[_tokenId] = msg.value;
        auctionHighestBidder[_tokenId] = msg.sender;
        emit bidEvent(_tokenId);
    }

    function addMinter(address newMinter) external onlyMinter {
        _grantRole(MINTER_ROLE, newMinter);
    }

    function removeMinter(address newMinter) external onlyMinter {
        _revokeRole(MINTER_ROLE, newMinter);
    }


    function retrieveFixedPriceNFTData(uint256 _tokenId) external view returns (address owner) {
        return (ownerOf(_tokenId));
    }

    function retrieveAuctionNFTData(uint256 _tokenId) external view returns (uint256 endTime, uint256 highestBid, address highestBidder) {
        return (auctionEndTime[_tokenId], auctionHighestBid[_tokenId], auctionHighestBidder[_tokenId]);
    }

    function retrieveAuctionEndTime(uint256 _tokenId) external view returns (uint256) {
        return auctionEndTime[_tokenId];
    }

    function retrieveBidders(uint256 _tokenId) external view returns (address) {
        return auctionHighestBidder[_tokenId];
    }

    function bidPrice(uint256 _tokenId) external view returns (uint256) {
        return auctionHighestBid[_tokenId];
    }
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

}
