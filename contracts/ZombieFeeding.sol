pragma solidity >=0.5.0 <0.6.0;

import "./ZombieFactory.sol";
import "../interfaces/KittyInterface.sol";

contract ZombieFeeding is ZombieFactory {

  address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
  KittyInterface kittyContract = KittyInterface(ckAddress);
  // Storage refers to variables stored permanently on the blockchain.
  // Memory variables are temporary, and are erased between external function calls to your contract.

  function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) public {

    require(msg.sender == zombieToOwner[_zombieId]);

    Zombie storage myZombie = zombies[_zombieId];

    _targetDna = _targetDna % dnaModulus;

    uint newDna = (myZombie.dna + _targetDna) / 2;

    if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
      newDna = newDna - newDna % 100 + 99;
    }

    _createZombie("NoName", newDna);
  }

  function feedOnKitty(uint _zombieId, uint _kittyId) public {

    uint kittyDna;

    (,,,,,,,,,, kittyDna) = kittyContract.getKitty(_kittyId);

    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }
}