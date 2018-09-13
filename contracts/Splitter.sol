pragma solidity ^0.4.20;
import "./Owned.sol";

contract Splitter is Owned {

    uint256 public balance;
    address public receiver1;
    address public receiver2;
    mapping(address => uint256) public receiverBalances;
    event LogSplitFund(address beneficiary1, address beneficiary2, uint256 amount);
    event LogWithdrawFund(address who, uint256 amount);

    constructor (address beneficiary1, address beneficiary2) public {
        receiver1 = beneficiary1;
        receiver2 = beneficiary2;
        receiverBalances[receiver1] = 0;
        receiverBalances[receiver2] = 0;
    }

    function splitFund() public payable ownerOnly {
        balance += msg.value;
        uint amounttoSplit = balance/2;
        receiverBalances[receiver1] += amounttoSplit;
        receiverBalances[receiver2] += amounttoSplit;
        balance -= amounttoSplit * 2;
        emit LogSplitFund(receiver1, receiver2, amounttoSplit);
    }
    
    function withdrawFund() public {
        uint256 amount = receiverBalances[msg.sender];
        receiverBalances[msg.sender] = 0;
        msg.sender.transfer(amount);
        emit LogWithdrawFund(msg.sender, amount);
    } 
}
