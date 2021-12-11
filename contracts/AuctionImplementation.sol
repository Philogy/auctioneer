// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.10;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "./IAuction.sol";

/// @author Philippe Dumonet
contract AuctionImplementation is
    IAuction,
    IERC721Receiver,
    Initializable,
    ReentrancyGuardUpgradeable
{
    address internal factory;

    address public topBidder;
    address public beneficiary;
    uint256 public topBid;
    uint256 public minIncrease;
    uint256 public auctionEnd;
    uint256 public minimumEnd;

    function init(
        address _beneficiary,
        uint256 _startingBid,
        uint256 _minIncrease,
        uint256 _auctionEnd,
        uint256 _minimumEnd
    ) external initializer {
        factory = msg.sender;
        __ReentrancyGuard_init();
        require(_minIncrease > 0, "Auction: Minimum increase 0%");
        require(_startingBid > 0, "Auction: Starting bid");
        beneficiary = _beneficiary;
        topBid = _startingBid;
        minIncrease = _minIncrease;
        auctionEnd = _auctionEnd;
        minimumEnd = _minimumEnd;
    }

    function onERC721Received(
        address _operator,
        address,
        uint256,
        bytes calldata
    ) external view returns (bytes4) {
        require(_operator == factory, "Auction: Invalid depositor");
        return this.onERC721Received.selector;
    }

    function bid() external payable nonReentrant {
        require(msg.value >= getMinimumBid(), "Auction: Bid too low");
        require(!getAuctionEnded(), "Auction: Ended");
        address prevBidder = topBidder;
        uint256 prevBid = topBid;
        topBidder = msg.sender;
        topBid = msg.value;
        _checkMinimumEnd();

        // solhint-disable-next-line avoid-low-level-calls
        if (prevBidder != address(0)) prevBidder.call{value: prevBid}("");
    }

    function settle() external nonReentrant {
        require(getAuctionEnded(), "Auction: Running");
        uint256 winningBid = topBid;
        require(winningBid > 0, "Auction: Already settled");
        topBid = 0;
        if (topBidder == address(0)) {
            topBidder = beneficiary;
        } else {
            beneficiary.call{value: winningBid}("");
        }
    }

    function withdrawTokensTo(
        IERC721[] calldata _collections,
        uint256[] calldata _tokenIds,
        address _recipient
    ) external {
        require(getAuctionEnded(), "Auction: Running");
        require(msg.sender == topBidder, "Auction: Now owner");
        require(_collections.length == _tokenIds.length, "Auction: Length mismatch");

        for (uint256 i = 0; i < _collections.length; i++) {
            _collections[i].safeTransferFrom(address(this), _recipient, _tokenIds[i]);
        }
    }

    function getMinimumBid() public view returns (uint256) {
        if (topBidder == address(0)) return topBid;
        return topBid + (topBid * minIncrease) / 1e4;
    }

    function getAuctionEnded() public view returns (bool) {
        return block.timestamp > auctionEnd;
    }

    function _checkMinimumEnd() internal {
        uint256 minimumEnd_ = minimumEnd;
        if (auctionEnd - block.timestamp < minimumEnd_) {
            auctionEnd = block.timestamp + minimumEnd_;
        }
    }
}
