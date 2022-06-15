// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Ownable.sol";
import "./SafeMath.sol";

contract ZombieFactory is Ownable {
    using SafeMath for uint256;

    uint256 dnaDigits = 16;
    uint256 dnaModules = 10**dnaDigits;
    uint256 public cooldownTime = 1 days;
    uint256 public zombiePrice = 0.01 ether;
    uint256 public zombieCount = 0;

    struct Zombie {
        string name;
        uint256 dna;
        uint16 winCount;
        uint16 lossCount;
        uint32 level;
        uint32 readyTime;
    }

    Zombie[] public zombies;

    mapping(uint256 => address) public zombieToOwner;
    mapping(address => uint256) ownerZombieCount;
    mapping(uint256 => uint256) public zombieFeedTimes;

    event NewZombie(uint256 id, string name, uint256 dna);

    function _generateRandDna(string memory _str)
        private
        view
        returns (uint256)
    {
        return
            uint256(keccak256(abi.encodePacked(_str, block.timestamp))) %
            dnaModules;
    }

    function _creatZombie(string memory _name, uint256 _dna) internal {
        zombies.push(Zombie(_name, _dna, 0, 0, 1, 0));
        uint256 id = zombies.length - 1;
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender] = ownerZombieCount[msg.sender].add(1);
        zombieCount = zombieCount.add(1);

        emit NewZombie(id, _name, randDna);
    }

    function creatZombie(string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0);
        uint256 randDna = _generateRandDna(_name);
        randDna = randDna - (randDna % 10);
        _creatZombie(_name, randDna);
    }

    function buyZombie(string memory _name) public payable {
        require(ownerZombieCount[msg.sender] > 0);
        require(msg.value >= zombiePrice);
        uint256 randDna = _generateRandDna(_name);
        randDna = randDna - (randDna % 10) + 1;
        _creatZombie(_name, randDna);
    }

    function setZombiePrice(uint256 _price) external onlyOwner {
        zombiePrice = _price;
    }
}
