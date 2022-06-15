pragma solidity ^0.8.0;

import "./zombieHelper.sol";

contract ZombieFeeding is zombieHelper {
    function feed(uint256 _zombieId) public onlyOwnerOf(_zombieId) {
        Zombie storage myZombie = zombies[_zombieId];
        require(isReady(myZombie));
        zombieFeedTimes[_zombieId] = zombieFeedTimes[_zombieId].add(1);
        _triggerColldown(myZombie);
        if (zombieFeedTimes[_zombieId] % 10 == 0) {
            uint256 newDna = myZombie.dna - (myZombie.dna % 10) + 8;
            _creatZombie("zombie's son", newDna);
        }
    }
}
