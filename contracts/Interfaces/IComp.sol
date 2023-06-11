// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IComp {
    // View functions
    function balanceOf(address account) external view returns (uint256);
    function getTotalVotes(address account) external view returns (uint256);
    function getVotes(address account, uint256 blockNumber) external view returns (uint256);

    // State changing functions
    function delegate(address delegatee) external;
    function delegateBySig(
        address delegatee,
        uint256 nonce,
        uint256 expiry,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;
    function transfer(address dst, uint256 rawAmount) external returns (bool);
    function transferFrom(
        address src,
        address dst,
        uint256 rawAmount
    ) external returns (bool);
}