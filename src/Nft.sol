// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Nft is ERC721, Ownable {
    mapping(address => bool) public blacklistedAddresses;
    mapping(address => bool) public registered;

    uint256 public immutable TOTAL_SUPPLY = 10;
    uint256 public constant REGISTRATION_PRICE = 0.01 ether;
    uint256 public constant MINTING_PRICE = 0.2 ether;

    event Minted(address indexed user, uint256 indexed tokenId);
    event Registered(address indexed user);
    event Blacklisted(address indexed addedBy, address indexed blacklistedAddress);

    error Nft__Blacklisted(address user);
    error Nft__NotRegistered(address user);
    error Nft__AlreadyRegistered(address user);
    error Nft__TokenDoesNotExist(uint256 tokenId);
    error Nft__AlreadyBlacklisted(address user);
    error Nft__InsufficientFunds(uint256 value);

    constructor() ERC721("Nft", "Nft") Ownable(msg.sender) {}

    modifier onlyRegistered() {
        if (!registered[_msgSender()]) {
            revert Nft__NotRegistered(_msgSender());
        }
        _;
    }

    modifier notBlacklisted() {
        if (blacklistedAddresses[_msgSender()]) {
            revert Nft__Blacklisted(_msgSender());
        }
        _;
    }

    function register() external payable {
        if (registered[_msgSender()]) {
            revert Nft__AlreadyRegistered(_msgSender());
        }

        if (msg.value < REGISTRATION_PRICE) {
            revert Nft__InsufficientFunds(msg.value);
        }

        registered[_msgSender()] = true;
        emit Registered(_msgSender());
    }

    function mint(uint256 tokenId) external payable onlyRegistered notBlacklisted {
        if (tokenId > TOTAL_SUPPLY) {
            revert Nft__TokenDoesNotExist(tokenId);
        }

        if (msg.value < MINTING_PRICE) {
            revert Nft__InsufficientFunds(msg.value);
        }

        _safeMint(_msgSender(), tokenId);
        emit Minted(_msgSender(), tokenId);
    }

    function addToBlacklist(address user) external onlyOwner {
        if (blacklistedAddresses[user]) {
            revert Nft__AlreadyBlacklisted(user);
        }
        blacklistedAddresses[user] = true;
        emit Blacklisted(_msgSender(), user);
    }

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmbHw5KaMLxMYdjCoGmo8LG5WurQeRpDBgeiz8oxFD8yno/";
    }
}
