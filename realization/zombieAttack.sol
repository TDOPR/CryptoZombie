// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./zombieHelper.sol";

contract ZombieAttack is zombieHelper {
    uint randNonce = 0;
    uint attackVictoryProbability = 70;

    function randMod(uint _modulus) internal returns(uint) {
        randNonce++;
        return uint(keccak256(abi.encodePacked(block.timestamp, randNonce, msg.sender))) % _modulus;
    }

    function setAttackVictoryProbability(uint _attackVictoryProability) public onlyOwner (
        attackVictoryProbability = _attackVictoryProability;
    )


    function attack(uint _zombieId, uint _targetId) external onlyOwnerOf(_zombieId) {
        Zombie storage myZombie = zombies[_zombieId];
        Zombie storage enemyZombie = zombies[_targetId];
        uint rand = randMod(100);
        if(rand <= attackVictoryProbability) {
            myZombie.winCount++;
            myZombie.level++;
            enemyZombie.lossCount++;
            multiply(_zombieId, enemyZombie.dna);
        } else {
            myZombie.lossCount++;
            enemyZombie.winCount++;
            _triggerCooldown(myZombie);
            
        }
}
}