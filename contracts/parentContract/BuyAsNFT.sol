// SPDX-License-Identifier: MIT

// version 1.0;
pragma solidity ^0.8.10;


contract BuyAsNFT{

    struct NFT{
        uint256 NFTCount;
        uint256 TotalCount;
        uint256 TokenValue;
        address[] WalletAd;
        address CreatorsWallet;
        string[] mailAddress;
    }

    constructor(){
    }
    //  basicially what this mapping does is this maps outs the Owners of NFt
    mapping (uint256 => address[] )private NFTOwners;
    
    mapping (uint256 => NFT ) private NFT_structure ;
    // and this maps out nft which single wallet owns 
    mapping (address => uint256[] )private ListNFT ;  

    
    
    function getWallet(uint256 _id,address payable NFT_Creator )public view returns(address[] memory){
        return NFT_structure[_id].WalletAd;
    }


    function ListingPrice(uint256 price ,uint256 _id,address Creator,uint256 NFTCount)public {
        NFT_structure[_id].TokenValue = price;
        NFT_structure[_id].CreatorsWallet = Creator;
        NFT_structure[_id].NFTCount = 0 ;
        NFT_structure[_id].TotalCount = NFTCount-1;
    }

    event showNFTAvaiable(uint256 nft);
    function BuyTrack(address BuyersAdd,uint256 _id,string memory email)public payable returns (bool) {
        emit showNFTAvaiable(NFT_structure[_id].NFTCount);
        require(NFT_structure[_id].NFTCount <= NFT_structure[_id].TotalCount,"NFT are Sold-out");
        require(msg.value <  NFT_structure[_id].TokenValue,"not enough ether");

        (bool sent, bytes memory data) = NFT_structure[_id].CreatorsWallet.call{value: msg.value}("");
            require(sent, "Failed to send Ether");
                NFT_structure[_id].NFTCount = NFT_structure[_id].NFTCount + 1 ;
                NFT_structure[_id].WalletAd.push(BuyersAdd);
                NFTOwners[_id].push(BuyersAdd);
                ListNFT[msg.sender].push(_id);
                NFT_structure[_id].mailAddress.push(email);
            return true;
    }


    function GetListOfNFTOwned()public view returns (uint256[] memory){
        return ListNFT[msg.sender];
    }
    function getIndividualNFT(uint256 _id) public view returns (NFT memory){
        return NFT_structure[_id];
    }
    
    receive() external payable{}
    
    fallback() external payable{}
    
}
