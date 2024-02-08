// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title STAKING CONTRACT
 * @author MOHAMMAD RAAZY
 * @notice this contract is not test it yet, will be test it in the future
 */

import { IERC20 } from '@openzeppelin/contracts/token/ERC20/IERC20.sol';

contract Staking {
    error Staking_BalanceShouldBeMoreThanAmount();
    
    uint256 private constant DECIMALS = 1e18;
    uint256 private constant USDT_DECIMALS = 1e6;

    // uint256 private rewardPercentage = 200; // 200%
    // note from bob , use a arbitrary value based on totalpool or rewardpool in regards to time staked

    uint256 private s_rewardPerToken = 100_000 wei; // equal to 0.1 usdt 

    IERC20 private s_stakeToken;
    IERC20 private s_rewardToken;

    mapping(address staker => StakeInfo) private s_staker;

    struct StakeInfo {
        address staker;
        uint256 duration;
        uint256 amount;
        uint256 rewards;
    }

    constructor(address stakeToken_, address rewardToken_) {
        s_stakeToken = IERC20(stakeToken_);
        s_rewardToken = IERC20(rewardToken_);
    }

    modifier NotZeroAddr() {
        require(msg.sender != address(0), "caller cannot be zero address");
        _;
    }

    /**
     * @dev calculate the staker rewards
     * @param amount -> amount to stake
     * @param duration_ => how long they want to stake
     */
    // totalSupply / (amount )
    function _calculateReward(uint256 amount, uint256 duration_) internal view returns(uint256 rewards) {
        uint256 reward = (amount * s_rewardPerToken * duration_ ) * USDT_DECIMALS;
        return reward;
    }

     /**@dev stake the token
     * @param amount -> amount to stake
     * @param duration_ => how long they want to stake
     */
    function stake(uint256 amount, uint256 duration_) external NotZeroAddr {
        // user send amount to stake to this contract
        // user set how long they want to stake
        // 
        uint256 balance = s_stakeToken.balanceOf(msg.sender);

        if(balance < amount) {
            revert Staking_BalanceShouldBeMoreThanAmount();
        }

        s_stakeToken.transferFrom(msg.sender, address(this), amount);
        uint256 totalRewards = _calculateReward(amount, duration_);
        s_staker[msg.sender] = StakeInfo({ staker: msg.sender, duration: duration_, amount: amount, rewards: totalRewards });

    }

     function unStake() external {
        
    }

    function claimReward() external {

    }

    function getUserRewards(address staker_) external returns(uint256 rewards) {
        return s_staker[staker_].rewards;
    }

    receive() external payable {}

}
