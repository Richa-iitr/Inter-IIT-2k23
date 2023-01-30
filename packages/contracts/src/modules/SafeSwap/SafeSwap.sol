// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IParaswap, IERC20} from './Interfaces.sol';
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

  event SwappedWithZeroX(
    address tokenIn,
    address tokenOut,
    uint256 amountIn,
    uint256 amountOut
  );

  event Swapped(
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
  address internal constant zeroX = 0xDef1C0ded9bec7F1a1670819833240f027b25EfF;
  address internal constant ethAddr =
    0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

  enum Dex {
    ZEROX,
    ONEINCH,
    PARASWAP
  }

  /**
   *@dev calculates the slippage or the expected amount returned after successful swap with slippage.
   *@param decimalsIn_ decimals of the token swapped from.
   *@param decimalsOut_ decimals of the token swapped to.
   *@param amount_ amount of token swapped.
   *@param unitAmt_ the amount of amtIn/amtOut with slippage.
   */
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

  /**
   *@dev performs swap with OneInch.
   *@param tokenIn_ the token swap performed from.
   *@param tokenOut_ the token swap performed to.
   *@param amtIn_ amount of tokenIn_ to be swapped.
   *@param unitAmt_ the amount of amtIn/amtOut with slippage.
   *@param callData_ calldata for the swap on OneInch.
   */
  function swapWithOneInch(
    address tokenIn_,
    address tokenOut_,
    uint256 amtIn_,
    uint256 unitAmt_,
    bytes calldata callData_
  ) public payable returns (uint256 amtOut_, bool success_) {
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

    (success_, ) = oneInch.call{value: value_}(callData_);
    require(success_, '1Inch-swap-failed');

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

  /**
   *@dev performs swap with Paraswap.
   *@param tokenIn_ the token swap performed from.
   *@param tokenOut_ the token swap performed to.
   *@param amtIn_ amount of tokenIn_ to be swapped.
   *@param unitAmt_ the amount of amtIn/amtOut with slippage.
   *@param callData_ calldata for the swap on Praswap.
   */
  function swapWithParaswap(
    address tokenIn_,
    address tokenOut_,
    uint256 amtIn_,
    uint256 unitAmt_,
    bytes calldata callData_
  ) public payable returns (uint256 amtOut_, bool success_) {
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

    (success_, ) = paraswap.call{value: value_}(callData_);
    require(success_, 'paraswap-swap-failed');

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

  /**
   *@dev performs swap with ZeroX.
   *@param tokenIn_ the token swap performed from.
   *@param tokenOut_ the token swap performed to.
   *@param amtIn_ amount of tokenIn_ to be swapped.
   *@param unitAmt_ the amount of amtIn/amtOut with slippage.
   *@param callData_ calldata for the swap on ZeroX.
   */
  function swapWithZeroX(
    address tokenIn_,
    address tokenOut_,
    uint256 amtIn_,
    uint256 unitAmt_,
    bytes calldata callData_
  ) public payable returns (uint256 amtOut_, bool success_) {
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

    (success_, ) = zeroX.call{value: value_}(callData_);
    require(success_, 'ZeroX-swap-failed');

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
    emit SwappedWithZeroX(tokenIn_, tokenOut_, amtIn_, amtOut_);
  }
}

// MEV resistant swap(aggregator).
contract SafeSwap is SwapHelpers {
  /**
   *@dev performs safe swap in priority order of dex and passing to the next if swap in higher priority fails.
   *@param dexs the order of supported dexs from which the swap is to be performed.
   *@param tokenIn_ the token swap performed from.
   *@param tokenOut_ the token swap performed to.
   *@param amtIn_ amount of tokenIn_ to be swapped.
   *@param unitAmt_ the amount of amtIn/amtOut with slippage.
   *@param callData_ calldata for the swap on OneInch.
   */
  function swap(
    Dex[] calldata dexs,
    address tokenIn_,
    address tokenOut_,
    uint256 amtIn_,
    uint256 unitAmt_,
    bytes calldata callData_
  ) public payable returns (uint256 amtOut_) {
    uint256 len_ = dexs.length;
    bool success_;

    for (uint256 i = 0; i < len_; ++i) {
      Dex dex = dexs[i];
      if (dex == Dex.ONEINCH) {
        (amtOut_, success_) = swapWithOneInch(
          tokenIn_,
          tokenOut_,
          amtIn_,
          unitAmt_,
          callData_
        );
      } else if (dex == Dex.ZEROX) {
        (amtOut_, success_) = swapWithZeroX(
          tokenIn_,
          tokenOut_,
          amtIn_,
          unitAmt_,
          callData_
        );
      } else if (dex == Dex.PARASWAP) {
        (amtOut_, success_) = swapWithParaswap(
          tokenIn_,
          tokenOut_,
          amtIn_,
          unitAmt_,
          callData_
        );
      } else {
        revert('invalid-dex');
      }
      if (success_) break;
    }
    if (success_) {
      IERC20(tokenOut_).transfer(msg.sender, amtOut_);
    } else revert('swap-Aggregator-failed');
    
    emit Swapped(tokenIn_, tokenOut_, amtIn_, amtOut_);
  }
}
