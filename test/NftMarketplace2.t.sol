// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;
import {Test} from "forge-std/Test.sol";
import {NftMarketplace} from "../src/NftMarketplace.sol";
import {INftMarketplace} from "../src/Interface/INftMarketplace.sol";

contract NftMarketpalceTest is Test {
    uint256 public constant LISTING_PRICE = 0.0001 ether;
    uint256 public constant INCORRECT_LISTING_PRICE = 0.01 ether;
    uint256 public constant AUCITON_DURATION = 86400;
    uint256 public constant ZERO_AUCTION_DURATION = 0;
    uint256 public constant ZERO_VALUE = 0;
    uint256 public constant BID_PRICE = 1 ether;
    uint256 public nftPrice = 1 ether;

    NftMarketplace marketplaceContract;
    address public OWNER = makeAddr("owner");
    address public USER = makeAddr("user");

    address public MINTER1 = makeAddr("minter1");
    address public MINTER2 = makeAddr("minter2");



    function setUp() public {
        OWNER = msg.sender;
        vm.prank(OWNER);
        marketplaceContract = new NftMarketplace();
        vm.stopPrank();
    }

    function testMintNft() public {
        vm.startPrank(OWNER);
        marketplaceContract.mint(OWNER);
        vm.stopPrank();

        assertEq(marketplaceContract.balanceOf(OWNER), 1);
        assertEq(marketplaceContract.ownerOf(0), OWNER);
    }

    function testRevertMintifNotMinter() public {
        vm.startPrank(USER);
        
        bytes4 selector = bytes4(keccak256("NftMarketplace__NotMinter()"));
        vm.expectRevert(abi.encodeWithSelector(selector));
    
        marketplaceContract.mint(USER);
        vm.stopPrank();
    }

    function testListForSale() public {
        vm.startPrank(OWNER);
        vm.deal(OWNER, 10 ether);
        marketplaceContract.mint(OWNER);

        marketplaceContract.setApprovalForAll(OWNER, true);
        marketplaceContract.listForSale{value: LISTING_PRICE}(0, nftPrice);
        vm.stopPrank();
    }

    function testRevertListForSaleifValueIsNotCorrect() public {
        vm.startPrank(OWNER);
        vm.deal(OWNER, 10 ether);
        marketplaceContract.mint(OWNER);
        
        bytes4 selector = bytes4(keccak256("NftMarketplace__InvalidPrice()"));
        vm.expectRevert(abi.encodeWithSelector(selector));
    
        marketplaceContract.listForSale{value: INCORRECT_LISTING_PRICE}(0, nftPrice);
        vm.stopPrank();
    }

    function testRevertListForSaleifValueIsZero() public {
        vm.startPrank(OWNER);
        vm.deal(OWNER, 10 ether);
        marketplaceContract.mint(OWNER);
        
        bytes4 selector = bytes4(keccak256("NftMarketplace__InvalidPrice()"));
        vm.expectRevert(abi.encodeWithSelector(selector));
    
        marketplaceContract.listForSale{value: ZERO_VALUE}(0, nftPrice);
        vm.stopPrank();
    }

    function testListForAuction() public {
        vm.startPrank(OWNER);
        vm.deal(OWNER, 10 ether);
        marketplaceContract.mint(OWNER);

        marketplaceContract.setApprovalForAll(OWNER, true);
        marketplaceContract.listForAuction(0, AUCITON_DURATION);  
        vm.stopPrank();
    }

    function testRevertListForAuctionifDurationIsZero() public {
        vm.startPrank(OWNER);
        vm.deal(OWNER, 10 ether);
        marketplaceContract.mint(OWNER);
        marketplaceContract.setApprovalForAll(address(this), true);
         
        bytes4 selector = bytes4(keccak256("NftMarketplace__InvalidDuration()"));
        vm.expectRevert(abi.encodeWithSelector(selector));

        marketplaceContract.listForAuction(0, ZERO_AUCTION_DURATION);
        vm.stopPrank();
    }

    function testBid() public {
        vm.startPrank(OWNER);
        vm.deal(OWNER, 10 ether);
        marketplaceContract.mint(OWNER);

        marketplaceContract.setApprovalForAll(OWNER, true);
        marketplaceContract.listForAuction(0, AUCITON_DURATION);

        marketplaceContract.bid{value: 1 ether}(0);
        
        assertEq(marketplaceContract.retrieveBidders(0), OWNER);
        assertEq(marketplaceContract.bidPrice(0), 1 ether);
        vm.stopPrank();
    }

    function testMultipleBid() public {
        vm.startPrank(OWNER);
        vm.deal(OWNER, 10 ether);
        marketplaceContract.mint(OWNER);

        marketplaceContract.setApprovalForAll(OWNER, true);
        marketplaceContract.listForAuction(0, AUCITON_DURATION);

        marketplaceContract.bid{value: 1 ether}(0);
        
        assertEq(marketplaceContract.retrieveBidders(0), OWNER);
        assertEq(marketplaceContract.bidPrice(0), 1 ether);
        vm.stopPrank();

        vm.startPrank(USER);
        vm.deal(USER, 10 ether);
        marketplaceContract.bid{value: 2 ether}(0);
        vm.stopPrank();

        assertEq(marketplaceContract.retrieveBidders(0), USER);
        assertEq(marketplaceContract.bidPrice(0), 2 ether);
    }

    //! this case
    function testRevertBidIfAuctionStateIsNotOpen() public {
        vm.startPrank(OWNER);
        vm.deal(OWNER, 10 ether);
        marketplaceContract.mint(OWNER);
        marketplaceContract.setApprovalForAll(OWNER, true);
        marketplaceContract.listForSale{value: LISTING_PRICE}(0, nftPrice);
        vm.stopPrank();

        vm.deal(USER, 10 ether);
        vm.startPrank(USER);
        bytes4 selector = bytes4(keccak256("NftMarketplace__AuctionNotExist()"));
        vm.expectRevert(abi.encodeWithSelector(selector));
        
        marketplaceContract.bid{value: BID_PRICE}(0);
        vm.stopPrank();
    }

    function testRevertBidIfAuctionTimeIsOver() public {
        vm.startPrank(OWNER);
        vm.deal(OWNER, 10 ether);
        marketplaceContract.mint(OWNER);
        marketplaceContract.setApprovalForAll(OWNER, true);
        marketplaceContract.listForAuction(0, AUCITON_DURATION);

        marketplaceContract.bid{value: BID_PRICE}(0);
        vm.stopPrank();

        vm.warp(block.timestamp + AUCITON_DURATION + 1);

        vm.deal(USER, 10 ether);
        vm.startPrank(USER);
        bytes4 selector = bytes4(keccak256("NftMarketplace__AuctionEnded()"));
        vm.expectRevert(abi.encodeWithSelector(selector));
        
        marketplaceContract.bid{value: BID_PRICE}(0);
        
    }

    function testRevertBidIfBidPriceIsSame() public {
        vm.startPrank(OWNER);
        vm.deal(OWNER, 10 ether);
        marketplaceContract.mint(OWNER);
        marketplaceContract.setApprovalForAll(OWNER, true);
        marketplaceContract.listForAuction(0, AUCITON_DURATION);

        marketplaceContract.bid{value: BID_PRICE}(0);
        vm.stopPrank();

        vm.deal(USER, 10 ether);
        vm.startPrank(USER);
        bytes4 selector = bytes4(keccak256("NftMarketplace__BidTooLow()"));
        vm.expectRevert(abi.encodeWithSelector(selector));
        
        marketplaceContract.bid{value: BID_PRICE}(0);
    }

    function testRevertBidIfBidPriceIsBelowTheHighestBidder() public {
        vm.startPrank(OWNER);
        vm.deal(OWNER, 10 ether);
        marketplaceContract.mint(OWNER);
        marketplaceContract.setApprovalForAll(OWNER, true);
        marketplaceContract.listForAuction(0, AUCITON_DURATION);

        marketplaceContract.bid{value: BID_PRICE}(0);
        vm.stopPrank();

        vm.deal(USER, 10 ether);
        vm.startPrank(USER);
        bytes4 selector = bytes4(keccak256("NftMarketplace__BidTooLow()"));
        vm.expectRevert(abi.encodeWithSelector(selector));
    
        marketplaceContract.bid{value: 0.5 ether}(0);
    }

    function testAddMinter() public {
        vm.startPrank(OWNER);
        marketplaceContract.mint(OWNER);
        marketplaceContract.setApprovalForAll(OWNER, true);
        marketplaceContract.listForAuction(0, AUCITON_DURATION);

        marketplaceContract.addMinter(USER);
        vm.stopPrank();

        vm.startPrank(USER);
        marketplaceContract.mint(USER);
        marketplaceContract.setApprovalForAll(USER, true);
        marketplaceContract.listForAuction(1, AUCITON_DURATION);
        vm.stopPrank();
    }

    function testAddMultiMinter() public {
        vm.startPrank(OWNER);
        marketplaceContract.mint(OWNER);
        marketplaceContract.setApprovalForAll(OWNER, true);
        marketplaceContract.listForAuction(0, AUCITON_DURATION);

        marketplaceContract.addMinter(USER);
        marketplaceContract.addMinter(MINTER1);
        marketplaceContract.addMinter(MINTER2);

        vm.stopPrank();
    }

    function testRevertAddMinterIfNotMinter() public {
        vm.startPrank(OWNER);
        marketplaceContract.mint(OWNER);
        marketplaceContract.setApprovalForAll(OWNER, true);
        marketplaceContract.listForAuction(0, AUCITON_DURATION);
        vm.stopPrank();

        bytes4 selector = bytes4(keccak256("NftMarketplace__NotMinter()"));
        vm.expectRevert(abi.encodeWithSelector(selector));
        marketplaceContract.addMinter(USER);
    }

    function testRemoveMinter() public {
        vm.startPrank(OWNER);
        marketplaceContract.mint(OWNER);
        marketplaceContract.setApprovalForAll(OWNER, true);
        marketplaceContract.listForAuction(0, AUCITON_DURATION);

        marketplaceContract.addMinter(USER);
        vm.stopPrank();

        vm.startPrank(USER);
        marketplaceContract.mint(USER);
        marketplaceContract.setApprovalForAll(USER, true);
        marketplaceContract.listForAuction(1, AUCITON_DURATION);
        vm.stopPrank();

        changePrank(OWNER);
        marketplaceContract.removeMinter(USER);

        changePrank(USER);
        bytes4 selector = bytes4(keccak256("NftMarketplace__NotMinter()"));
        vm.expectRevert(abi.encodeWithSelector(selector));
        marketplaceContract.mint(USER);
    }

    function testRemoveMultiMinter() public {
        vm.startPrank(OWNER);
        marketplaceContract.mint(OWNER);

        marketplaceContract.addMinter(USER);
        marketplaceContract.addMinter(MINTER1);
        marketplaceContract.addMinter(MINTER2);
        vm.stopPrank();

        changePrank(USER);
        marketplaceContract.mint(USER);

        changePrank(MINTER1);
        marketplaceContract.mint(MINTER1);

        changePrank(MINTER2);
        marketplaceContract.mint(MINTER2);

        changePrank(OWNER);
        marketplaceContract.removeMinter(USER);
        marketplaceContract.removeMinter(MINTER1);
        marketplaceContract.removeMinter(MINTER2);

        changePrank(USER);
        bytes4 selector = bytes4(keccak256("NftMarketplace__NotMinter()"));
        vm.expectRevert(abi.encodeWithSelector(selector));
        marketplaceContract.mint(USER);
    }

    function testRevertRemoveMinterIfNotMinter() public {
        vm.startPrank(OWNER);
        marketplaceContract.mint(OWNER);
        vm.stopPrank();

        bytes4 selector = bytes4(keccak256("NftMarketplace__NotMinter()"));
        vm.expectRevert(abi.encodeWithSelector(selector));
        marketplaceContract.removeMinter(USER);
    }

    
}