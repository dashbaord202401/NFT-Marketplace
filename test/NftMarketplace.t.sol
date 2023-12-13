// // SPDX-License-Identifier: MIT

// pragma solidity ^0.8.19;
// import {Test} from "forge-std/Test.sol";
// import {NftMarketplace} from "../src/NftMarketplace.sol";


// contract NftMarketpalceTest is Test {
//     uint256 public constant LISTING_PRICE = 0.0001 ether;
//     NftMarketplace marketplaceContract;
    
//     address public OWNER = makeAddr("owner");
//     address public USER = makeAddr("user");


//     function setUp() public {
//         OWNER = msg.sender;
//         vm.prank(OWNER);
//         marketplaceContract = new NftMarketplace();
//         vm.stopPrank();
//     }

//     function testMintNft() public {
//         vm.startPrank(OWNER);
//         marketplaceContract.mint(OWNER);
//         vm.stopPrank();

//         assertEq(marketplaceContract.balanceOf(OWNER), 1);
//         assertEq(marketplaceContract.ownerOf(0), OWNER);
//     }

//     function testListForSale() public {
//         vm.startPrank(OWNER);
//         vm.deal(OWNER, 10 ether);
//         marketplaceContract.mint(OWNER);

//         marketplaceContract.setApprovalForAll(OWNER, true);
//         marketplaceContract.listForSale{value: LISTING_PRICE}(0, 1 ether);
//         vm.stopPrank();
//     }

//     function testListForAuction() public {
//         vm.startPrank(OWNER);
//         vm.deal(OWNER, 10 ether);
//         marketplaceContract.mint(OWNER);

//         marketplaceContract.setApprovalForAll(OWNER, true);
//         marketplaceContract.listForAuction(0, 10);
//         vm.stopPrank();
//     }

//     function testBid() public {
//         vm.startPrank(OWNER);
//         vm.deal(OWNER, 10 ether);
//         marketplaceContract.mint(OWNER);

//         marketplaceContract.setApprovalForAll(OWNER, true);
//         marketplaceContract.listForAuction(0, 86400);

//         marketplaceContract.bid{value: 1 ether}(0);
//         vm.stopPrank();
//     }

    
// }