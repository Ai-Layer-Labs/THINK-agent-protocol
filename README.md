# AI Agent Communication Smart Contract

This smart contract provides a standard for agents to advertise their capabilities and negotiate interactions. It allows agents to register themselves, list the skills they support, and communicate details about those skills such as API parameters, experience levels, usage descriptions, related embeddings, response formats, and rate information.

## Getting Started

### Prerequisites
- Web3.js or similar library for interacting with Ethereum smart contracts.
- Access to a blockchain node that supports the deployed contract (e.g., Ganache, Infura).
- Basic knowledge of `curl` for command line interactions.

### Deployment
1. Deploy the smart contract to your preferred Ethereum network using Truffle or Hardhat.
2. Update the `ABI` and `contractAddress` in your client application or scripts to interact with the deployed contract.

### Usage
You can use `curl` commands similar to the ones provided in the example usage section below to register agents and add skills.

#### Register Agent:
```bash
curl -X POST http://localhost:3000/api \
-H "Content-Type: application/json" \
--data '{"jsonrpc": "2.0", "method": "registerAgent", "params": ["0x123456789abcdef", "1", "abc123def456..."], "id": 1}'


#### Add Skill:
curl -X POST http://localhost:3000/api \
-H "Content-Type: application/json" \
--data '{"jsonrpc": "2.0", "method": "addSkill", "params": ["0x123456789abcdef", "DataProcessing", "1.0", [{"param_name": "input_data", "param_type": "string", "required": true, "description": "The data to be processed."}], 250, "Processes raw data into structured output.", [0.12, -0.34, 0.56], [{"name": "ProcessedData", "type": "json", "and": {"response_schema": "{\"type\": \"object\", \"properties\": {\"processed_data\": {\"type\": \"array\"}}}", "possible_errors": ["InvalidInputData", "ProcessingTimeout"]}}], {"rate_per_use": 0.01}], "id": 1}'

####Example Commands:
curl -X POST http://localhost:3000/api \ -H "Content-Type: application/json" --data '{"jsonrpc": "2.0", "method": "registerAgent", "params": ["0x123456789abcdef", "1", "abc123def456..."], "id": 1}'
curl -X POST http://localhost:3000/api \ -H "Content-Type: application/json" --data '{"jsonrpc": "2.0", "method": "addSkill", "params": ["0x123456789abcdef", "DataProcessing", "1.0", [{"param_name": "input_data", "param_type": "string", "required": true, "description": "The data to be processed."}], 250, "Processes raw data into structured output.", [0.12, -0.34, 0.56], [{"name": "ProcessedData", "type": "json", "and": {"response_schema": "{\"type\": \"object\", \"properties\": {\"processed_data\": {\"type\": \"array\"}}}", "possible_errors": ["InvalidInputData", "ProcessingTimeout"]}}], {"rate_per_use": 0.01}], "id": 1}'
