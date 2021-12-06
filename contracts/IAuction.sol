// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface IAuction {
    
    event Init(address _beneficiary,
        uint256 _startingBid,
        uint256 _auctionEnd);

    event Settle(uint256 winningBid, address winner);

    event Bid(address bidder, uint256 bidValue);

    function init(
        address _beneficiary,
        uint256 _startingBid,
        uint256 _minIncrease,
        uint256 _auctionEnd,
        uint256 _minmumEnd
    ) external;

    function bid() external payable;

    function settle() external;

    function getMinimumBid() external view returns (uint256);

    function withdrawTokensTo(
        IERC721[] calldata _collections,
        uint256[] calldata _tokenIds,
        address _recipient
    ) external;
}
