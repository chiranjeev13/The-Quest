// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract pharmaceutical_management is ERC1155, Ownable {
  using Strings for uint256;

  uint256 drugId = 5;
  uint256 _retailercount = 0;

  struct retailer_details {
    address retailer_address;
    string retailer_name;
    string retailer_phoneno;
    string retailer_storeAddress;
    bool status; //active or not
  }

  struct supply_proposals {
    address requestBy;
    string drugName;
    uint256 amount;
    uint256 status; //0-rejected or 1-accepted
  }

  mapping(string => uint256) public drugs;
  mapping(address => retailer_details) public Retailers;
  mapping(uint256 => address) public retailer_id;
  mapping(address => bool) public isRetailerRegistered;

  supply_proposals[] public Supply_proposals;

  constructor()
    ERC1155(
      "https://bafybeicrwdy75gt3fmhdv5wgrdxkeznq3pbnskbzerx6rbxl2fzhyfygi4.ipfs.nftstorage.link/"
    )
  {
    drugs["Benadryl"] = 1;
    drugs["Aleve"] = 2;
    drugs["Sudafed"] = 3;
    drugs["Sinarest"] = 4;
    drugs["Crocin"] = 5;
  }

  function mint(string memory _drugName, uint256 supply) public onlyOwner {
    require(drugs[_drugName] != 0, "drug doesn't exist");
    _mint(msg.sender, drugs[_drugName], supply, "");
  }

  function addDrug(string memory drugName) public onlyOwner {
    drugId++;
    drugs[drugName] = drugId;
  }

  function updateUri(string memory newUri) public onlyOwner {
    _setURI(newUri);
  }

  function returnUri(string memory _drugName) public returns (string memory) {
    return (
      string(abi.encodePacked(uri(1), (drugs[_drugName]).toString(), ".json"))
    );
  }

  function regRetailers(
    string memory _name,
    string memory _phone_no,
    string memory _store_address
  ) public {
    require(isRetailerRegistered[msg.sender] == false, "Already Registered!!");
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

  function transferDrugstoRetailers(
    string memory _drugName,
    uint256 amount,
    address retailer
  ) public onlyOwner {
    require(balanceOf(msg.sender, drugs[_drugName]) > amount, "Not enough!!");
    require(Retailers[retailer].status == true);
    _safeTransferFrom(msg.sender, retailer, drugs[_drugName], amount, "");
  }

  function retailerDrugBalance(
    string memory _drugName,
    address retailer
  ) public view returns (uint256) {
    return balanceOf(retailer, drugs[_drugName]);
  }

  function revokeRetailer(address retailer) public onlyOwner {
    require(Retailers[retailer].status == true, "already Revoked");
    Retailers[retailer].status = false;
  }

  function continueRetailer(address retailer) public onlyOwner {
    require(Retailers[retailer].status == false, "already Continuing");
    Retailers[retailer].status = true;
  }

  function needMoreSupply(string memory _drugName, uint256 amount) public {
    require(Retailers[msg.sender].status == true, "Not a retailer");
    Supply_proposals.push(supply_proposals(msg.sender, _drugName, amount, 2));
  }

  function acceptedProposal(uint256 id) public onlyOwner {
    require(Supply_proposals[id].status == 2, "Decision already taken");
    Supply_proposals[id].status = 1;
    addDrug(Supply_proposals[id].drugName);
    mint(Supply_proposals[id].drugName, Supply_proposals[id].amount);
  }

  function rejectedProposal(uint256 id) public onlyOwner {
    require(Supply_proposals[id].status == 2, "Decision already taken");
    Supply_proposals[id].status = 0;
  }

  function retailerToCustomer(
    address _customer,
    string memory _drugName,
    uint256 amount
  ) public {
    require(Retailers[msg.sender].status == true, "Not a retailer");
    require(balanceOf(msg.sender, drugs[_drugName]) > amount, "Not enough!!");
    _safeTransferFrom(msg.sender, _customer, drugs[_drugName], amount, "");
  }
}
