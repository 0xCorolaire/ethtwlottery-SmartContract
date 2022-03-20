// SPDX-License-Identifier: MIT
pragma solidity >=0.6.6 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";

/*
⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄..........⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄.⠄⠄
⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄Slay⠄⠄⠄⠄⠄⠄.⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⣀⣤⣶⣿⣿⣿⣷⣶⣄⣀⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⢠⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⢀⠠⠤⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡀⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⢀⡔⠄⠄⣀⣴⣶⣶⣬⣻⣿⣿⣿⢿⣿⣿⣿⣿⣿⣇⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⡰⠄⠄⠄⢸⣿⠉⠁⠄⠙⣿⣿⣿⣿⣿⣿⠁⠄⠈⢹⣿⡀⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⢀⠄⠄⠄⠄⣸⣿⣀⠄⢀⣠⣿⠟⠁⠹⢿⣿⣀⣀⣠⣼⣿⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⢀⠃⠄⠄⠄⠚⠁⠈⠛⠛⢛⡛⣵⣤⣤⣤⣾⣿⠿⠛⢻⣿⣿⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⡈⠄⠄⠄⠄⠆⠑⣶⣴⠂⢁⣀⠄⠈⠉⠉⠄⢠⡤⢀⣾⣿⠏⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
⠄⠄⠄⠄⠄⠄⠄⠄⠄⠰⠄⠄⠄⠄⢸⠄⠄⠘⣿⣦⣸⣿⡶⠷⡶⡾⠾⣿⡿⠛⣿⠿⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
⠄⠄⠄⠄⠄⠄⠄⠄⢀⠆⠄⠄⠄⠄⡇⠄⠄⠄⠈⠹⣶⡉⠃⠄⠄⠄⠄⢉⣴⡞⠃⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
⠄⠄⠄⠄⠄⠄⠄⠄⠌⠄⠄⠄⠄⢐⠃⠄⠄⠄⠄⠄⢸⣿⣿⣆⣀⣀⣸⣿⣿⠁⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
⠄⠄⠄⠄⠄⠄⠄⢠⠄⠄⠄⠄⠄⢸⠄⠄⠄⠄⠄⠄⣸⣿⣿⣿⣿⣿⣿⣿⣿⡧⡀⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
⠄⠄⠄⠄⠄⠄⠄⠎⠄⠄⠄⠄⠄⠈⠄⠄⠄⣀⣶⠁⠇⠹⣿⣿⣿⣿⣿⣿⣿⡇⢠⣀⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
⠄⠄⠄⠄⠄⠄⠈⠄⠄⠄⠄⠄⠄⣄⣀⣶⣿⣿⡏⠄⠈⠓⢈⡛⠛⠛⠛⢋⠜⠄⣸⣿⣿⣦⣀⡀⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
⠄⠄⠄⠄⠄⢠⠃⠄⠄⠄⠄⠄⢠⣿⣿⣿⣿⣿⡇⠈⢀⠄⠊⡇⠄⠄⠰⠈⡀⠐⢹⣿⣿⣿⣿⣿⣷⣶⣄⡀⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
⠄⠄⠄⠄⠄⠆⠄⠄⠄⠄⠄⠄⣸⣿⣿⣿⣿⣿⣿⠄⠄⠋⠄⠈⠢⠊⠄⠄⠘⠃⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣀⠄⠄⠄⠄⠄⠄⠄
⠄⠄⠄⠄⢠⠄⠄⠄⠄⠄⠄⠄⣿⣿⣿⣿⣿⣿⣿⡆⠄⠄⠄⠄⢰⠄⠄⠄⠄⠄⠄⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⠄⠄⠄⠄⠄⠄
⠄⠄⠄⢀⠎⠄⠄⠄⠄⠄⠄⢰⣿⣿⣿⣿⣿⣿⣿⡇⠄⠄⠄⠄⢸⠄⠄⠄⠄⠄⠄⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠄⠄⠄⠄⠄⠄
⠄⠄⠄⠈⠄⠄⠄⠄⠄⠄⢠⣿⣿⣿⣿⣿⣿⣿⣿⡇⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠄⠄⠄⠄⠄⠄
*/

contract InteractLottery { 
  function enter(string calldata _username) public payable{}
}

contract MappedLottery is VRFConsumerBaseV2, Ownable {
    address vrfCoordinator = 0x6168499c0cFfCaCD319c818142124B7A15E857ab;
    address link = 0x01BE23585060835E02B77ef475b0Cc51aA1e0709;

    VRFCoordinatorV2Interface COORDINATOR;
    LinkTokenInterface LINKTOKEN;

    bytes32 keyHash = 0xd89b2bf150e3b9e13446986e571fb9cab24b13cea0a43ea20a6049a85cc807cc;
    uint64 _subscriptionId;

    struct Player {
        string username;
        bool exists;
    }

    mapping(uint256 => address) memberObserver;
    mapping(string => Player) usernameObserver;
    mapping(address => Player) members;
    uint256 public nbEntry = 0;

    Player public winner;
    
    uint256 public _requestId;

    enum LOTTERY_STATE {
        OPEN,
        CLOSED,
        CALCULATING_WINNER
    }

    LOTTERY_STATE public lottery_state;
    event RequestedRandomness(uint256 _requestId);

    constructor(uint64 subscriptionId) VRFConsumerBaseV2(vrfCoordinator) {
        lottery_state = LOTTERY_STATE.CLOSED;
        COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
        LINKTOKEN = LinkTokenInterface(link);
        _subscriptionId = subscriptionId;
    }

    function isMember(address checkerAddress) public view returns(bool isIndeed) {
        return members[checkerAddress].exists;
    }

    function isUsername(string memory _username) public view returns(bool isIndeed) {
        return usernameObserver[_username].exists;
    }

    function enter(string memory _username) public payable {
        require(lottery_state == LOTTERY_STATE.OPEN);
        require(!isMember(msg.sender));
        require(!isUsername(_username));
        Player memory player = Player(_username, true);
        members[msg.sender] = player;
        memberObserver[nbEntry] = msg.sender;
        usernameObserver[_username] = player;
        nbEntry++;
    }

    function startLottery() public onlyOwner {
        require(
            lottery_state == LOTTERY_STATE.CLOSED
        );
        lottery_state = LOTTERY_STATE.OPEN;
        for (uint256 i = 0; i < nbEntry; i++) {
          delete members[memberObserver[i]];
          delete memberObserver[i];
        }
        nbEntry = 0;
        delete winner; 
        delete _requestId;
    }

    function endLottery() public onlyOwner {
        lottery_state = LOTTERY_STATE.CALCULATING_WINNER;
        _requestId = COORDINATOR.requestRandomWords(keyHash, _subscriptionId, 3, 100000, 2);
    }

    function fulfillRandomWords(uint256, uint256[] memory _randomness)
        internal
        override
    {
        require(
            lottery_state == LOTTERY_STATE.CALCULATING_WINNER
        );
        require(_randomness[0] > 0, "random not found.");
        uint256 winnerIndex = _randomness[0] % nbEntry;
        winner = members[memberObserver[winnerIndex]];
        lottery_state = LOTTERY_STATE.CLOSED;
    }
}