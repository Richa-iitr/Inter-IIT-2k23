// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract batchTransaction {
  address[] public addresses;
  mapping(address => uint) public value;

  function setMapping(address target, uint256 amount) public payable {
    uint256 scaledAmount = amount * 10 ** 18;
    value[target] = scaledAmount;
    bool present;
    for (uint256 i = 0; i < addresses.length; i++) {
      if (addresses[i] == target) {
        present = true;
        break;
      }
    }
    if (!present) {
      addresses.push(target);
    }
  }

  function sendBatchedTransactions(
    address[] memory _address,
    bytes[] calldata _data
  ) public {
    require(_address.length == _data.length);
    for (uint256 i = 0; i < _address.length; i++) {
      (bool sent, ) = _address[i].delegatecall(_data[i]);
      require(sent, 'Failed to send Ether');
    }
  }
}
