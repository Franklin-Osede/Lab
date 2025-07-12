// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title MockERC20
 * @notice Mock ERC20 token for testing the liquidity pool
 * @dev Includes additional functions to facilitate testing
 */
contract MockERC20 is ERC20, Ownable {
    
    uint8 private _decimals;
    
    constructor(
        string memory name,
        string memory symbol,
        uint8 decimals_,
        uint256 initialSupply,
        address owner
    ) ERC20(name, symbol) Ownable(owner) {
        _decimals = decimals_;
        _mint(owner, initialSupply);
    }
    
    /**
     * @notice Mint tokens to a specific address
     * @param to Recipient address
     * @param amount Amount to mint
     */
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }
    
    /**
     * @notice Burn tokens from a specific address
     * @param from Address to burn from
     * @param amount Amount to burn
     */
    function burn(address from, uint256 amount) external onlyOwner {
        _burn(from, amount);
    }
    
    /**
     * @notice Mint tokens directly to msg.sender (for testing)
     * @param amount Amount to mint
     */
    function mintToSelf(uint256 amount) external {
        _mint(msg.sender, amount);
    }
    
    /**
     * @notice Override decimals for custom configuration
     */
    function decimals() public view override returns (uint8) {
        return _decimals;
    }
    
    /**
     * @notice Simulate transfer failure (for error testing)
     * @dev Only works if the owner activates it
     */
    bool public transfersShouldFail = false;
    
    function setTransfersShouldFail(bool shouldFail) external onlyOwner {
        transfersShouldFail = shouldFail;
    }
    
    function transfer(address to, uint256 amount) public override returns (bool) {
        require(!transfersShouldFail, "MockERC20: Transfers disabled for testing");
        return super.transfer(to, amount);
    }
    
    function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
        require(!transfersShouldFail, "MockERC20: Transfers disabled for testing");
        return super.transferFrom(from, to, amount);
    }
    
    /**
     * @notice Set specific balance for testing
     * @param account Account to configure
     * @param amount New balance
     */
    function setBalance(address account, uint256 amount) external onlyOwner {
        uint256 currentBalance = balanceOf(account);
        if (currentBalance < amount) {
            _mint(account, amount - currentBalance);
        } else if (currentBalance > amount) {
            _burn(account, currentBalance - amount);
        }
    }
    
    /**
     * @notice Transfer ownership and mint initial amount to new owner
     * @param newOwner New owner
     * @param mintAmount Amount to mint to new owner
     */
    function transferOwnershipAndMint(address newOwner, uint256 mintAmount) external onlyOwner {
        if (mintAmount > 0) {
            _mint(newOwner, mintAmount);
        }
        _transferOwnership(newOwner);
    }
} 