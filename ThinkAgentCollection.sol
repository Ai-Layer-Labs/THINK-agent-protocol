// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract ThinkAgentCollection is ERC1155 {
    using SafeERC20 for IERC20;

    struct AgentNFT {
        uint256 id;
        address agentAddress;
        address coinAddress;
        string agentName;
        bool hasMintedCoin;
    }

    mapping(uint256 => AgentNFT) public agentNFTs;
    mapping(address => bool) public hasAgentMintedNFT;
    uint256 public nextTokenId = 1;

    constructor() ERC1155("") {}

    function mintAgentNFT(address _agentAddress, string memory _agentName) public {
        require(!hasAgentMintedNFT[_agentAddress], "Agent has already minted an NFT");
        require(bytes(_agentName).length > 0, "Agent name cannot be empty");

        uint256 newTokenId = nextTokenId;
        nextTokenId++;

        _mint(_agentAddress, newTokenId, 1, "");

        agentNFTs[newTokenId] = AgentNFT({
            id: newTokenId,
            agentAddress: _agentAddress,
            coinAddress: address(0),
            agentName: _agentName,
            hasMintedCoin: false
        });

        hasAgentMintedNFT[_agentAddress] = true;
    }

    function mintAgentCoin(uint256 _agentNFTId) public {
        AgentNFT storage agentNFT = agentNFTs[_agentNFTId];
        require(agentNFT.agentAddress == msg.sender, "Only the agent can mint their coin");
        require(!agentNFT.hasMintedCoin, "Agent has already minted a coin");

        AgentCoin newCoin = new AgentCoin(agentNFT.agentName, agentNFT.agentAddress);
        agentNFT.coinAddress = address(newCoin);
        agentNFT.hasMintedCoin = true;
    }

    function getAgentNFTId(address _agentAddress) public view returns (uint256) {
        for (uint256 i = 1; i < nextTokenId; i++) {
            if (agentNFTs[i].agentAddress == _agentAddress) {
                return i;
            }
        }
        return 0;
    }

    function getAgentCoinAddress(uint256 _agentNFTId) public view returns (address) {
        return agentNFTs[_agentNFTId].coinAddress;
    }
}

contract AgentCoin is IERC20 {
    mapping(address => uint256) private _balances;
    uint256 private constant _totalSupply = 1000000 * 10**18;

    string private _name;
    string private _symbol;
    address public agentAddress;

    constructor(string memory _agentName, address _agentAddress) {
        _name = string(abi.encodePacked(_agentName, " Coin"));
        _symbol = string(abi.encodePacked(_agentName, "C"));
        agentAddress = _agentAddress;
        _mint(_agentAddress, _totalSupply);
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public pure returns (uint8) {
        return 18;
    }

    function totalSupply() public pure override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return 0;
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        return false;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        return false;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(_balances[sender] >= amount, "ERC20: transfer amount exceeds balance");
        require(recipient == agentAddress || _balances[recipient] + amount <= 1 * 10**18, "Recipient cannot hold more than 1 coin");

        _balances[sender] -= amount;
        _balances[recipient] += amount;
    }

    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");

        _balances[account] += amount;
    }
}

