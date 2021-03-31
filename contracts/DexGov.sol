// SPDX-License-Identifier: MIT

pragma solidity ^0.7.3;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "hardhat/console.sol";

contract IdentityBase is ERC1155 {
    address public owner;
    address public governor;

    enum UserTypes {Shipper, Carrier, Broker, Driver}

    // Modifiers

    modifier onlyOwner {
        require(msg.sender == owner, "only owner can call this");
        _;
    }
    modifier onlyIfUserTypeExists(uint256 _userType) {
        // One of the four main options
        require(_userType <= 4, "user type not valid");
        _;
    }

    constructor(address _owner, address _governor)
        public
        ERC1155("https://dexP2P.example/api/user/{id}.json")
    {
        owner = _owner;
        governor = _governor;
    }

    // Main functions

    function mintIdentity(address _user, uint256 _userType)
        public
        onlyIfUserTypeExists(_userType)
    {
        _mint(_user, _userType, 1, "");
    }
}

contract DexGov is ERC1155 {
    address public governance;
    mapping(address => uint256) public users;

    uint256 public constant NODE_ID = 0; // NFT for Identity

    uint256 public constant GOV = 1; // ERC20 for governance
    uint256 public GOV_SUPPLY = 10**18;

    uint256 public constant FUEL = 2; // ERC20 for rewards
    uint256 public FUEL_SUPPLY = 10**27;

    modifier onlyGovernance() {
        require(msg.sender == governance, "only governance can call this");
        _;
    }

    constructor(address governance_)
        ERC1155("https://dexP2P.example/api/node/{id}.json")
    {
        governance = governance_;
        _mint(msg.sender, NODE_ID, 1, "");
        _mint(msg.sender, GOV, GOV_SUPPLY, "");
        _mint(msg.sender, FUEL, FUEL_SUPPLY, "");

        console.log("Sender balance is %s GOVs", balanceOf(msg.sender, 1));
        console.log("Sender balance is %s FUELs", balanceOf(msg.sender, 2));
    }

    function addNewUser(address _user, uint256 _userType)
        public
        onlyGovernance
        returns (uint256)
    {
        IdentityBase idBase = new IdentityBase(_user, governance);
        idBase.mintIdentity(_user, _userType);
        users[_user] = _userType;
        console.log("New user %s has user type ", _user, users[_user]);
    }
}
