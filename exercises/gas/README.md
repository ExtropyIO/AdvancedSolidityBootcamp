# Optimisation Game Instructions

1. Open a terminal go to the Gas directory
2. Run ` npm i` to install the dependencies
3. Run ` npx hardhat test` to run the tests and get a gas usage report

![](https://i.imgur.com/qdNy92B.png)

If you prefer to use a different IDE, you may, but you will need to make sure the contract passes the same tests.

The aim of the game is to reduce the Average figures for contract deployment and transfer and updatePayment functions as much as possible.

You can change the contract as much as you like.
You **cannot**  change the tests, and all the tests must pass.

you can slightly adjust tests for whitelist functions if you need so.

In order to generate storage diagram run the following command:

`sol2uml storage ./contracts/ -c GasContract -o gasStorage.svg`
