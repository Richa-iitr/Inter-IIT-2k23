// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.13;

<<<<<<< HEAD
// import "forge-std/Test.sol";
// import "../src/Counter.sol";

// // contract CounterTest is Test {
// //     Counter public counter;

//     function setUp() public {
//         counter = new Counter();
//         counter.setNumber(0);
//     }

//     function testIncrement() public {
//         counter.increment();
//         assertEq(counter.number(), 1);
//     }

//     function testSetNumber(uint256 x) public {
//         counter.setNumber(x);
//         assertEq(counter.number(), x);
//     }
=======
// import 'forge-std/Test.sol';
// import '../src/modules/SafeSwap/SafeSwap.sol';

// contract SwapTest is Test {
//   SafeSwap public swap;

//   function setUp() public {
//     swap = new SafeSwap();
//   }

//   function hexStrToBytes(string memory hex_str)  returns (bytes memory) {
//     //Check hex string is valid
//     if (
//       bytes(hex_str)[0] != '0' ||
//       bytes(hex_str)[1] != 'x' ||
//       bytes(hex_str).length % 2 != 0 ||
//       bytes(hex_str).length < 4
//     ) {
//       throw;
//     }

//     bytes memory bytes_array = new bytes((bytes(hex_str).length - 2) / 2);

//     for (uint256 i = 2; i < bytes(hex_str).length; i += 2) {
//       uint256 tetrad1 = 16;
//       uint256 tetrad2 = 16;

//       //left digit
//       if (uint256(bytes(hex_str)[i]) >= 48 && uint256(bytes(hex_str)[i]) <= 57)
//         tetrad1 = uint256(bytes(hex_str)[i]) - 48;

//       //right digit
//       if (
//         uint256(bytes(hex_str)[i + 1]) >= 48 &&
//         uint256(bytes(hex_str)[i + 1]) <= 57
//       ) tetrad2 = uint256(bytes(hex_str)[i + 1]) - 48;

//       //left A->F
//       if (uint256(bytes(hex_str)[i]) >= 65 && uint256(bytes(hex_str)[i]) <= 70)
//         tetrad1 = uint256(bytes(hex_str)[i]) - 65 + 10;

//       //right A->F
//       if (
//         uint256(bytes(hex_str)[i + 1]) >= 65 &&
//         uint256(bytes(hex_str)[i + 1]) <= 70
//       ) tetrad2 = uint256(bytes(hex_str)[i + 1]) - 65 + 10;

//       //left a->f
//       if (uint256(bytes(hex_str)[i]) >= 97 && uint256(bytes(hex_str)[i]) <= 102)
//         tetrad1 = uint256(bytes(hex_str)[i]) - 97 + 10;

//       //right a->f
//       if (
//         uint256(bytes(hex_str)[i + 1]) >= 97 &&
//         uint256(bytes(hex_str)[i + 1]) <= 102
//       ) tetrad2 = uint256(bytes(hex_str)[i + 1]) - 97 + 10;

//       //Check all symbols are allowed
//       if (tetrad1 == 16 || tetrad2 == 16) revert('invalid');

//       bytes_array[i / 2 - 1] = bytes1(16 * tetrad1 + tetrad2);
//     }

//     return bytes_array;
//   }

//   function testSwap() public {
//     bytes
//       memory calldata_ = "0x3598d8ab00000000000000000000000000000000000000000000000000000000000000600000000000000000000000000000000000000000000000537f88150bce6515e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002bc02aaa39b223fe8d0a0e5c4f27ead9083c756cc20001f46b175474e89094c44da98b954eedeac495271d0f000000000000000000000000000000000000000000869584cd000000000000000000000000100000000000000000000000000000000000001100000000000000000000000000000000000000000000009dcd7acdb863d81b28";
//     swap.swap(
//       [SwapHelpers.Dex.ZEROX],
//       0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE,
//       0x73967c6a0904aA032C103b4104747E88c566B1A2,
//       10000000000000000,
//       15202693763,
//       calldata_
//     );
//   }
>>>>>>> main
// }
