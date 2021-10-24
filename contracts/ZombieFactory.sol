pragma solidity >=0.5.0 <0.6.0; // Version Solidity should use to compile this code

contract ZombieFactory {

  // Events communicate with the frontend to tell if something happened on the blockchain
  // So we can take those events and listen to it
  event NewZombie(uint zombieId, string name, uint dna);

  // State variables are permanently stored in contract storage (Written directly to the blockchain)
  uint dnaDigits = 16;
  uint dnaModulus = 10 ** dnaDigits; // Can be used to short an integer to 16 digits

  // Structs allow the creation of complex data types with multiple properties (js objects (:)
  struct Zombie {
    string name;
    uint dna;
  }

  // Arrays... do I need to say something else??? YES!! There are two types of arrays in solidity: fixed and dynamic;
  // Fixed arrays have a max length whilst dynamic can keep growing.
  // We can use arrays as state variables to permanently store data in the blockchain as a database ;)

  // uint[2] fixedArray;
  // uint[] dynamicArray;
  // Person[] people; with structs

  // The public keyword automatically creates a getter method for the variable and also make it public to other smart contracts
  // Others can read our data but not write to it
  Zombie[] public zombies;

  // Mapping is another is to store organized data in Solidity, it stores using a key-value pair
  mapping(uint => address) public zombieToOwner; // Who the zombie's belong to
  mapping(address => uint) ownerZombieCount; // Keeps track of how many zombies the address own

  // There are two ways of passing arguments for solidity functions, by reference and value
  // Values: Solidity creates a copy of the variable's value sou we can change it without change the original argument
  // the keyword memory is used to create a value argument
  // Reference: The argument is a reference to the original variable so if we change it the original value gets changed
  function _createZombie(string memory _name, uint _dna) internal {

    uint id = zombies.push(Zombie(_name, _dna)) - 1;

    // msg.sender = who's calling the function (address)
    zombieToOwner[id] = msg.sender;

    ownerZombieCount[msg.sender]++;

    emit NewZombie(id, _name, _dna);
  }

  // Function modifiers
  // View functions only view data but not modify it
  // Pure functions don't access any data inside the app
  function _generateRandomDna(string memory _str) private view returns (uint) {

    uint rand = uint(keccak256(abi.encodePacked(_str)));

    return rand % dnaModulus;
  }

  function createRandomZombie(string memory _name) public {

    // the user we'll be able to create only 1 zombie
    require(ownerZombieCount[msg.sender] == 0);

    uint randDna = _generateRandomDna(_name);

    _createZombie(_name, randDna);
  }
}