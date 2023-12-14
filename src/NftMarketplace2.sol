// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import {ERC721Upgradeable} from "lib/openzeppelin-contracts-upgradeable/contracts/token/ERC721/ERC721Upgradeable.sol";
import {AccessControlUpgradeable} from "lib/openzeppelin-contracts-upgradeable/contracts/access/AccessControlUpgradeable.sol";
import {INftMarketplace} from "./Interface/INftMarketplace.sol";
import {OwnableUpgradeable} from "lib/openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";
import {Initializable} from "lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";

//This smart contract is based on inside mint functionality
contract NftMarketplace2 is INftMarketplace, Initializable,ERC721Upgradeable, AccessControlUpgradeable, OwnableUpgradeable  {

    uint256 private s_tokenCounter;
    uint256 public constant LISTING_PRICE = 0.0001 ether;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    mapping(uint256 tokenId => Auction condition) public auctions;
    mapping(uint256 tokenId => SaleInfo condition) public saleInfo;

    modifier onlyMinter() {
        if (!hasRole(MINTER_ROLE, msg.sender)) {
            revert NftMarketplace__NotMinter();
        }
        _;
    }

    function initilizer() public initializer  {
        __Ownable_init(msg.sender);
        // __AccessControl_init();
        __ERC721_init("TestNFT", "TNFT");
        _grantRole(MINTER_ROLE, msg.sender);
    }

    function mint(address to) external onlyMinter {
        _mint(to, s_tokenCounter);
        unchecked {
            s_tokenCounter++;
        }
    }

    function listForSale(uint256 _tokenId, uint256 price) external payable override { 
        if(msg.value != LISTING_PRICE || price <= 0){
            revert NftMarketplace__InvalidPrice();
        }
        if(!(isApprovedForAll(msg.sender, address(this)))){
            revert NftMarketplace__NotApproved();
        }
        
        saleInfo[_tokenId] = SaleInfo({
            seller: msg.sender,
            price: price,
            listed: true
        });
        safeTransferFrom(msg.sender, address(this), _tokenId);
        emit listForSaleEvent(_tokenId, price);
    }

    function listForAuction(uint256 _tokenId, uint256 duration) external override {
        if(duration <= 0){
            revert NftMarketplace__InvalidDuration();
        }
        if(!(isApprovedForAll(msg.sender, address(this)))){
            revert NftMarketplace__NotApproved();
        }
    
        auctions[_tokenId] = Auction({
            state: AuctionState.OPEN,
            endTime: block.timestamp + duration,
            highestBid: 0,
            highestBidder: address(0x0)
        });
        safeTransferFrom(msg.sender, address(this), _tokenId);  
        emit listForAuctionEvent(_tokenId, duration);
    }

    function bid(uint256 _tokenId) external payable override {
        Auction storage auction = auctions[_tokenId];
        if (auction.state != AuctionState.OPEN) {
            revert NftMarketplace__AuctionNotExist();
        }
        if (auction.endTime > block.timestamp) {
            revert NftMarketplace__AuctionEnded();
        }

        if (msg.value < auction.highestBid) {
            revert NftMarketplace__BidTooLow();
        }

        if (auction.highestBidder != address(0)) {
            payable(auction.highestBidder).transfer(auction.highestBid);
        }

        auction.highestBid = msg.value;
        auction.highestBidder = msg.sender;
        emit bidEvent(_tokenId);
    }

    function addMinter(address newMinter) external onlyMinter {
        _grantRole(MINTER_ROLE, newMinter);
    }

    function removeMinter(address newMinter) external onlyMinter {
        _revokeRole(MINTER_ROLE, newMinter);
    }

    function retrieveFixedPriceNFTDataUsingOwnerFunction(uint256 _tokenId) external view returns (address owner) {
        return (ownerOf(_tokenId));
    }

    function retrieveFixedPriceNFTDataUsingStruct(uint256 _tokenId) external view returns (SaleInfo memory) {
        return (saleInfo[_tokenId]);
    }

    function retrieveAuctionNFTData(uint256 _tokenId) external view returns (uint256 endTime, uint256 highestBid, address highestBidder) {
        Auction storage auction = auctions[_tokenId];
        return (auction.endTime, auction.highestBid, auction.highestBidder);
    }

    function retrieveAuctionEndTime(uint256 _tokenId) external view returns (uint256) {
        return auctions[_tokenId].endTime;
    }

    function retrieveBidders(uint256 _tokenId) external view returns (address) {
        return auctions[_tokenId].highestBidder;
    }

    function auctionState(uint256 _tokenId) external view returns (AuctionState) {
        Auction storage auction = auctions[_tokenId];
        return auction.state;
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721Upgradeable, AccessControlUpgradeable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function isAuctionExist(AuctionState _state) internal pure {
        if (_state != AuctionState.OPEN) {
            revert NftMarketplace__AuctionNotExist();
        }
    }
}
