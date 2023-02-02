// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import 'openzeppelin-contracts/proxy/Clones.sol';

interface Account {
  function addModule(bytes4[] memory sigs, address module) external;
}

// 0x65eca34df2343f360cc9be5c3445a8092a0343b3

contract AccountFactory {
  event cloneCreated(address clone);
  event moduleAdded(address module_);

  function createClone(
    address _implementation,
    address[] memory modules_,
    bytes4[][] memory sigs_
  ) public returns (address instance) {
    instance = Clones.clone(_implementation);
    emit cloneCreated(instance);

    uint256 len_ = modules_.length;
    for (uint256 i = 0; i < len_; ++i) {
      Account(instance).addModule(sigs_[i], modules_[i]);
      emit moduleAdded(modules_[i]);
    }
  }
}
