// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @author Philippe Dumonet
contract TestData is Ownable {
    uint256 public a;

    constructor() Ownable() {}

    function setA(uint256 _newA) external onlyOwner {
        a = _newA;
    }
}
