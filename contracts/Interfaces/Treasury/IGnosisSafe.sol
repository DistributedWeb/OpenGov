// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGnosisSafe {
    // Events
    event ExecutionFailure(uint256 indexed txHash, uint256 payment);
    event ExecutionSuccess(uint256 indexed txHash, uint256 payment);
    event SignerAdded(address indexed signer);
    event SignerRemoved(address indexed signer);
    event ThresholdChange(uint256 threshold);
    event ApproveHash(bytes32 indexed approvedHash,(address indexed owner));
    
    // Functions
    function setup(address[] calldata _owners, uint256 _threshold, address to, bytes calldata data, bytes32 fallbackHandler, address paymentToken, uint256 payment, uint256 paymentReceiver) external;
    function getOwners() external view returns (address[] memory);
    function getThreshold() external view returns (uint256);
    function isOwner(address owner) external view returns (bool);
    function execTransaction(address to, uint256 value, bytes calldata data, uint8 operation, uint256 safeTxGas, uint256 baseGas, uint256 gasPrice, address gasToken, address payable refundReceiver, bytes calldata signatures) external payable returns(bool);
    function getMessageHash(bytes calldata _message) external view returns (bytes32);
    function signedMessages(bytes32 _message) external view returns (uint256);
    function approveHash(bytes32 hashToApprove) external;
}