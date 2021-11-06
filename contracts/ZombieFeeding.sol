pragma solidity >=0.5.0 <0.6.0;

import "./ZombieFactory.sol";
import "../interfaces/KittyInterface.sol";

contract ZombieFeeding is ZombieFactory {

  KittyInterface kittyContract;
  // Storage refers to variables stored permanently on the blockchain.
  // Memory variables are temporary, and are erased between external function calls to your contract.

  modifier ownerOf(uint _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    _;
  }

  function setKittyContractAddress(address _address) external onlyOwner {
    kittyContract = KittyInterface(_address);
  }

  function _triggerCooldown(Zombie storage _zombie) internal {
    _zombie.readyTime = uint32(now + cooldownTime);
  }

  function _isReady(Zombie storage _zombie) internal view returns (bool){
    return (_zombie.readyTime <= now);
  }

  function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) internal ownerOf(_zombieId) {

    Zombie storage myZombie = zombies[_zombieId];

    require(_isReady(myZombie));

    _targetDna = _targetDna % dnaModulus;

    uint newDna = (myZombie.dna + _targetDna) / 2;

    if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
      newDna = newDna - newDna % 100 + 99;
    }

    _createZombie("NoName", newDna);

    _triggerCooldown(myZombie);
  }

  function feedOnKitty(uint _zombieId, uint _kittyId) public {

    uint kittyDna;

    (,,,,,,,,,, kittyDna) = kittyContract.getKitty(_kittyId);

    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }
}