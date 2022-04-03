// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;
import './BuyAsNFT.sol';
contract artistDB is BuyAsNFT{

    address public user;
    
    constructor(){
        user = msg.sender;
    }   
    // here we got the user who called the contract ;

    //  we now need to declared dataStructures ;

    struct MetaData{
        uint256 _id;
        string ArtistName ;
        string SongName;
        string CoverURL;
        string ArtURL;
        uint Length;
        uint TimeStamp;
        address Owner;
    }
    
    modifier callerOfContract {
        user = msg.sender;
        _;
    }

    // initilizing necessary variable
    uint256 id = 0 ;
    // Main Mapping
    mapping(uint256 => MetaData ) private song;
    
    // searchMapping
    mapping(string => uint256 ) private SearchName;
    
    // Explore Mapping
    mapping(string => string[] ) private exploreSong;

    mapping(string => string[] ) private Artist ; 
    // event 
    event Test(MetaData  data);

    // a Getter function 

    // # make this function private 
    // # make it Upload
    // push songName parameter to the front 
    function Upload(string memory _Artist,string memory _SongName,string memory _CoverURL,string memory _TrackURL,uint256  _ReleaseDate,uint256  _TrackLength,string memory _Genre,uint256 _nftPrice,uint256 _nftCount) private {
        MetaData memory meta = MetaData(id,_Artist,_SongName,_CoverURL,_TrackURL,_TrackLength,_ReleaseDate,msg.sender);
       
        song[id] = meta;

        SearchName[_SongName] = id;

        Artist[_Artist].push(_SongName);
        
        exploreSong[_Genre].push(_SongName);
        // let make it static for test purpose 
        // price = 1 ether 
        ListingPrice(_nftPrice,id,msg.sender,_nftCount);
        
        id++;
    }
// # make it GetArtistSongsList 
    function GetArtistSongList(string memory _artistName) public view returns (string [] memory){
        return Artist[_artistName];
    }

//  Uploading a songs to SmartContract 
    // # make it UploadSong
    function UploadSong(string memory _Artist,string memory _SongName,string memory _CoverURL,string memory _TrackURL,uint256 _ReleaseDate,uint256 _TrackLength,string memory _Genre,uint256 _nftPrice,uint256 _nftCount)public {
        // require(msg.sender == walletAd,"Connect with Corret wallet");
        Upload(_Artist,_SongName,_CoverURL,_TrackURL,_ReleaseDate,_TrackLength,_Genre,_nftPrice,_nftCount);
    }

    // functilonality ## SEARCH ##
    // # make it SeachSong
    function SearchSong(string memory _search )public view returns(MetaData memory)  {
        return song[SearchName[_search]];
    }

    // functilonality ## Explore ##
    function Explore(string memory _G) public view returns (string[] memory)  {
        return  exploreSong[_G];
    }

    function GetSpecificExplore(string memory _G,uint  _id )private view returns (string memory)  {
        return exploreSong[_G][_id];
    }

    // For newlyRelease Tracks 
        // retruning id and than fetch top 20 songs according to id 
    function NewlyRealsed()public view returns (uint){
        return id;
    }
    function BuyNFT(uint256 id , address walletAd) public payable{
        require(msg.sender == walletAd,"Connect with Corret wallet");
        BuyTrack(walletAd,id);
    }

    function GetListOfNFTOWned()public view returns (uint256[] memory){
        return GetListOfNFTOwned();
    }

}
