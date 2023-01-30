// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IOneInch, IERC20} from './Interfaces.sol';
import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";
contract SwapEvents {}

contract SwapHelpers {
  address oneInch = 0x1111111254EEB25477B68fb85Ed929f73A960582;
  address ethAddr = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

  function calculateSlippage(
    uint256 decimals_,
    uint256 amount_,
    uint256 unitAmt_
  ) external view returns (uint256 slippage_) {
    uint256 inAmt_ = amount_ * 10**(18 - decimals_);
  }

  function swapWithOneInch(
    address tokenIn_,
    address tokenOut_,
    uint256 amtIn_,
    uint256 unitAmt_,
    bytes calldata callData_
  ) external payable returns (uint256 amtOut_) {
    //approve the token to be swapped to one inch contract
    if (tokenIn_ != ethAddr) {
      IERC20(tokenIn_).approve(oneInch, amtIn_);
    }
  }
}

// MEV resistant swap(aggregator).
contract SafeSwap {

}
