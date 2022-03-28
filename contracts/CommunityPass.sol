pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Renderer.sol";

contract CommunityPass is ERC721, Ownable {
    //------------ STATE VARIABLES AND STRUCTS

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct Pass {
        string accessTier;
        string colorPattern;
        bool vip;
    }

    // exists property to cheaply check existence in map
    struct ColorPattern {
        string primary;
        string secondary;
        uint256 price;
        bool exists;
    }
    struct AccessTier {
        uint256 price;
        bool exists;
    }

    uint256 public immutable _supply;

    // mapping from access tier name (capitalized) => price
    mapping(string => AccessTier) public tiers;
    // mapping from color pattern name (capitalized) => price and hex values
    mapping(string => ColorPattern) public colors;
    // mapping from the tokenId => Pass attributes.
    mapping(uint256 => Pass) public passAttr;
    // mapping from the tokenId => timestamps
    mapping(uint256 => uint256) public timestamps;

    // renderer is stored as a separated contract so we can update it if we want to
    Renderer public renderer;

    // toggle to (de)activate minting
    bool private _saleActive;

    //------------ EVENTS

    event UpgradedTier(uint256 tokenId, string accessTier);

    //------------ INIT

    constructor(uint256 supply) ERC721("CommunityPass", "ACCESS") {
        _supply = supply;
        // increment ids so first token starts with #1
        // the increment will be considered regarding the supply in whenTokenLeft() modifier
        _tokenIds.increment();

        // set tiers and prices
        tiers["Diamond"] = AccessTier(0.2 ether, true);
        tiers["Premium"] = AccessTier(0.06 ether, true);
        tiers["Basic"] = AccessTier(0.03 ether, true);
        tiers["Demo"] = AccessTier(0 ether, true);

        // set colors and prices
        colors["Onyx"] = ColorPattern("#27272A", "#373757", 0 ether, true);
        colors["CreativeContracts"] = ColorPattern(
            "#4ADE80",
            "#14B8A5",
            0 ether,
            true
        );

        colors["Moonlight"] = ColorPattern(
            "#270060",
            "#2E47BD",
            0.03 ether,
            true
        );

        colors["Diamond"] = ColorPattern(
            "#06B89E",
            "#65B2D7",
            0.12 ether,
            true
        );
    }

    //------------ ADMIN FUNCTIONS

    function flipSaleStarted() external onlyOwner {
        _saleActive = !_saleActive;
    }

    // To update the render contract if needed
    // Prop is the address of the contract
    function setRenderer(Renderer _renderer) external onlyOwner {
        renderer = _renderer;
    }

    // Transfers the whole contract balance to the owner of the contract
    function withdrawAll() external {
        payable(owner()).transfer(address(this).balance);
    }

    //------------ PUBLIC FUNCTIONS

    function tokenURI(uint256 _tokenId)
        public
        view
        override
        whenTokenExists(_tokenId)
        returns (string memory)
    {
        string memory colorPattern = passAttr[_tokenId].colorPattern;
        return
            renderer.render(
                _tokenId,
                "DemoDAO",
                passAttr[_tokenId].accessTier,
                colorPattern,
                colors[colorPattern].primary,
                colors[colorPattern].secondary,
                passAttr[_tokenId].vip
            );
    }

    //------------ EXTERNAL FUNCTIONS

    function mintNFT(string calldata _accessTier, string calldata _colorPattern)
        external
        payable
        whenSaleActive
        whenTokenLeft
        whenMintFeeIncluded(_accessTier, _colorPattern)
        whenColorPatternExists(_colorPattern)
        whenTierExists(_accessTier)
        returns (uint256)
    {
        uint256 newItemId = _tokenIds.current();

        passAttr[newItemId] = Pass({
            accessTier: _accessTier,
            colorPattern: _colorPattern,
            vip: false
        });

        _safeMint(msg.sender, newItemId);
        timestamps[newItemId] = block.timestamp;
        _tokenIds.increment();

        return newItemId;
    }

    function upgradeTier(uint256 _tokenId, string calldata _accessTier)
        external
        payable
        whenOwnerOf(_tokenId)
        whenTierExists(_accessTier)
        whenTierUpgrade(_tokenId, _accessTier)
        whenUpgradeFeeIncluded(_tokenId, _accessTier)
    {
        passAttr[_tokenId].accessTier = _accessTier;
        emit UpgradedTier(_tokenId, passAttr[_tokenId].accessTier);
    }

    // If the nft has been held for x amount of time it will unlock the vip attribute
    // That way holder will be rewarded for holding the nft for longer
    // If the nft is transfered before the x amount of time the timestamp will get a reset
    function claimVipStatus(uint256 _tokenId)
        external
        whenOwnerOf(_tokenId)
        whenNotVip(_tokenId)
        when8WeeksHavePassed(_tokenId)
    {
        passAttr[_tokenId].vip = true;
    }

    //------------ INTERNAL FUNCTIONS

    //resets the timestamp if the nft hasn't claimed the vip status
    function _beforeTokenTransfer(
        address _from,
        address _to,
        uint256 _tokenId
    ) internal virtual override {
        super._beforeTokenTransfer(_from, _to, _tokenId);
        if (_from != address(0)) {
            if (!passAttr[_tokenId].vip) {
                timestamps[_tokenId] = block.timestamp;
            }
        }
    }

    function saleStarted() external view returns (bool) {
        return _saleActive;
    }

    //------------ MODIFIER

    modifier whenSaleActive() {
        require(_saleActive, "Sale is not active");
        _;
    }

    modifier whenTokenLeft() {
        require(_tokenIds.current() < _supply + 1, "No tokens left");
        _;
    }

    modifier whenColorPatternExists(string calldata colorPattern) {
        require(colors[colorPattern].exists, "Color pattern doesn't exist");
        _;
    }

    modifier whenTierExists(string calldata accessTier) {
        require(tiers[accessTier].exists, "Tier doesn't exist");
        _;
    }

    modifier whenMintFeeIncluded(
        string calldata accessTier,
        string calldata colorPattern
    ) {
        require(
            msg.value >= colors[colorPattern].price + tiers[accessTier].price,
            "Mint fee not included"
        );
        _;
    }

    modifier whenTokenExists(uint256 tokenId) {
        require(_exists(tokenId), "Requested token exists");
        _;
    }

    modifier whenOwnerOf(uint256 tokenId) {
        require(ownerOf(tokenId) == msg.sender, "Not your NFT");
        _;
    }

    modifier whenTierUpgrade(uint256 tokenId, string calldata accessTier) {
        require(
            tiers[passAttr[tokenId].accessTier].price <=
                tiers[accessTier].price,
            "You can't downgrade the token"
        );
        _;
    }

    modifier whenUpgradeFeeIncluded(
        uint256 tokenId,
        string calldata accessTier
    ) {
        require(
            msg.value >=
                tiers[accessTier].price -
                    tiers[passAttr[tokenId].accessTier].price,
            "Fee not included"
        );
        _;
    }

    modifier whenNotVip(uint256 tokenId) {
        require(!passAttr[tokenId].vip, "You already have VIP status");
        _;
    }

    modifier when8WeeksHavePassed(uint256 tokenId) {
        require(
            timestamps[tokenId] + 8 weeks <= block.timestamp,
            "8 haven't gone past"
        );
        _;
    }
}
