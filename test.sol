// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyContract {
    // State variable 
    int8 public myInt8 = 1; 
    uint public  myUint = 1; 
    uint8 public  myUint8 = 1; 
    uint256 public  myUint256  = 1;
    string public myString  = "With Love from Whydah" ; 
    bytes32 public bytes32 = "Bao is gay";
    address public myAddress = "0x13761B652F768F27E2d03b6a084bCf630279aF3d";
    struct MyStruct {
        uint256 myUint256,
        string myString 
    }
    MyStruct public myStruct = MyStruct (1,"Hello World");
    // Local variable
    function getValue() public pure returns(uint){
        uint value = 1;
        return value;
    }

    function test () pure view returns(bool){
        return true;
    }
}