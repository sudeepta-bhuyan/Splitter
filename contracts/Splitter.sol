pragma solidity ^0.4.20;

contract Splitter {
    address public owner;
    uint256 public balance;
    address[] public receivers;
    mapping(address => uint256) receiverBalances;
    event Split(address from, address to, uint256 amount);
    
    constructor() public {
        owner = msg.sender;
    }
    
    modifier isOwner() {
        assert(msg.sender == owner);
        _;
    }
    
    function getContractBalance() public view returns(uint256) {
        return balance;
    }
    
    function getReceiverBalance(address receiver) public view returns(uint256) {
        return receiverBalances[receiver];
    }
    
    function sendMoney() public payable isOwner() {
       balance += msg.value;
    }
    
    function addReceiver(address receiver) public isOwner {
        assert(receivers.length < 2);
        receivers.push(receiver);
        receiverBalances[receiver] = 0;
    }
    
    function splitMoney() public isOwner() {
        assert(receivers.length == 2);
        receiverBalances[receivers[0]] += balance/2;
        receiverBalances[receivers[1]] += balance/2;
        balance = 0; 
        emit Split(address(this), receivers[0], receiverBalances[receivers[0]]);
        emit Split(address(this), receivers[1], receiverBalances[receivers[1]]);
    }
    
    function withdrawMoney() public {
        uint256 amount = receiverBalances[msg.sender];
        receiverBalances[msg.sender] = 0;
        msg.sender.transfer(amount);
    } 
}
