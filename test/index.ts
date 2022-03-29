import { expect } from "chai";
import { ethers } from "hardhat";
import { Signer } from "ethers";
import { CommunityPass } from "../typechain";
import { COLORS, TIERS, SUPPLY } from "./constants";

// await with reverted tests before expect and everywhere else inside expect

describe("CommunityPass", () => {
  let accounts: Signer[];
  let rootAddress: string;
  let userAddress: string;

  let communityPass: CommunityPass;

  beforeEach(async () => {
    const Renderer = await ethers.getContractFactory("Renderer");
    const renderer = await Renderer.deploy();

    const CommunityPass = await ethers.getContractFactory("CommunityPass");
    communityPass = await CommunityPass.deploy(SUPPLY);

    await communityPass.deployed();
    await communityPass.setRenderer(renderer.address);

    accounts = await ethers.getSigners();
    rootAddress = await accounts[0].getAddress();
    userAddress = await accounts[5].getAddress();
  });

  describe.skip("Deployment", () => {});

  //------------ CONTRACT MODIFIER ORIENTED TESTS

  describe("Mint", () => {
    // whenSaleActive
    it("Should not allow mint before sale started", async () => {
      await expect(
        communityPass.mintNFT(TIERS[0].label, COLORS[0].label, {
          from: rootAddress,
          value: 0,
        })
      ).to.be.revertedWith("Sale is not active");
    });

    it("Should allow anyone to mint after sale started", async () => {
      await communityPass.flipSaleStarted();

      expect(
        await communityPass.mintNFT(TIERS[0].label, COLORS[0].label, {
          from: rootAddress,
          value: 0,
        })
      )
        .to.emit(communityPass, "Transfer")
        .withArgs(ethers.constants.AddressZero, rootAddress, 1);
    });

    // whenTokenLeft
    it("Should not mint more than " + SUPPLY + " NFTs", async () => {
      await communityPass.flipSaleStarted();
      for (let i = 0; i < SUPPLY; i++) {
        await communityPass.mintNFT(TIERS[0].label, COLORS[0].label, {
          from: rootAddress,
          value: 0,
        });
      }

      await expect(
        communityPass.mintNFT(TIERS[0].label, COLORS[0].label, {
          from: rootAddress,
          value: 0,
        })
      ).to.be.revertedWith("No tokens left");
    });

    // whenColorPatternExists
    it("Should not mint with invalid color pattern", async () => {
      await communityPass.flipSaleStarted();

      await expect(
        communityPass.mintNFT(TIERS[0].label, "testColor", {
          from: rootAddress,
          value: 0,
        })
      ).to.be.revertedWith("Color pattern doesn't exist");
    });

    // whenTierExists
    it("Should not mint with invalid Tier", async () => {
      await communityPass.flipSaleStarted();

      await expect(
        communityPass.mintNFT("testTier", COLORS[0].label, {
          from: rootAddress,
          value: 0,
        })
      ).to.be.revertedWith("Tier doesn't exist");
    });

    // whenMintFeeIncluded
    it("Should not mint with insuffient funds", async () => {
      await communityPass.flipSaleStarted();

      await expect(
        communityPass.mintNFT(TIERS[1].label, COLORS[1].label, {
          from: rootAddress,
          value: 0,
        })
      ).to.be.revertedWith("Mint fee not included");
    });

    // positive test for all mint modifiers
    it("Should mint every combination of traits (Tier and Color)", async () => {
      await communityPass.flipSaleStarted();
      let tokenId = 0;

      TIERS.forEach((tier) => {
        COLORS.forEach(async (color) => {
          tokenId++;
          await communityPass.mintNFT(tier.label, color.label, {
            from: rootAddress,
            value: tier.price.add(color.price),
          });
        });
      });
      expect(await communityPass.balanceOf(rootAddress)).equals(tokenId);
    });
  });

  /* describe("Transactions", () => {
    

    
    

    

    it("Should upgrade a token", async () => {
      await communityPass.flipSaleStarted();

      await communityPass.mintNFT("Basic", "Onyx", {
        from: await accounts[0].getAddress(),
        value: ethers.utils.parseEther("0.03"),
      });

      await expect(
        await communityPass.upgradeTier(1, "Premium", {
          from: await accounts[0].getAddress(),
          value: ethers.utils.parseEther("0.03"),
        })
      )
        .to.emit(communityPass, "UpgradedTier")
        .withArgs(1, "Premium");
    });
  }); */
});
