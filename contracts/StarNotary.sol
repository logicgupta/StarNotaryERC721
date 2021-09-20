// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import './ERC721Token.sol';

contract StarNotary is ERC721Token{
    
    struct Star{
        string name;
    }

    mapping(uint256=>Star) tokenIdToStar;
    mapping(uint256=>uint256) starsForsale;
    
    function createStar(string memory _name, uint256 _tokenId) public{

        Star memory newStar= Star(_name);

        tokenIdToStar[_tokenId]=newStar;
        ERC721Token.mint(_tokenId);
    }

    function putStarForSale(uint256 _tokenId, uint256 price) public{

        require(this.ownerOf(_tokenId)== msg.sender);

        starsForsale[_tokenId]=price;

    }

    function buyStar(uint256 _tokenId) public payable{
        require(starsForsale[_tokenId]>0);

        uint256 starCost= starsForsale[_tokenId];
        address starOwner=this.ownerOf(_tokenId);

        require(msg.value>=starCost);

        // Make star available for buying
        clearAllStarState(_tokenId);

        ERC721Token.transferFromHelper(starOwner, msg.sender, _tokenId);

        if(msg.value> starCost){
           payable(msg.sender).transfer(msg.value-starCost);
        }


    }

    function clearAllStarState(uint256 _tokenId) public{
        tokenToApproved[_tokenId] = address(0);
        starsForsale[_tokenId]=0;

    }

    
}