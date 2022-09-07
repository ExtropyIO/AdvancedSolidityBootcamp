const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Types_3 contract", async function() {
  beforeEach(async function() {
    Types3 = await ethers.getContractFactory("Types_3");
    types3 = await Types3.deploy();
    const wallet = ethers.Wallet.createRandom();
  });

  it("Retrieves max_signed", async function() {
    expect(parseInt(await types3.max_signed()), "max_signed != 255").to.equal(
      255
    );
  });

  it("Retrieves neg", async function() {
    expect(parseInt(await types3.neg()), "neg != -666").to.equal(-666);
  });

  it("Retrieves big_neg", async function() {
    expect(
      parseInt(await types3.big_neg()),
      "big_neg != -6666666666666666"
    ).to.equal(-6666666666666666);
  });
});
