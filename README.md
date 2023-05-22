
# Pharmaceutical Management Contract

This smart contract is designed to facilitate the management of pharmaceutical supplies and retailers. It leverages the ERC1155 standard for handling tokenized assets and includes features such as drug minting, supply proposals, and transfers between retailers and customers. The contract is implemented in Solidity and utilizes the OpenZeppelin library for ERC1155 tokens.

Deployed in Mumbai Testnet at `0x53cBC4A6Cad580CADa55484D311F18c103e2F371`

## Prerequisites

To run this contract, you need the following:

- Solidity compiler version 0.8.9 or compatible
- OpenZeppelin library with ERC1155 implementation

## Contract Overview

The `pharmaceutical_management` contract is an ERC1155 token contract with added functionality for managing pharmaceutical supplies and retailers. Here are the key features and functionalities:

### ERC1155 Token Implementation

This contract extends the ERC1155 standard from the OpenZeppelin library. It allows for the creation, minting, and transfer of tokenized pharmaceutical assets. Each pharmaceutical drug is represented by a unique token ID.

### Pharmaceutical Drugs

The contract maintains a mapping of pharmaceutical drug names to their corresponding token IDs. The initial set of drugs is predefined in the constructor, but new drugs can be added dynamically using the `addDrug` function.

### Retailer Registration

Retailers can register themselves by providing their name, phone number, and store address using the `regRetailers` function. Each retailer is assigned a unique retailer ID and their details are stored in the `Retailers` mapping. Retailer status (active or not) can be modified by the contract owner.

### Supply Proposals

Retailers can submit supply proposals when they need more supply of a particular drug. The proposals include the requesting retailer's address, the drug name, the required amount, and a status indicating whether the proposal has been accepted or rejected. Supply proposals are stored in the `Supply_proposals` array.

### Minting and Transferring Drugs

The contract owner has the ability to mint new tokens for a specific drug using the `mint` function. Tokens can be transferred from the contract owner's address to a retailer's address using the `transferDrugstoRetailers` function. Additionally, retailers can transfer drugs to customers using the `retailerToCustomer` function.

## Getting Started

To deploy and interact with this contract, follow these steps:

1. Deploy the `pharmaceutical_management` contract to a compatible Ethereum network.
2. Once deployed, use the contract owner address to perform administrative functions like adding drugs, updating URIs, and managing retailers.
3. Retailers can register themselves using the `regRetailers` function.
4. Retailers can submit supply proposals using the `needMoreSupply` function.
5. The contract owner can review and accept/reject supply proposals using the `acceptedProposal` and `rejectedProposal` functions.
6. Retailers can check their drug balances using the `retailerDrugBalance` function.
7. Retailers and customers can transfer drugs to each other using the `retailerToCustomer` function.

**Note**: It is recommended to use a development or test network for deploying and testing the contract.

## Example Code Snippets

### Minting a Drug Token

```solidity
// Mint a new token for a drug
function mint(string memory _drugName, uint256 supply) public onlyOwner {
    require(drugs[_drugName] != 0, "Drug doesn't exist");
    _mint(msg.sender, drugs[_drugName], supply, "");
}
```

### Retailer Registration

```solidity
// Register a retailer
function regRetailers(
    string memory _name,
    string memory _phone_no,
    string memory _store_address
) public {
    require(isRetailerRegistered[msg.sender]

 == false, "Already registered");
    Retailers[msg.sender] = retailer_details(
        msg.sender,
        _name,
        _phone_no,
        _store_address,
        true
    );
    _retailercount++;
    retailer_id[_retailercount] = msg.sender;
    isRetailerRegistered[msg.sender] = true;
}
```

### Transferring Drugs to a Retailer

```solidity
// Transfer drugs to a retailer
function transferDrugstoRetailers(
    string memory _drugName,
    uint256 amount,
    address retailer
) public onlyOwner {
    require(balanceOf(msg.sender, drugs[_drugName]) > amount, "Not enough tokens");
    require(Retailers[retailer].status == true, "Retailer is not active");
    _safeTransferFrom(msg.sender, retailer, drugs[_drugName], amount, "");
}
```

For more detailed explanations and code snippets, please refer to the contract source code.

## License

This contract is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

---

Feel free to modify and enhance this README template to suit your specific needs.