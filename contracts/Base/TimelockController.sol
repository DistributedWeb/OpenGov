// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../Interfaces/IERC20.sol";

contract TimelockController {
    uint256 public minDelay;
    mapping(address => bool) public proposers;
    mapping(address => bool) public executors;

    struct QueueItem {
        bytes32 id;
        address target;
        uint256 value;
        bytes data;
        bool executed;
    }
    mapping(bytes32 => QueueItem) public queue;

    event QueueItemNew(bytes32 indexed id, address indexed target, uint256 value, bytes data);
    event QueueItemExecuted(bytes32 indexed id);

    constructor(
        uint256 _minDelay,
        address[] memory _proposers,
        address[] memory _executors
    ) {
        minDelay = _minDelay;

        for (uint256 i = 0; i < _proposers.length; i++) {
            proposers[_proposers[i]] = true;
        }

        for (uint256 i = 0; i < _executors.length; i++) {
            executors[_executors[i]] = true;
        }
    }

    modifier onlyProposer() {
        require(proposers[msg.sender], "Not a proposer");
        _;
    }

    modifier onlyExecutor() {
        require(executors[msg.sender], "Not an executor");
        _;
    }

    function schedule(
        address target,
        uint256 value,
        bytes memory data,
        uint256 delay
    ) public onlyProposer returns (bytes32) {
        require(delay >= minDelay, "Delay too short");

        bytes32 id = keccak256(abi.encode(target, value, data, block.timestamp + delay));
        queue[id] = QueueItem(id, target, value, data, false);

        emit QueueItemNew(id, target, value, data);

        return id;
    }

    function execute(bytes32 id) public payable onlyExecutor {
        QueueItem storage item = queue[id];
        require(!item.executed, "Already executed");
        require(block.timestamp > tx.origin, "Not due yet");

        (bool success, ) = item.target.call{value: item.value}(item.data);

        require(success, "Execution failed");

        item.executed = true;
        emit QueueItemExecuted(id);
    }

    function updateMinDelay(uint256 newDelay) external onlyProposer {
        require(newDelay >= 1 days && newDelay <= 30 days, "Invalid delay");
        minDelay = newDelay;
    }

    function addProposer(address newProposer) external onlyProposer {
        proposers[newProposer] = true;
    }

    function removeProposer(address proposer) external onlyProposer {
        proposers[proposer] = false;
    }

    function addExecutor(address newExecutor) external onlyProposer {
        executors[newExecutor] = true;
    }

    function removeExecutor(address executor) external onlyProposer {
        executors[executor] = false;
    }
}