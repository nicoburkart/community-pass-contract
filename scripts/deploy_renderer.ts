import { ethers } from "hardhat";

async function main() {
  const Renderer = await ethers.getContractFactory("Renderer");
  const renderer = await Renderer.deploy();

  await renderer.deployed();

  console.log("Renderer deployed to:", renderer.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
