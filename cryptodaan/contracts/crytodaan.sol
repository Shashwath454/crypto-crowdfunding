// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract cryptodaan {
    struct Ngo {
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        string image;
        address[] donators;
        uint256[] donations;
    }

    mapping(uint256 => Ngo) public ngos;

    uint256 public numberOfngos = 0;

    function createngo(address _owner, string memory _title, string memory _description, uint256 _target, uint256 _deadline, string memory _image) public returns (uint256) {
        Ngo storage ngo = ngos[numberOfngos];

        require(ngo.deadline < block.timestamp, "The deadline cannot be in past");

        ngo.owner = _owner;
        ngo.title = _title;
        ngo.description = _description;
        ngo.target = _target;
        ngo.deadline = _deadline;
        ngo.amountCollected = 0;
        ngo.image = _image;

        numberOfngos++;

        return numberOfngos - 1;
    }

    function donateToNgo(uint256 _id) public payable {
        uint256 amount = msg.value;

        Ngo storage ngo = ngos[_id];

        ngo.donators.push(msg.sender);
        ngo.donations.push(amount);

        (bool sent,) = payable(ngo.owner).call{value: amount}("");

        if(sent) {
            ngo.amountCollected = ngo.amountCollected + amount;
        }
    }

    function getDonators(uint256 _id) view public returns (address[] memory, uint256[] memory) {
        return (ngos[_id].donators, ngos[_id].donations);
    }

    function getngos() public view returns (Ngo[] memory) {
        Ngo[] memory allngos = new Ngo[](numberOfngos);

        for(uint i = 0; i < numberOfngos; i++) {
            Ngo storage item = ngos[i];

            allngos[i] = item;
        }

        return allngos;
    }
}