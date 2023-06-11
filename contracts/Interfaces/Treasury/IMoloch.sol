// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IMoloch {
    // Structs
    struct Proposal {
        address proposer; // the account that submitted the proposal
        address[] requestedTokens; // the tokens to send from the Treasury
        uint256[] requestedAmounts; // the amount of tokens to send
        address[] tokensToReceive; // the tokens to be received by the Treasury
        uint256[] minAmountsToReceive; // the amount of tokens to be received
        string details; // proposal details - could be IPFS hash, plaintext, or JSON
        uint256 votingStartTime;
        uint256 votingEndTime;
        bool processed;
        bool abort;
        uint256 yesVotes;
        uint256 noVotes;
    }

    // Events
    event SubmitProposal(
        uint256 indexed proposalId,
        address indexed proposer,
        address[] requestedTokens,
        uint256[] requestedAmounts,
        address[] tokensToReceive,
        uint256[] minAmountsToReceive,
        string details,
        uint256 votingStartTime,
        uint256 votingEndTime
    );
    event VoteProposal(
        uint256 indexed proposalId,
        address indexed voter,
        bool vote
    );
    event ProcessProposal(uint256 indexed proposalId);
    event AbortProposal(uint256 indexed proposalId);

    // Functions
    function submitProposal(
        address[] calldata requestedTokens,
        uint256[] calldata requestedAmounts,
        address[] calldata tokensToReceive,
        uint256[] calldata minAmountsToReceive,
        string calldata details,
        uint256 votingStartTime,
        uint256 votingEndTime
    ) external returns (uint256 proposalId);

    function voteProposal(uint256 proposalId, bool support) external;

    function processProposal(uint256 proposalId) external;

    function abortProposal(uint256 proposalId) external;

    function getProposal(uint256 proposalId) external view returns (Proposal memory);

    function totalProposals() external view returns (uint256);
}