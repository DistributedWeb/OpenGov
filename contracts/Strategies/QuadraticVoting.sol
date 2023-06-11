// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract QuadraticVoting {
    
    struct Proposal {
        address proposer;
        uint256 endTime;
        string description;
        uint256 yesVotes;
        uint256 noVotes;
        bool executed;
        mapping(address => uint256) votes;
    }

    uint256 public nextProposalId;
    uint256 public constant VOTING_PERIOD = 7 days;
    
    mapping(uint256 => Proposal) public proposals;
    mapping(address => uint256) public user_tokens;

    event ProposalCreated(uint256 proposalId, address indexed proposer, string description);
    event Voted(address indexed user, uint256 indexed proposalId, bool support, uint256 sqrtTokens);

    function createProposal(string memory _description) external {
        Proposal storage newProposal = proposals[nextProposalId];
        newProposal.proposer = msg.sender;
        newProposal.endTime = block.timestamp + VOTING_PERIOD;
        newProposal.description = _description;

        emit ProposalCreated(nextProposalId, msg.sender, _description);
        nextProposalId++;
    }

    function vote(uint256 _proposalId, bool _support) external {
        Proposal storage proposal = proposals[_proposalId];
        
        require(block.timestamp < proposal.endTime, "Voting period has ended");
        require(proposal.votes[msg.sender] == 0, "User has already voted");

        uint256 sqrtTokens = _sqrt(user_tokens[msg.sender]);

        if (_support) {
            proposal.yesVotes += sqrtTokens;
        } else {
            proposal.noVotes += sqrtTokens;
        }

        proposal.votes[msg.sender] = sqrtTokens;

        emit Voted(msg.sender, _proposalId, _support, sqrtTokens);
    }

    function _sqrt(uint256 x) private pure returns(uint256) {
        if (x == 0) return 0;
        uint256 z = (x + 1) / 2;
        uint256 y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
        return y;
    }
}