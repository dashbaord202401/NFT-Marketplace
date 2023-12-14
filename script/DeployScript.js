const { ethers, upgrades } = require("hardhat");

async function main() {
  const Market = await ethers.getContractFactory("NftMarketplace2");
  const proxy = await upgrades.deployProxy(Market);
  await proxy.waitForDeployment();

  console.log("nftMarketplace deployed to:", proxy.target);

  //verify
  if(hre.network.name != "hardhat"){
    await hre.run("verify:verify", {
      address: proxy.target,
      contract: "contracts/NftMarketplace2.sol:NftMarketplace2",
      constructorArguments: []
    });
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});


