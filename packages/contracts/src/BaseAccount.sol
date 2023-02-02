// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// GOERLI: 0x21341a8fcdC727784cF0166BE8204ccd8Eb60730
contract BaseAccount {
  address public owner;

  //whitelisting addresses or contracts for certain actions
  struct Whitelist {
    bool whitelisted;
    uint256 whitelistTime;
  }

  //module structure for dapp sepecifuc actions or standard actions
  mapping(bytes4 => address) enabledModules;

  mapping(address => Whitelist) whitelisted;

  mapping(address => bool) auths;

  constructor() {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner, 'sender-not-owner');
    _;
  }

  modifier onlyAuth() {
    require(auths[msg.sender] == true, 'sender-not-owner');
    _;
  }

  event OwnerUpdated(address new_);
  event AuthsUpdated(address new_, bool enabled);
  event ModuleUpdated(address module_, bytes4 sig_);
  event ModuleAdded(address module_, bytes4 sig_);

  function setOwner(address newOwner_) external onlyOwner {
    require(newOwner_ != address(0), 'null-owner');
    require(newOwner_ != owner, 'already-owner');
    owner = newOwner_;
    emit OwnerUpdated(newOwner_);
  }

  function setAuth(address newAuth_) external onlyOwner {
    require(newAuth_ != address(0), 'null-auth');
    require(auths[newAuth_] != true, 'already-auth');
    auths[newAuth_] = true;
    emit AuthsUpdated(newAuth_, true);
  }

  function removeAuth(address auth_) external onlyOwner {
    require(auth_ != address(0), 'null-auth');
    require(auths[auth_] == true, 'not-auth');
    auths[auth_] = false;
    emit AuthsUpdated(auth_, false);
  }

  function whitelistContracts(
    address[] memory contracts_,
    uint256[] memory durations_
  ) external onlyOwner {
    uint256 length_ = contracts_.length;
    uint256 i = 0;

    require(length_ == durations_.length, 'invalid-length');

    for (; i < length_; ++i) {
      address contract_ = contracts_[i];
      if (whitelisted[contract_].whitelisted == false) {
        whitelisted[contract_] = Whitelist({
          whitelisted: true,
          whitelistTime: durations_[i]
        });
      }
    }
  }

  function _delegateCall(address to_, bytes calldata data_)
    public
    payable
    returns (bool success)
  {
    (success, ) = to_.delegatecall(data_);
    require(success, 'call-failed');
  }

  function addModule(bytes4[] memory sig_, address module_) external onlyOwner {
    require(module_ != address(0), 'invalid-module');

    uint256 len_ = sig_.length;
    for (uint256 i = 0; i < len_; ++i) {
      enabledModules[sig_[i]] = module_;
      emit ModuleAdded(module_, sig_[i]);
    }
  }

  function updateModule(bytes4 sig_, address module_) external onlyOwner {
    require(module_ != address(0), 'invalid-module');
    require(enabledModules[sig_] != module_, 'already-enabled');

    enabledModules[sig_] = module_;
    emit ModuleUpdated(module_, sig_);
  }

  function getModule(bytes4 sig_) public view returns (address module_) {
    return enabledModules[sig_];
  }

  fallback() external payable {
    address module_ = getModule(msg.sig);
    require(module_ != address(0), 'no-module-found');
    assembly {
      // Copy msg.data. We take full control of memory in this inline assembly
      // block because it will not return to Solidity code. We overwrite the
      // Solidity scratch pad at memory position 0.
      // copy calldata(tx data) to memory: copy entire data at start of memory(0 offset at 0th position)
      calldatacopy(0, 0, calldatasize())

      // Call the implementation. Forward the data to the module.
      // out offset and out-offset size are 0 because we don"t know the size yet.
      let result := delegatecall(gas(), module_, 0, calldatasize(), 0, 0)

      // Copy the returned data.
      returndatacopy(0, 0, returndatasize())

      switch result
      // delegatecall returns 0 on error.
      case 0 {
        revert(0, returndatasize())
      }
      default {
        return(0, returndatasize())
      }
    }
  }

  receive() external payable {}
}
