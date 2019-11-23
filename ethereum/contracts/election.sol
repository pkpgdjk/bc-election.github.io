pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;
contract VoteFactory {
    struct Votes {
        string name;
        string desc;
        bytes32[] candidate;
        address addr;
        address manager;
    }
    Votes[] public all_vote; //เก็บข้อมูลทั้งหมดของ VOTE
   
    function createVote(string namevote, string description,bytes32[] candidate) public {
        address newVote = new Vote(namevote, description, candidate, msg.sender);
        all_vote.push(Votes({
             name:namevote,
            desc:description,
            candidate:candidate,
            manager:msg.sender,
            addr:newVote
        }));
        deployedVotes.push(newVote);
    }
    function getDeployedVotes() public view returns (Votes[]) {
        return all_vote;
    }
}
 
contract Vote {
    struct Candidate {
        bytes32 candidate_name;
        uint candidate_score;
    }
    Candidate[] public candidate_list;
    address public manager;
    mapping (address => bool) public elector;
    string public namevote;
    string public description;
    bool public complete;
   
    modifier restricted(){
        require(msg.sender == manager);
        _;
    }
   
    constructor (string name, string desc, bytes32[] cand,address creator) public {
        namevote = name;
        description = desc;
        manager = creator;
        complete = false;
        uint index=cand.length;
        for(uint i=0;i<index;i++){
                Candidate memory newcandidate = Candidate({
                candidate_name : cand[i],
                candidate_score : 0
            });
            candidate_list.push(newcandidate);
        }
    }
   
    // function setCandidate(bytes32[] cand) public restricted {
    //     uint index=cand.length;
    //     for(uint i=0;i<index;i++){
    //         createCandidate(cand[i]);
    //     }
    // }
   
    // function createCandidate(bytes32 name) public restricted {
    //     Candidate memory newcandidate = Candidate({
    //         candidate_name : name,
    //         candidate_score : 0
    //     });
    //     candidate_list.push(newcandidate);
    // }
   
    function vote_candidate(uint index) public {
        Candidate storage candidate = candidate_list[index];
        require(complete == false);
        require(elector[msg.sender] == false);
        elector[msg.sender] = true;
        candidate.candidate_score++;        
    }
   
    function close_vote() public restricted {
        require(!complete);
        complete = true;
    }
   
    function getScore(uint index) public view returns (uint) {
        Candidate storage candidate = candidate_list[index];
        return candidate.candidate_score;
    }
   
    function getCandidate() public view returns (Candidate[]) {
        return candidate_list;
    }
}