
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 < 0.9.0;

contract Lottery
{
    address public manager; //4b2
    address payable [] public participants; //dynamic array

    constructor()
    {
        manager=msg.sender; //deployed account becomes the owner/manager/global variable
    }


    receive()external payable
    {
        require(msg.value==1 ether);
      participants.push(payable(msg.sender)); //payable is required for version 8, works fine with 7
    }


    function getbalance()public view returns(uint)
    {
        require(msg.sender==manager);
        return address(this).balance;
    }

    function random()public view returns(uint)
    {
       return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length)));
    }
    
    function SelectWinner()public 
    {
        require(msg.sender==manager);
        require(participants.length>=3);
        uint r=random();
        address payable winner;
        uint index =r % participants.length; //participants.length gives the length of the dynamic array(getting the index value of the array
        winner=participants[index];
        winner.transfer(getbalance());
        participants=new address payable [](0); //reseting 
    }
}