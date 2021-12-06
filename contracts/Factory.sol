// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.10;

import "./AuctionImplementation.sol";

/// @author Tomás Barbosa
contract Factory {
    

    function getAuction(AuctionImplementation _auction) internal view {

    }

    function createAuctions(address _beneficiary,
        uint256 _startingBid,
        uint256 _minIncrease,
        uint256 _auctionEnd,
        uint256 _minimumEnd) 
        external returns(boolean){
            AuctionImplementation aI = AuctionImplementation.init(_beneficiary, _startingBid, _minIncrease, _auctionEnd, _minimumEnd);
            if (aI != 0) {
                emit Init(_beneficiary, _startingBid, _auctionEnd);
                return true;
            }
            return(false);
    }
}
