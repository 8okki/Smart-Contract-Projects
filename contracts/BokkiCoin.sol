// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.8.0 < 0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BokkiCoin is ERC20 {
    
    constructor() ERC20("Bokki Coin", "BkC") {
        // Mint 1M coin to the creator for initial total supply
        _mint(_msgSender(), 1000000);
    }

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }

}