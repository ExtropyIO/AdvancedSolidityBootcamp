const { expect, assert } = require("chai");
const { ethers } = require("hardhat");

describe("Token contract", async function () {
	it("Cheddar variable is private", async function () {    

		const Structure = await ethers.getContractFactory("Syntax_3");	
		const Syntax3 = await Structure.deploy();    
		let varCheddarExists;
		try{				
			expect((await Syntax3.Cheddar()).toString()).to.equal((555).toString());
			varCheddarExists = true;
		}		
		catch{
			varCheddarExists = false;
		}
		assert.equal(false, varCheddarExists, 'Variable is still public');

	  });

  	it("getCheddar returns variable twoonket", async function () {    

		const Structure = await ethers.getContractFactory("Syntax_3");
		const Syntax3 = await Structure.deploy();    
		expect((await Syntax3.getCheddar()).toString()).to.equal((555).toString());
  });
});