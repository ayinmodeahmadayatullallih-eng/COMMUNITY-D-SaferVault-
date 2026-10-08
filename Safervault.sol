// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract SaferVault is ReentrancyGuard {
    mapping(address => uint256) public balances;
    uint256 public totalDeposited;

    function deposit() external payable {
        require(msg.value > 0, "Must send ETH");
        balances[msg.sender] += msg.value;
        totalDeposited += msg.value;
    }

    function withdraw() external nonReentrant {
        uint256 bal = balances[msg.sender];
        require(bal > 0, "No balance");
        balances[msg.sender] = 0;
        totalDeposited -= bal;
        (bool success, ) = msg.sender.call{value: bal}("");
        require(success, "Withdraw failed");
    }

    function getBalance() external view returns (uint256) {
        return balances[msg.sender];
    }
}
