// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity ^0.8.12;

import "./BaseERC6551Account.sol";

abstract contract OwnerManager is BaseERC6551Account {
    event AAOwnerSet(address owner);

    address internal owner;

    uint256 public nonce;

    modifier onlyOwner() {
        require(isOwner(msg.sender), "not call by owner");
        _;
    }

    function initializeOwners(address _owner) internal {
        owner = _owner;

        emit AAOwnerSet(_owner);
    }

    function isOwner(address _owner) public view returns (bool) {
        return getOwner() == _owner;
    }

    function getOwner() public view returns (address) {
        (uint256 chainId, address tokenContract, uint256 tokenId) = token();
        if (chainId != block.chainid) return address(0);

        return IERC721(tokenContract).ownerOf(tokenId);
    }

    function isValidSigner(
        address signer,
        bytes calldata
    ) external view returns (bytes4 magicValue) {
        if (isOwner(signer)) {
            return IERC6551Account.isValidSigner.selector;
        }
    }
}
