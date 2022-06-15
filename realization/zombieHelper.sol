pragma solidity ^0.8.0;

import "./zombieFactory.sol";

contract zombieHelper is zombieFactory {
    uint256 levelUpFee = 0.001 ether;

    modifier aboveLevel(uint256 _level, uint256 _zombieId) {
        require(zombies[_zombieId].level >= _level);
        _;
    }

    modifier onlyOwnerOf(uint256 _zombieId) {
        require(msg.sender == zombies[_zombieId]);
        _;
    }

    function setLevelUpFee(uint256 _fee) external onlyOwnable {
        levelUpFee = _fee;
    }

    function levelUp(uint256 _zombieId) external payable {
        require(msg.value >= levelUpFee);
        zombies[_zombieId].level++;
    }

    function changeName(uint256 _zombieId, string calldata _newName)
        external
        aboveLevel(2, _zombieId)
        onlyOwnerOf(_zombieId)
    {
        zombies[_zombieId].name = _name;
    }

    function multiply(uint256 _zombieId, uint256 _dna)
        internal
        returns (uint256)
    {
        Zombie storage zombie = zombies[_zombieId];
        require(isReady(zombie));
        dna = _dna % dnaModules;
        uint256 newDna = (zombie.dna + dna) / 2;
        newDna = newDna - (newDna % 10) + 9;
        _creatZombie("noname", newDna);
        _triggerColldown(zombie);
        return zombies.length - 1;
    }

    function getZombieByOwner(address _owner)
        external
        view
        returns (uint256[])
    {
        uint256[] result = new uint256[](ownerZombieCount[_owner]);
        uint256 count = 0;
        for (uint256 i; i < zombieCount.length; i++) {
            if (zombieToOwner[i] == _owner) {
                result[count] = i;
                count++;
            }
        }
        return result;
    }

    function _triggerColldown(Zombie storage _zombie) internal {
        _zombie.readyTime =
            uint32(block.timestamp + colldownTime) -
            (uint32(block.timestamp + colldownTime) % 1 days);
    }

    function isReady(Zombie storage _zombie) internal view returns (bool) {
        return (_zombie.readyTime <= block.timestamp);
    }
}
