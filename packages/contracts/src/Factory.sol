// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin-contracts/proxy/Clones.sol";
contract AccountFactory {

}


contract AddressFactory  {
    event cloneCreated(address clone);
    function createClone(address _implementation) public returns (address instance) {
        instance = Clones.clone(_implementation);
        emit cloneCreated(instance);
    }
}