// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Escrow {

    address private arbiter;
    address private buyer;
    address private seller;

    uint private targetAmount;
    bool private isFunded;
    bool private isReleased;
    uint private fee;

    enum Stage {Init, Funded, Released, Completed, Canceled}

    modifier isSeller() {}
    modifier isBuyer() {}
    modifier checkStage(Stage _requiredStage) {}

    /**
    * @param _seller Address of the seller account that offers item to the buyer
    * @param _buyer Address of the buyer account that deposit to this contract
    * @param _targetAmount Amount that needs to be deposited by the buyer
    * @param _fee Amount of fee that goes to the arbiter (Owner of the escrow)
    */
    constructor(address _seller, address _buyer, uint _targetAmount, uint _fee) {

    }

    function deposit() public isBuyer checkStage {
    }

    function confirmDelivery() public isBuyer checkStage {
    }

    function refundBuyer() public isArbiter checkStage {
    }

    function releaseToSeller() public isArbiter checkStage {
    }

    function getBalance() public view return (uint balance_) {
    }

    function getTargetAmount() public view return (uint targetAmount_) {
    }
}