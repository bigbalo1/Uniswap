// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";

contract UniswapInteractions {
    IUniswapV2Router02 public uniswapRouter;

    address private owner;

    constructor(address _router) {
        uniswapRouter = IUniswapV2Router02(_router);
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    // Swap exact tokens for tokens
    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external onlyOwner {
        IERC20(path[0]).transferFrom(msg.sender, address(this), amountIn);
        IERC20(path[0]).approve(address(uniswapRouter), amountIn);

        uniswapRouter.swapExactTokensForTokens(
            amountIn,
            amountOutMin,
            path,
            to,
            deadline
        );
    }

    // Add liquidity to a Uniswap pool
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountTokenA,
        uint256 amountTokenB,
        uint256 amountTokenAMin,
        uint256 amountTokenBMin,
        address to,
        uint256 deadline
    ) external onlyOwner {
        IERC20(tokenA).transferFrom(msg.sender, address(this), amountTokenA);
        IERC20(tokenB).transferFrom(msg.sender, address(this), amountTokenB);

        IERC20(tokenA).approve(address(uniswapRouter), amountTokenA);
        IERC20(tokenB).approve(address(uniswapRouter), amountTokenB);

        uniswapRouter.addLiquidity(
            tokenA,
            tokenB,
            amountTokenA,
            amountTokenB,
            amountTokenAMin,
            amountTokenBMin,
            to,
            deadline
        );
    }
}
