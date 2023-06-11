// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IDAOstack {
    
    function createProposal(
        address _avatar,
        uint256 _reputationChange,
        address _beneficiary,
        uint256 _tokens,
        bytes32 _proposalDescription
    ) external returns (bytes32);

    function vote(bytes32 _proposalId, uint256 _vote, uint256 _reputation) external returns (uint256);

    function executeProposal(
        bytes32 _proposalId,
        uint256 _reputationChange,
        address _beneficiary,
        uint256 _tokens
    ) external returns (bool);

    function getProposalInfo(bytes32 _proposalId) external view returns (address, uint256, address, uint256, uint256);

    function getVote(bytes32 _proposalId, address _voter) external view returns (uint256, uint256*);
}