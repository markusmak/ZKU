// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;

// Create Hello World contract
contract HelloWorld {

    // Declare unsigned integer
    uint integer;

    // Set function to set the unsigned integer 
    function setInteger(uint x) public {
        integer = x;
    }

    // Get funciton to retrieve the unsigned integer
    function getInteger() public view returns (uint) {
        return integer;
    }

}




