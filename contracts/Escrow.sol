// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 < 0.9.0;

contract Escrow {

    address private arbiter;
    address private buyer;
    address private seller;

    uint public targetAmount;
    bool private isFunded;
    bool private isReleased;

    enum Stage {Init, Funded, Released, Canceled}
    Stage public currentStage;

    modifier isArbiter() {
        require(msg.sender == arbiter);
        _;
    }
    modifier isSeller() {
        require(msg.sender == seller);
        _;
    }
    modifier isBuyer() {
        require(msg.sender == buyer);
        _;
    }
    modifier checkStage(Stage _requiredStage) {
        require(currentStage == _requiredStage);
        _;
    }

    /**
    * @param _seller Address of the seller account that offers item to the buyer
    * @param _buyer Address of the buyer account that deposit to this contract
    * @param _targetAmount Amount that needs to be deposited by the buyer
    */
    constructor(address _seller, address _buyer, uint _targetAmount) {
        arbiter = msg.sender;
        seller = _seller;
        buyer = _buyer;
        targetAmount = _targetAmount;
        currentStage = Stage.Init;
    }

    function deposit() public isBuyer checkStage(Stage.Init) {
    }

    function confirmDelivery() public isBuyer checkStage(Stage.Funded) {
    }

    function refundBuyer() public isArbiter checkStage(Stage.Funded) {
    }

    function releaseToSeller() public isArbiter checkStage(Stage.Funded) {
    }

    function getBalance() public view returns (uint balance_) {
    }
}