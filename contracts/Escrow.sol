// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 < 0.9.0;

contract Escrow {

    address private arbiter;
    address private buyer;
    address private seller;
    uint public targetAmount;

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
    modifier checkFund() {
        require(address(this).balance >= targetAmount);
        _;
    }

    /**
    * @param _seller Address of the seller account that offers item to the buyer
    * @param _buyer Address of the buyer account that deposit to this contract
    * @param _targetAmount Amount that needs to be deposited by the buyer
    */
    constructor(address _seller, address _buyer, uint _targetAmount) {
        require(msg.sender != _seller && msg.sender != _buyer && _targetAmount > 0);
        arbiter = msg.sender;
        seller = _seller;
        buyer = _buyer;
        targetAmount = _targetAmount;
        currentStage = Stage.Init;
    }

    function deposit() public payable isBuyer checkStage(Stage.Init) {
        require(msg.value == targetAmount, "Value doesn't match required amount");
        currentStage = Stage.Funded;
    }

    function confirmDelivery() public isBuyer checkStage(Stage.Funded) {
        sendValue(seller, "Releasing escrow to the seller");
        currentStage = Stage.Released;
    }

    function refundBuyer() public isArbiter checkStage(Stage.Funded) {
        sendValue(buyer, "Refunding escrow back to the buyer");
        currentStage = Stage.Canceled;
    }

    function releaseToSeller() public isArbiter checkStage(Stage.Funded) {
        sendValue(seller, "Manually releasing escrow to the seller");
        currentStage = Stage.Released;
    }

    function getBalance() public view returns (uint balance_) {
        return address(this).balance;
    }

    function sendValue(address recipient, bytes memory message) private checkFund {
        (bool success, ) = recipient.call{value: targetAmount}(message);
        require(success, "Transfer failed");
    }
}