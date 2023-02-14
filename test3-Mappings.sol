// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyContract {
    //Mappings
    mapping(uint  => string) names;
    mapping(uint  => Book) public books;
    mapping(address => mapping(uint  => Book)) public myBooks; 

    struct Book {
        string title;
        string author;

    }
    constructor() public {
        names[1] = "Adam";
        names[2] = "Bao";
        names[3] = "Duc";
    }
    function addBook(
        uint _id, 
        string memory _title, 
        string memory _author
    ) public{
        books[_id] = Book(_title, _author);
    }
    function addMyBook(
        uint _id, 
        string memory _title, 
        string memory _author
    ) public{
    //msg global variable
        books[msg.sender][_id] = Book(_title, _author);
    }
}