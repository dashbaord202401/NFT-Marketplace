// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

interface INftMarketplace {
    //errors
    error NftMarketplace__NotMinter();
    error NftMarketplace__InvalidPrice();
    error NftMarketplace__InvalidDuration();
    error NftMarketplace__AuctionEnded();
    error NftMarketplace__BidTooLow();
    error NftMarketplace__NotApproved();
    error NftMarketplace__AuctionNotExist();
    error NftMarketplace__TokenAlreadyListed();
    error NftMarketplace__AlreadyMinter();
    error NftMarketplace__MaxSupplyReached();

    //events
    event listForSaleEvent(uint256 _tokenId, uint256 _price);
    event listForAuctionEvent(uint256 _tokenId, uint256 _duration);
    event bidEvent(uint256 _tokenId);

    //emum
    enum AuctionState {
        OPEN, 
        ENDED 
    }

    //struct
    struct SaleInfo {
       address seller;
       uint256 price;
       bool listed;
    }

    struct Auction {
        AuctionState state;
        uint256 endTime;
        uint256 highestBid;
        address highestBidder;
    }


    //functions
    function listForSale(uint256 _tokenId, uint256 _price) external payable;
    function listForAuction(uint256 _tokenId, uint256 _duration) external;
    function bid(uint256 _tokenId) external payable;

}