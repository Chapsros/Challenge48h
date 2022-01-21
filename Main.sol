pragma solidity >=0.7.0 <0.9.0;

contract votingSystem{

    struct vote{
        address voterAddress;
        bool decision;
    }
    
    uint voteCount = 0;

    enum state{created,voting,ended}
    modifier inState(State _state) {
		    require(state == _state);
		    _;
	    }


}