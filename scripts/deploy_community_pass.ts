import { ethers } from "hardhat";

async function main() {
  const CommunityPass = await ethers.getContractFactory("CommunityPass");
  const communityPass = await CommunityPass.deploy();

  await communityPass.deployed();

  console.log("CommunityPass deployed to:", communityPass.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

0xf9c2360eb977aa70ae1fdd0a3eb696348ca3aa5b;
