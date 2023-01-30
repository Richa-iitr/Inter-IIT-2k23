// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IOneInch, IParaswap, IERC20} from './Interfaces.sol';
import {SafeMath} from 'openzeppelin-contracts/utils/math/SafeMath.sol';

contract SwapEvents {
  event SwappedWith1Inch(
    address tokenIn,
    address tokenOut,
    uint256 amountIn,
    uint256 amountOut
  );

  event SwappedWithParaswap(
    address tokenIn,
    address tokenOut,
    uint256 amountIn,
    uint256 amountOut
  );
}

contract SwapHelpers is SwapEvents {
  //TODO: switch to testnet address from mainnet address
  address internal constant oneInch =
    0x1111111254EEB25477B68fb85Ed929f73A960582;
  address internal constant paraswap =
    0xDEF171Fe48CF0115B1d80b88dc8eAB59176FEe57;
  address internal constant ethAddr =
    0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

  function calculateSlippage(
    uint256 decimalsIn_,
    uint256 decimalsOut_,
    uint256 amount_,
    uint256 unitAmt_
  ) public pure returns (uint256 slippage_) {
    uint256 inWeiAmt_ = SafeMath.mul(amount_, 10**(18 - decimalsIn_));

    slippage_ =
      SafeMath.add(SafeMath.mul(unitAmt_, inWeiAmt_), (10**18) / 2) /
      (10**18);
    slippage_ = (decimalsOut_ / 10**(18 - decimalsOut_));
  }

  function swapWithOneInch(
    address tokenIn_,
    address tokenOut_,
    uint256 amtIn_,
    uint256 unitAmt_,
    bytes calldata callData_
  ) external payable returns (uint256 amtOut_) {
    //approve the token to be swapped to one inch contract
    uint256 value_ = 0;
    if (tokenIn_ != ethAddr) {
      IERC20(tokenIn_).approve(oneInch, amtIn_);
      value_ = amtIn_;
    }

    //TODO: check for msg.sender, delegate call logic
    uint256 initialBal_ = (tokenOut_) == ethAddr
      ? msg.sender.balance
      : IERC20(tokenOut_).balanceOf(msg.sender);

    (bool success, ) = oneInch.call{value: value_}(callData_);
    require(success, '1Inch-swap-failed');

    uint256 finalBal_ = (tokenOut_) == ethAddr
      ? msg.sender.balance
      : IERC20(tokenOut_).balanceOf(msg.sender);
    amtOut_ = SafeMath.sub(finalBal_, initialBal_);

    uint256 slippage_ = calculateSlippage(
      IERC20(tokenIn_).decimals(),
      IERC20(tokenOut_).decimals(),
      amtIn_,
      unitAmt_
    );
    require(slippage_ <= amtOut_, 'high-slippage');
    emit SwappedWith1Inch(tokenIn_, tokenOut_, amtIn_, amtOut_);
  }

  function swapWithParaswap(
    address tokenIn_,
    address tokenOut_,
    uint256 amtIn_,
    uint256 unitAmt_,
    bytes calldata callData_
  ) external payable returns (uint256 amtOut_) {
    //approve the token to be swapped to one inch contract
    uint256 value_ = 0;
    if (tokenIn_ != ethAddr) {
      address tokenProxy_ = IParaswap(paraswap).getTokenTransferProxy();
      IERC20(tokenIn_).approve(tokenProxy_, amtIn_);
    }

    //TODO: check for msg.sender, delegate call logic
    uint256 initialBal_ = (tokenOut_) == ethAddr
      ? msg.sender.balance
      : IERC20(tokenOut_).balanceOf(msg.sender);

    (bool success, ) = paraswap.call{value: value_}(callData_);
    require(success, 'paraswap-swap-failed');

    uint256 finalBal_ = (tokenOut_) == ethAddr
      ? msg.sender.balance
      : IERC20(tokenOut_).balanceOf(msg.sender);
    amtOut_ = SafeMath.sub(finalBal_, initialBal_);

    uint256 slippage_ = calculateSlippage(
      IERC20(tokenIn_).decimals(),
      IERC20(tokenOut_).decimals(),
      amtIn_,
      unitAmt_
    );
    require(slippage_ <= amtOut_, 'high-slippage');
    emit SwappedWithParaswap(tokenIn_, tokenOut_, amtIn_, amtOut_);
  }
}

// MEV resistant swap(aggregator).
contract SafeSwap {

}
