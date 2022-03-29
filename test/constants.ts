import { BigNumber } from "ethers";
import { ethers } from "hardhat";

interface ITestValue {
  label: string;
  price: BigNumber;
}

export const TIERS: ITestValue[] = [
  { label: "Demo", price: ethers.utils.parseEther("0") },
  { label: "Basic", price: ethers.utils.parseEther("0.03") },
  { label: "Premium", price: ethers.utils.parseEther("0.06") },
  { label: "Diamond", price: ethers.utils.parseEther("0.2") },
];
export const COLORS: ITestValue[] = [
  { label: "Onyx", price: ethers.utils.parseEther("0") },
  { label: "Moonlight", price: ethers.utils.parseEther("0.03") },
  { label: "Diamond", price: ethers.utils.parseEther("0.12") },
];

export const SUPPLY = 20;
