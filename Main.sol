pragma solidity >=0.7.0 <0.9.0;

contract votingSystem{
    //le tableau bord
    struct vote{
        address voterAddress; //l'adresse de la personne qui vote 
        string choice;//la reponse qu'il a choisi
    }
    //la personne qui vote
    struct voter{
        string voterName; //nom de la personne qui vote
        bool voted; //est ce qu'il a deja voté ?
    }

    //compteurs vote par personnes
    uint public countChar1 = 0;
    uint public countChar2 = 0;
    uint public countChar3 = 0;

    uint private countResult = 0;
    uint public finalResult = 0;

    uint public totalVoter = 0;
    uint public totalVote = 0;
    address public ownerOfficialAddress;      
    string public ownerOfficialName;
    string[3] public proposal; //question de base
    
    mapping(uint => vote) private votes;
    mapping(address => voter) public voterRegister;
    
    enum State { Created, Voting, Ended }
	State public state;
	
	//creates a new owner contract
	constructor(
        string memory _ownerOfficialName,
        string memory _proposal1,
        string memory _proposal2,
        string memory _proposal3) public {
        ownerOfficialAddress = msg.sender;
        ownerOfficialName = _ownerOfficialName;
        proposal[0] = _proposal1;
        proposal[1] = _proposal2;
        proposal[2] = _proposal3;
        
        state = State.Created;
    }

	modifier onlyOfficial() {
		require(msg.sender == ownerOfficialAddress);
		_;
	}

	modifier inState(State _state) {
		require(state == _state);
		_;
	}

    event voterAdded(address voter);
    event voteStarted();
    event voteEnded(uint finalResult);
    event voteDone(address voter);
    
    //add voter
    function addVoter(address _voterAddress, string memory _voterName)
        public
        inState(State.Created)
        onlyOfficial
    {
        voter memory v;
        v.voterName = _voterName;
        v.voted = false;
        voterRegister[_voterAddress] = v;
        totalVoter++;
        emit voterAdded(_voterAddress);
    }

    //declare voting starts now
    function startVote()
        public
        inState(State.Created)
        onlyOfficial
    {
        state = State.Voting;     
        emit voteStarted();
    }

    //voters vote by indicating their choice 
    function doVote(string memory _choice)
        public
        inState(State.Voting)
        returns (bool voted)
    {
        bool found = false;
        
        if (bytes(voterRegister[msg.sender].voterName).length != 0 
        && !voterRegister[msg.sender].voted){
            voterRegister[msg.sender].voted = true;
            vote memory v;
            v.voterAddress = msg.sender;
            v.choice = _choice;

            //different checks
            if(_choice == "1"){
                countChar1++;
            }
            else if(_choice == "2"){
                countChar2++;
            }
            else if(_choice == "3"){
                countChar3++;
            }
            countResult++;

            votes[totalVote] = v;
            totalVote++;
            found = true;
        }
        emit voteDone(msg.sender);
        return found;
    }
    
    //end votes
    function endVote()
        public
        inState(State.Voting)
        onlyOfficial
    {
        state = State.Ended;
        emit voteEnded(countResult);
    }
}