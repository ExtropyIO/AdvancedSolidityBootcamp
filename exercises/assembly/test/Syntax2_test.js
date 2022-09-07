const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Token contract", async function () {
	// let Token = await ethers.getContractFactory('/con')

  it("Number of ducks should be a public variable", async function () {
    
    const Structure = await ethers.getContractFactory("Syntax_2");

    const Syntax_2 = await Structure.deploy();
    
    expect(await Syntax_2.numberOfDucks()).to.equal(1000000);

  });
});