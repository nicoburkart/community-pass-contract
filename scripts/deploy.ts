// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers } from "hardhat";

async function main() {
  // We get the contract to deploy
  const MINT_FEE = ethers.utils.parseEther("50");
  const SUPPLY = 200;
  const CreatorNFT = await ethers.getContractFactory("CreatorNFT");
  const creatorNFT = await CreatorNFT.deploy(MINT_FEE, SUPPLY);

  const accounts = await ethers.getSigners();
  const devAddress = await accounts[0].getAddress();
  const addrs = await accounts[2].getAddress();

  await creatorNFT.deployed();

  console.log("CreatorNFT deployed to:", creatorNFT.address);
  console.log(MINT_FEE);

  await creatorNFT.addAddressToWhitelist(addrs);
  await creatorNFT.transferOwnership(await accounts[1].getAddress());

  console.log(
    "paid gas fees",
    ethers.utils.parseEther("10000").sub(await accounts[0].getBalance())
  );

  console.log("dev balance", await accounts[0].getBalance());
  console.log("artist balance", await accounts[1].getBalance());
  console.log("addrs balance", await accounts[2].getBalance());

  // Call the function.
  let txn = await creatorNFT
    .connect(accounts[2])
    .mintNFT(2, { value: MINT_FEE });
  // Wait for it to be mined.
  await txn.wait();

  console.log("addrs balance", await accounts[2].getBalance());
  console.log("artist balance", await accounts[1].getBalance());
  console.log("dev balance", await accounts[0].getBalance());
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
