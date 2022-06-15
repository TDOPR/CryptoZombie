// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./zombieAttack.sol";
import "./zombieMarket.sol";
import "./zombieFeeding.sol";

contract ZombieCore is ZombieMarket, ZombieFeeding, ZombieAttack {
    string public constant name = "MyCryptoZombie";
    string public constant symbol = "MCZ";

    function() external payable {}

    function withdraw() external onlyOwner {
        owner.transfer(address(this).balance);
    }

    function checkBalance() external view onlyOwner returns (uint256) {
        return address(this).balance;
    }
}
