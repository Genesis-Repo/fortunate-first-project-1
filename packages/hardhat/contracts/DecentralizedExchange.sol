// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract DecentralizedExchange {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    address public owner;

    mapping(address => uint256) public balances;

    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);
    event Trade(address indexed user, address indexed tokenGive, uint256 amountGive, address indexed tokenGet, uint256 amountGet);

    constructor() {
        owner = msg.sender;
    }

    function deposit(uint256 _amount) public {
        balances[msg.sender] = balances[msg.sender].add(_amount);
        emit Deposit(msg.sender, _amount);
    }

    function withdraw(uint256 _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        balances[msg.sender] = balances[msg.sender].sub(_amount);
        emit Withdraw(msg.sender, _amount);
    }

    function trade(address _tokenGive, uint256 _amountGive, address _tokenGet, uint256 _amountGet) public {
        require(balances[msg.sender] >= _amountGive, "Insufficient balance");

        IERC20(_tokenGive).safeTransferFrom(msg.sender, address(this), _amountGive);
        IERC20(_tokenGet).safeTransfer(msg.sender, _amountGet);

        balances[msg.sender] = balances[msg.sender].sub(_amountGive);
        balances[msg.sender] = balances[msg.sender].add(_amountGet);

        emit Trade(msg.sender, _tokenGive, _amountGive, _tokenGet, _amountGet);
    }

    function getBalance(address _user) public view returns (uint256) {
        return balances[_user];
    }
}