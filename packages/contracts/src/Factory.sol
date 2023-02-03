// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import 'openzeppelin-contracts/proxy/Clones.sol';

// 0xE42289016E024F3F322896C6728f0434545465C1
interface Account {
  function addModule(bytes4[] memory sigs, address module) external;

  function initialize(address factory_, address owner_) external;
}

//

contract AccountFactory {
  event cloneCreated(address clone);
  event moduleAdded(address module_);

  function createClone(
    address _implementation,
    address[] memory modules_,
    bytes4[][] memory sigs_
  ) public returns (address instance) {
    instance = Clones.clone(_implementation);
    Account(instance).initialize(address(this), msg.sender);
    emit cloneCreated(instance);

    uint256 len_ = modules_.length;
    for (uint256 i = 0; i < len_; ++i) {
      Account(instance).addModule(sigs_[i], modules_[i]);
      emit moduleAdded(modules_[i]);
    }
  }
}
