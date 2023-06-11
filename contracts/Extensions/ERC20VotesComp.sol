pragma solidity ^0.8.0;

import "../Interfaces/IERC20.sol";
import "../Interfaces/IComp.sol";
import "./ERC20Votes.sol";

contract ERC20VotesComp is ERC20Votes, IComp {
    mapping(address => address) private _delegates;
    uint256 public totalDelegates;

    event DelegateChanged(
        address indexed delegator,
        address indexed fromDelegate,
        address indexed toDelegate
    );

    function delegates(address delegator) external view override returns (address) {
        return _delegates[delegator] == address(0) ? delegator : _delegates[delegator];
    }

    function delegate(address delegatee) external override {
        return _delegate(msg.sender, delegatee);
    }

    function delegateBySig(
        address delegatee,
        uint256 nonce,
        uint256 expiry,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external override {
        bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
        bytes32 digest = keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, structHash));
        address signatory = ecrecover(digest, v, r, s);
        require(signatory != address(0), "ERC20VotesComp::delegateBySig: invalid signature");
        require(nonce == nonces[signatory]++, "ERC20VotesComp::delegateBySig: invalid nonce");
        require(block.timestamp <= expiry, "ERC20VotesComp::delegateBySig: signature expired");
        _delegate(signatory, delegatee);
    }

    function getCurrentVotes(address account) external view override returns (uint256) {
        uint256 currentBlock = block.number;
        return _getPriorVotes(account, currentBlock);
    }

    function getPriorVotes(address account, uint256 blockNumber) external view override returns (uint256) {
        require(blockNumber < block.number, "ERC20VotesComp::getPriorVotes: not yet determined");
        return _getPriorVotes(account, blockNumber);
    }

    function _delegate(address delegator, address delegatee) internal {
        address currentDelegate = _delegates[delegator];
        uint256 delegatorBalance = balanceOf(delegator);
        _delegates[delegator] = delegatee;

        emit DelegateChanged(delegator, currentDelegate, delegatee);

        if (currentDelegate != address(0)) {
            _moveDelegates(currentDelegate, delegatee, delegatorBalance);
        }
    }

    function _moveDelegates(
        address srcRep,
        address dstRep,
        uint256 amount
    ) internal {
        if (srcRep != dstRep && amount > 0) {
            if (srcRep != address(0)) {
                _addSnapshot(srcRep, -int256(amount));
            }
            if (dstRep != address(0)) {
                _addSnapshot(dstRep, int256(amount));
            }
        }
    }
}