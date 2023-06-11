// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../Interfaces/IERC20.sol";
import "../Interfaces/Treasury/IGnosisSafe.sol";
import "../Interfaces/Treasury/IDAOstack.sol";
import "../Interfaces/Treasury/IMoloch.sol";
import "../Adapters/GnosisSafeAdapter.sol";
import "../Adapters/DAOstackAdapter.sol";
import "../Adapters/MolochAdapter.sol";

contract Governor {
    IERC20 public daoToken;
    uint256 public proposalCount;

    enum TreasuryPlatform { GnosisSafe, DAOstack, Moloch }
    TreasuryPlatform public activeTreasuryPlatform;
    address public treasury;

    struct Proposal {
        address proposer;
        string description;
        address[] actions;
        uint256[] amounts;
        uint256 totalVotes;
        mapping(address => uint256) votes;
    }

    mapping(uint256 => Proposal) public proposals;

    constructor(address _daoToken) {
        daoToken = IERC20(_daoToken);
    }

    // Setters
    function setTreasuryPlatform(TreasuryPlatform _platform) external {
        activeTreasuryPlatform = _platform;
    }

    function setTreasury(address _treasury) external {
        treasury = _treasury;
    }

    // Governance functions
    function submitProposal(
        string calldata _description,
        address[] calldata _actions,
        uint256[] calldata _amounts
    ) external {
        require(_actions.length == _amounts.length, "Governor: actions and amounts must have the same length");

        proposalCount += 1;
        Proposal storage newProposal = proposals[proposalCount];
        newProposal.proposer = msg.sender;
        newProposal.description = _description;
        newProposal.actions = _actions;
        newProposal.amounts = _amounts;

        // Emit ProposalCreated event
    }

    function vote(uint256 _proposalId, uint256 _votes) external {
        require(_votes > 0, "Governor: must vote with a positive amount of tokens");

        Proposal storage proposal = proposals[_proposalId];
        proposal.totalVotes += _votes;
        proposal.votes[msg.sender] += _votes;

        daoToken.transferFrom(msg.sender, treasury, _votes);

        // Emit VoteCasted event
    }

    function executeProposal(uint256 _proposalId) external {
        Proposal storage proposal = proposals[_proposalId];

        // Add custom validation logic if needed, such as quorum or timelock

        for (uint256 i = 0; i < proposal.actions.length; i++) {
            address action = proposal.actions[i];
            uint256 amount = proposal.amounts[i];

            if (activeTreasuryPlatform == TreasuryPlatform.GnosisSafe) {
                GnosisSafeAdapter(treasury).executeTransaction(action, amount);
            } else if (activeTreasuryPlatform == TreasuryPlatform.Aragon) {
                AragonAdapter(treasury).executeTransaction(action, amount);
            } else if (activeTreasuryPlatform == TreasuryPlatform.DAOstack) {
                DAOstackAdapter(treasury).executeTransaction(action, amount);
            } else if (activeTreasuryPlatform == TreasuryPlatform.Moloch) {
                MolochAdapter(treasury).executeTransaction(action, amount);
            }
        }

        // Emit ProposalExecuted event
    }
}