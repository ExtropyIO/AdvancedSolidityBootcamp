const { expect, assert } = require("chai");
const { ethers } = require("hardhat");

describe("Assembly Intro contract", async function() {
  console.log("testing assembly");
  it("Conract deploys", async function() {
    const intro = (await ethers.getContractFactory("Intro")).deploy();
  });

  it("returns 420", async function() {
    const intro = await (await ethers.getContractFactory("Intro")).deploy();
    let ret = await intro.intro();
    expect(ret).to.equal(420);
  });
});
