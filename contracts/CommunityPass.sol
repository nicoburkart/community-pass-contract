pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";
import "./Renderer.sol";

contract CommunityPass is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct Pass {
        string accessTier;
        string colorHex;
        bool vip;
    }

    address public immutable _developer;
    uint256 public immutable _feeAmount;
    uint256 public immutable _supply;

    //mapping from the nft's tokenId => Pass attributes.
    mapping(uint256 => Pass) public passAttr;
    //mapping from the nft's tokenId => timestamps
    mapping(uint256 => uint256) public timestamps;

    // renderer is stored as a separated contract so we can update it if we want to
    Renderer public renderer;

    constructor(uint256 feeAmount, uint256 supply)
        ERC721("CommunityPass", "ACCESS")
    {
        _feeAmount = feeAmount;
        _developer = owner();
        _supply = supply;
        _tokenIds.increment();
    }

    //------------ Sale control functions and modifier

    bool private _saleStarted;

    modifier whenFeeIncluded() {
        require(msg.value >= _feeAmount, "Fee not included");
        _;
    }

    modifier whenSaleStarted() {
        require(_saleStarted, "Sale has not begun");
        _;
    }

    modifier whenTokenLeft() {
        require(_tokenIds.current() < _supply + 1, "No tokens left");
        _;
    }

    function saleStarted() public view returns (bool) {
        return _saleStarted;
    }

    //------------ Admin functions

    function flipSaleStarted() external onlyOwner {
        _saleStarted = !_saleStarted;
    }

    // To update the render contract if needed
    function setRenderer(Renderer _renderer) external onlyOwner {
        renderer = _renderer;
    }

    function withdrawAll() external {
        payable(owner()).transfer(address(this).balance);
    }

    //------------ Public functions

    function mintNFT(string memory _accessTier, string memory _colorHex)
        external
        payable
        whenSaleStarted
        whenFeeIncluded
        whenTokenLeft
        returns (uint256)
    {
        uint256 newItemId = _tokenIds.current();

        passAttr[newItemId] = Pass({
            accessTier: _accessTier,
            colorHex: _colorHex,
            vip: false
        });

        console.log(_tokenIds.current());
        console.log("Contract balance", address(this).balance);
        console.log(tokenURI(newItemId));

        _safeMint(msg.sender, newItemId);
        timestamps[newItemId] = block.timestamp;
        _tokenIds.increment();
        console.log(
            "An NFT w/ ID %s has been minted to %s",
            newItemId,
            msg.sender
        );

        return newItemId;
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        override
        returns (string memory)
    {
        return
            renderer.render(
                _tokenId,
                "DemoDAO",
                passAttr[_tokenId].accessTier,
                passAttr[_tokenId].colorHex,
                passAttr[_tokenId].vip
            );
    }

    function claimVipStatus(uint256 _tokenId) external {
        require(ownerOf(_tokenId) == msg.sender, "Not your NFT");
        require(!passAttr[_tokenId].vip, "You already have VIP status");
        require(
            timestamps[_tokenId] + 8 weeks <= block.timestamp,
            "8 haven't gone past"
        );

        passAttr[_tokenId].vip = true;
    }

    //------------ internal functions

    // If the nft has been held for x amount of time it will unlock the vip attribute
    // That way holder will be rewarded for holding the nft for longer
    // If the nft is transfered before the x amount of time the timestamp will get a reset
    function _beforeTokenTransfer(
        address _from,
        address _to,
        uint256 _tokenId
    ) internal virtual override {
        super._beforeTokenTransfer(_from, _to, _tokenId);
        if (_from != address(0)) {
            if (!passAttr[_tokenId].vip) {
                if (timestamps[_tokenId] + 8 weeks <= block.timestamp) {
                    passAttr[_tokenId].vip = true;
                }
            }
        }
    }
}
