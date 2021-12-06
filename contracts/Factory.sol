// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.10;

import "./AuctionImplementation.sol";
import "@optionality.io/clone-factory/contracts/CloneFactory.sol";

/// @author Tomás Barbosa
contract Factory is AuctionImplementation{
    // I don't think we need a function to get the Auctions, since this would mean storing them and havinh to always change state variables
    // I suggest we use the the getPastEvents web3.js function on the dapp instead and filter through the auctions that are active 
    // this way we don't have to change state variables everytime we create a new auction decreasing the amount of gas necessary
    address internal auctionImplementation;

    constructor(address _auctionImplementation){
        auctionImplementation = _auctionImplementation;
    }

    /// @dev setter for the implementation in case we want to upgrade the implementation later. this will only affect the auctions created after the new
    /// implementation was set

    function setAuctionImplementation(address _auctionImplementation) external onlyOwner {
        auctionImplementation = _auctionImplementation;
    }
    
    ///@dev creating a proxy of the AuctionImplementation and emitting an event informing that we did so
    
    function createAuctions(address _beneficiary,
        uint256 _startingBid,
        uint256 _minIncrease,
        uint256 _auctionEnd,
        uint256 _minimumEnd) 
        external {
            address clone = createClone(auctionImplementation);
            auctionImplementation(clone).init(_beneficiary,
                _startingBid,
                _minIncrease,
                _auctionEnd,
                _minimumEnd);
            emit Init(_beneficiary, _startingBid, _auctionEnd);
    }
}
