pragma solidity ^0.8.0;

import "../Interfaces/Treasury/IDAOstack.sol";
import "../Base/Governor.sol";

contract DAOstackAdapter {
    IDAOstack public daostack;
    Governor public governor;

    event ProposalCreated(bytes32 indexed proposalId);

    constructor(address _daostack, address _governor) public {
        daostack = IDAOstack(_daostack);
        governor = Governor(_governor);
    }

    function submitProposal(
        string memory _description,
        uint256 _votesNeededToPass
    ) external {
        bytes32 proposalId = governor.createProposal(msg.sender, _description, _votesNeededToPass);
        daostack.submitProposal(_description);
        emit ProposalCreated(proposalId);
    }

    function vote(bytes32 _proposalId, bool _approve) external {
        require(governor.vote(msg.sender, _proposalId, _approve), "Invalid proposalId, or already voted");
        daostack.voteProposal(_proposalId, _approve);
    }

    function executeProposal(bytes32 _proposalId) external {
        bool passed = governor.executeProposal(_proposalId);
        if (passed) {
            address[] memory addresses;
            uint256[] memory amounts;
            (addresses, amounts) = governor.getProposalPayoutInfo(_proposalId);
            for (uint256 i = 0; i < addresses.length; i++) {
                if (amounts[i] > 0) {
                    daostack.withdrawFundsTo(addresses[i], amounts[i]);
                }
            }
        }
    }
}