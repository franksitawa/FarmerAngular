// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FarmerContract is AccessControl,Ownable {
  bytes32 public constant VERIFIER_ROLE = keccak256("VERIFIER_ROLE");
  bytes32 public constant FARMER_ROLE = keccak256("FARMER_ROLE");
  bytes32 public constant FARMER_OWNER_ROLE = keccak256("FARMER_OWNER_ROLE");
  bytes32 public constant BUYER_ROLE = keccak256("BUYER_ROLE");
  bytes32 public constant LENDER_ROLE = keccak256("LENDER_ROLE");
  bytes32 public constant SUPPLIER_ROLE = keccak256("SUPPLIER_ROLE");
  bytes32 public constant WAREHOUSE_OWNER_ROLE = keccak256("WAREHOUSE_OWNER_ROLE");

  struct User{
    string firstName;
    string lastName;
    string email;
    bool termsAccepted;
  }

  struct UserDocument{
    string name;
    string uri;
    bool verified;
  }

  mapping(address=>User) public users;
  mapping(address=>mapping(bytes32=>UserDocument[])) public userDocuments;
  
  mapping(address=>mapping(bytes32=>bool)) roleRequests;
 
  event UserRegistered(
    string firstName,
    string lastName,
    string email,
    bool termsAccepted,
    uint date
  );

  
  constructor() public {
    _grantRole(DEFAULT_ADMIN_ROLE,msg.sender);
  }

  function registerUser(string memory firstName,string memory lastName,string memory email,bool termsAccepted) public{
    require(termsAccepted,"Please accept the terms and conditions before continuing");
    users[msg.sender]=User({
      firstName:firstName,
      lastName:lastName,
      email:email,
      termsAccepted:termsAccepted
    });
    emit UserRegistered(
      firstName,
      lastName,
      email,
      termsAccepted,
      block.timestamp
    );
  }

  
  function requestRoleVerification(string memory role) public{
    require(users[msg.sender].termsAccepted,"You are not registered.");
    roleRequests[msg.sender][keccak256(abi.encode(role))]=true;
  }
  function addUserDocument(string memory uri,string memory name,string memory role) public{
    require(users[msg.sender].termsAccepted,"You are not registered.");
    userDocuments[msg.sender][keccak256(abi.encode(role))].push(UserDocument({
      name:name,
      uri:uri,
      verified:false
    }));
  }
  function verifyUserRole(address user,string memory role) onlyRole(VERIFIER_ROLE) public{
    roleRequests[user][keccak256(abi.encode(role))]=false;
    _grantRole(keccak256(abi.encode(role)),user);
  }
  
}

