import { ethers } from "hardhat";

async function main() {
  const SUPPLY = 1111;
  const RENDERER_ADDRESS = "0x288823629674F8281715FF6bA539fA7b5F431a27";

  const CommunityPass = await ethers.getContractFactory("CommunityPass");
  const communityPass = await CommunityPass.deploy(SUPPLY);

  await communityPass.deployed();
  await communityPass.setRenderer(RENDERER_ADDRESS);

  console.log("CommunityPass deployed to:", communityPass.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
