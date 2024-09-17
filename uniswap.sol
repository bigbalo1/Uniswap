// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import the necessary UniswapV2 Router interface
interface IUniswapV2Router02 {
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);

    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
}

// Minimal ERC20 Interface
interface IERC20 {
    function approve(address spender, uint256 amount) external returns (bool);
}

contract UniswapLiquidity {
    // Address of UniswapV2 Router (mainnet address is used here)
    address private constant UNISWAP_V2_ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    IUniswapV2Router02 public uniswapRouter;

    constructor() {
        // Initialize the Uniswap router
        uniswapRouter = IUniswapV2Router02(UNISWAP_V2_ROUTER);
    }

    // Add Liquidity for ETH and ERC20 Token
    function addLiquidityETH(
        address token, 
        uint amountTokenDesired
    ) external payable {
        // Approve the Uniswap router to spend the ERC20 tokens on behalf of the user
        IERC20(token).approve(UNISWAP_V2_ROUTER, amountTokenDesired);

        // Add liquidity
        uniswapRouter.addLiquidityETH{ value: msg.value }(
            token,                // The token being paired with ETH
            amountTokenDesired,    // Amount of ERC20 tokens provided
            0,                     // Min tokens (set to 0 for simplicity)
            0,                     // Min ETH (set to 0 for simplicity)
            msg.sender,            // Address receiving the liquidity tokens
            block.timestamp + 300  // Deadline (5 minutes from now)
        );
    }

    // Remove Liquidity for ETH and ERC20 Token
    function removeLiquidityETH(
        address token,
        uint liquidity
    ) external {
        // Remove liquidity
        uniswapRouter.removeLiquidityETH(
            token,                // The token being paired with ETH
            liquidity,            // The amount of liquidity to remove
            0,                    // Min amount of tokens to receive (set to 0 for simplicity)
            0,                    // Min amount of ETH to receive (set to 0 for simplicity)
            msg.sender,           // Address receiving the underlying assets (ETH + Token)
            block.timestamp + 300 // Deadline (5 minutes from now)
        );
    }
}
