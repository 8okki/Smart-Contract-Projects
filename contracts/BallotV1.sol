// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

contract Ballot {

    struct Voter {
        bool voted;
        uint weight;
        uint vote;
    }
    struct Proposal {
        string name;
        uint voteCount;
    }
    enum Stage {Init, Register, Vote, Done}

    Proposal[] proposals;
    mapping(address => Voter) voters;
    address chairperson;
    uint creationTime;
    Stage currentStage = Stage.Init;

    modifier validStage(Stage requiredStage) {
        require(currentStage == requiredStage);
        _;
    }
    modifier validVote(uint proposal) {
        require(proposal < proposals.length);
        _;
    }

    event registerCompleted();
    event votingCompleted();

    constructor(string[] memory proposalNames) validStage(Stage.Init) {
        chairperson = msg.sender;
        voters[chairperson].weight = 2;
        for (uint i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({
                    name: proposalNames[i],
                    voteCount: 0
            }));
        }
        currentStage = Stage.Register;
        creationTime = block.timestamp;
    }

    function register(address voter) external payable validStage(Stage.Register) {
        require(msg.sender == chairperson); // Only chairperson can register voters.
        Voter storage voterInfo = voters[voter];
        require(!voterInfo.voted); // Ensure voter is not already registered.
        voterInfo.weight = 1; // Assign weight of 1 to each voter.

        if (block.timestamp > creationTime + 30 seconds) {
            currentStage = Stage.Vote;
            emit registerCompleted();
        }
    }

    function vote(uint proposal) external payable validStage(Stage.Vote) validVote(proposal) {
        Voter storage voter = voters[msg.sender];
        require(!voter.voted && voter.weight > 0); // Ensure that the voter is valid and he hasn't vote yet
        proposals[proposal].voteCount += voter.weight;
        voter.voted = true;
        voter.vote = proposal;

        if (block.timestamp > creationTime + 60 seconds) {
            currentStage = Stage.Done;
            emit votingCompleted();
        }
    }

    function winningProposal() public view validStage(Stage.Done) returns (uint winningProposal_) {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
        require(winningVoteCount > 0);
        assert(winningProposal_ >= 0);
        return winningProposal_;
    }
}