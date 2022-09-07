const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Token contract", async function () {
  it("Conract deploys", async function () {    

    const Structure = await ethers.getContractFactory("Syntax_1");
    const hardhatToken = await Structure.deploy();    
  });
});