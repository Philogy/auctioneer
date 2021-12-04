// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface IAuction {
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
