// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../Interfaces/Treasury/IGnosisSafe.sol";
import "../Base/Governor.sol";

contract GnosisSafeAdapter {

    IGnosisSafe public gnosisSafe;
    Governor public openGovGovernor;

    constructor(address _gnosisSafeAddress, address _openGovGovernorAddress) {
        require(_gnosisSafeAddress != address(0), "Invalid Gnosis Safe address");
        require(_openGovGovernorAddress != address(0), "Invalid OpenGov Governor address");

        gnosisSafe = IGnosisSafe(_gnosisSafeAddress);
        openGovGovernor = Governor(_openGovGovernorAddress);
    }

    modifier onlySafeOwners() {
        require(gnosisSafe.isOwner(msg.sender), "Only Gnosis Safe owners allowed");
        _;
    }

    function setGnosisSafeAddress(address _gnosisSafeAddress) public onlySafeOwners {
        require(_gnosisSafeAddress != address(0), "Invalid Gnosis Safe address");
        gnosisSafe = IGnosisSafe(_gnosisSafeAddress);
    }

    function setOpenGovGovernorAddress(address _openGovGovernorAddress) public onlySafeOwners {
        require(_openGovGovernorAddress != address(0), "Invalid OpenGov Governor address");
        openGovGovernor = Governor(_openGovGovernorAddress);
    }

    function submitProposal(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        string memory description
    ) public onlySafeOwners returns (uint256) {
        return openGovGovernor.propose(targets, values, calldatas, description);
    }

    function castVote(uint256 proposalId, uint8 support) public onlySafeOwners {
        openGovGovernor.vote(msg.sender, proposalId, support);
    }

    function execute(uint256 proposalId) public onlySafeOwners {
        openGovGovernor.execute(proposalId);
    }
}