// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;
  //to do in   
//in assembly
//deposit 
//withdarw

contract MetaTransaction{


uint public chainId ;
mapping(address => bool) public isAuthorized;
event transactionExecuted(address indexed _user, address indexed _to , bool indexed isDone) ;


function setChainId(uint _chainId) public {
chainId = chainId ;
}



function addAuthorization(address _permitAddress) public {
    isAuthorized[_permitAddress]= true;
}


// function getWhetherTrueOrFalse(address _permitAddress) public view returns(bool){
//   require( isAuthorized[_permitAddress], "not authorized");
//   return true;
// }


 //_user is the payer
function execute(address _user, address _to , bytes calldata  _data , uint8 sigv, bytes32 sigr , bytes32 sigs) public {
  // Check that the caller is authorized to execute transactions on behalf of the user
  require(isAuthorized[_user],"Unauthorized relayer");

  // to verify the signature
  bytes32 hash = keccak256(abi.encodePacked(chainId, _data));
  address signer = ecrecover(hash, sigv, sigr, sigs);
  require(signer == _user, "Invalid signature");

  // to execute the user's transaction
(bool didSucceed, ) = _to.delegatecall(_data);
require(didSucceed , "Call Failed");
emit transactionExecuted(_user, _to, true); 

}
} 
