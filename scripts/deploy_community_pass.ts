import { ethers } from "hardhat";

async function main() {
  const SUPPLY = 1111;
  const RENDERER_ADDRESS = "0xf9c2360eb977aa70ae1fdd0a3eb696348ca3aa5b";

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
