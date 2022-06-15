// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract ZombieMarket is ZombieOwnership {
    uint public tax = 1 finney;
    uint public minPrice = 1 finney;

    struct zombieSales{
        address payable seller;
        uint price;
    }

    mapping(uint => zombieSales) public zombieShop;

    event SaleZombie(uint indexed zombieId, address indexed seller);
    event BuyShopZombie(uint index zombieId, address indexed buyer, address indexed seller);

    function saleMyZombie(uint _zombieId, uint _price) public onlyOwnerOf(_zombieId) {
        require(_price >= minPrice + tax);
        zombieShop[_zombieId] = zombieSales(msg.sender, _price);
        emit SaleZombie(_zombie, msg.sender);
    }

    function buyShopZombie(uint _zombieId) public payable {
        zombieSales memory _zombieSales = zombieShop[_zombieId];
        require(msg.value >= _zombieSales.price);
        _transfer(_zombieSales.seller, msg.sender, _zombieId);
        _zombieSales.seller.transfer(msg.value - tax);
        delete zombieShop[_zombieId];
        emit BuyShopZombie(_zombieId, msg.sender, _zombieSales.seller);
    }

    function setTax(uint _value) public onlyOwner {
        tax = _value;
    }

    function setMinPrice(uint _value) public onlyOwner {
        minPrice = _value
    }
}