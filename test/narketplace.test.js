const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("NftMarketplace2", function () {
  let owner, minter, user, nftMarketplace;

  beforeEach(async function () {
    [owner, minter, user] = await ethers.getSigners();

    const NftMarketplace2 = await ethers.getContractFactory("NftMarketplace2");
    nftMarketplace = await NftMarketplace2.connect(minter).deploy();
    await nftMarketplace.initilizer();
  });

  it("should mint tokens", async function () {
    await nftMarketplace.connect(minter).mint(user.address);
    const userBalance = await nftMarketplace.balanceOf(user.address);
    expect(userBalance).to.equal(1);
  });

  //rest of the test cases....
  
  //I tested all the test cases in Foundry. please find the test file in the test/NftMarketplace2.t.sol
});
