# OpenGov Governance System

OpenGov is a decentralized governance system built for Distributed Web-based applications that focuses on giving the community the power to control and manage applications and their related on-chain treasuries. OpenGov aims to provide an alternative to OpenZeppelin's governance contracts and is compatible with various treasury management platforms such as Gnosis Safe, Aragon, DAOstack, and Moloch DAO, so that decentralized apps can themselves become democracies.

## Features

- On-chain treasury management through integration with Gnosis Safe, Aragon, DAOstack, and Moloch DAO.
- Community-driven governance with a focus on fair decision-making and support for minority voices.
- DAO token for membership and voting.
- Proposal submission, voting, and execution.
- Integration with Compound Finance's COMP token.
- Support for quadratic voting.

## Contract Structure

### Interfaces

- `/contracts/Interfaces/IERC20.sol`: Interface for the basic ERC-20 token.
- `/contracts/Interfaces/IComp.sol`: Interface for the COMP token from Compound finance.
- `/contracts/Interfaces/Treasury/IGnosisSafe.sol`: Interface for interacting with Gnosis Safe.
- `/contracts/Interfaces/Treasury/IDAOstack.sol`: Interface for interacting with DAOstack.
- `/contracts/Interfaces/Treasury/IMoloch.sol`: Interface for interacting with Moloch DAO.

### Base Contracts

- `/contracts/Base/Governor.sol`: Main contract responsible for governance functionality.
- `/contracts/Base/TimelockController.sol`: Contract to allow delayed execution of governance decisions.
- `/contracts/Base/DAO_token.sol`: ERC-20 token contract for the DAO members.

### Extensions

- `/contracts/Extensions/ERC20Votes.sol`: Extends the DAO_Token with vote counting functionality.
- `/contracts/Extensions/ERC20VotesComp.sol`: Extends the ERC20Votes contract with compatibility for Compound's governance features.
- `/contracts/Extensions/ERC20Snapshot.sol`: Extension for DAO_TOKEN to allow taking token balance snapshots.

### Adapters

- `/contracts/Adapters/GnosisSafeAdapter.sol`: Contract for integrating OpenGov with Gnosis Safe.
- `/contracts/Adapters/DAOstackAdapter.sol`: Contract for integrating OpenGov with DAOstack.
- `/contracts/Adapters/MolochAdapter.sol`: Contract for integrating OpenGov with Moloch DAO.

### Deployment

- `/migrations`: Contains migration scripts necessary for deploying the contracts to the Polygon network.

## Usage

To integrate OpenGov into your project, you'll need to import the necessary contracts and interfaces as well as deploy the respective adapter contracts for the desired treasury management platforms.

1. Import the necessary governance contracts and adapter contracts into your project.
2. Deploy the DAO_token as well as the Governor and TimelockController contracts.
3. Deploy the respective adapter contracts (GnosisSafeAdapter, AragonAdapter, DAOstackAdapter, MolochAdapter) for the treasury management platforms you want to support.
4. Configure the Governor contract to interact with the deployed adapter contracts for each platform.
5. Users can now mint/buy the DAO_token and participate in governance by submitting proposals and voting on them.
6. Proposals can also interact with the treasury platforms via the adapter contracts, allowing for the management of the on-chain treasury.

Please remember to thoroughly test the implementation and the interactions with each of these platforms to ensure compatibility and proper functionality with OpenGov.


### Deploy On Polygon

```bash
npx hardhat deploy --network polygon
```