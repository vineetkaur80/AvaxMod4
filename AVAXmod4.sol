// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DegenGamingToken is ERC20 {


    mapping(uint => mapping(string => uint)) public items;
    mapping(uint => string) public itemInfo;

    mapping(address => string[]) public claimedItems;

    address private owner;
    constructor() ERC20("Degen Gaming Token", "DGT"){
        owner = msg.sender;
        items[1]["Jeans"] = 120;
        items[2]["Top"] = 60;
        items[3]["Middy"] = 10;

        itemInfo[1] = "Jeans";
        itemInfo[2] = "Top";
        itemInfo[3] = "Middy";
    }

    function getItems() external pure returns(string memory){
        return "1. Jeans : 120 2. Top : 60 3. Middy : 10";
    }

    modifier onlyOwner{
        require(msg.sender == owner,"You are not the owner");
        _;
    }

    function mint(address to, uint256 amount) external onlyOwner{
        _mint(to, amount);
    }

    function redeem(uint _itemNo) external {
        string memory itemName = itemInfo[_itemNo];
        uint price = items[_itemNo][itemName];
        require(balanceOf(msg.sender) >= price, "Insufficient balance to redeem");
        _transfer(msg.sender, owner, price);
        claimedItems[msg.sender].push(itemName);
       
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    function transferToken(address _reciever , uint256 amount) external {
        require(balanceOf(msg.sender) >= amount , "You don'thave enough degen tokens to transfer");
        approve(msg.sender, amount);
        transferFrom(msg.sender , _reciever , amount);
    }
    function getBalance() external view returns(uint256) {
        return this.balanceOf(msg.sender);
    }
 }