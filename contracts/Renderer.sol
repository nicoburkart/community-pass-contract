//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import {Base64} from "./libraries/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

//This is a seperate contract so we can update it seperatly from the main contract if needed.
contract Renderer {
    function render(
        uint256 tokenId,
        string memory communityName,
        string memory accessTier,
        string memory colorPatternName,
        string memory primaryColor,
        string memory secondaryColor,
        bool vip
    ) public pure returns (string memory tokenURI) {
        string memory vipColor = vip ? "#25FF42" : "#E60000";

        string memory nftSvg = string(
            abi.encodePacked(
                "<svg width='100%' height='100%' viewBox='0 0 500 260' version='1.1' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' xml:space='preserve' xmlns:serif='http://www.serif.com/' style='fill-rule:evenodd;clip-rule:evenodd;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:1.5;'>",
                "<g id='Card' transform='matrix(1.04142,0,0,0.937898,-6.75044,-6.80654)'><path d='M486.597,21.31C486.597,13.554 480.926,7.257 473.94,7.257L19.138,7.257C12.153,7.257 6.482,13.554 6.482,21.31L6.482,270.419C6.482,278.176 12.153,284.473 19.138,284.473L473.94,284.473C480.926,284.473 486.597,278.176 486.597,270.419L486.597,21.31Z' style='fill:url(#_Linear1);'/></g><g id='Border' transform='matrix(1.01939,0,0,0.908103,-1.31883,-2.46037)'><path d='M486.597,21.31C486.597,13.554 480.987,7.257 474.078,7.257L19.001,7.257C12.092,7.257 6.482,13.554 6.482,21.31L6.482,270.419C6.482,278.176 12.092,284.473 19.001,284.473L474.078,284.473C480.987,284.473 486.597,278.176 486.597,270.419L486.597,21.31Z' style='fill:none;stroke:url(#_Linear2);stroke-width:1.04px;'/></g><g id='Divider' transform='matrix(1,0,0,1,0,24.7121)'><path d='M5.714,130L494.28,130' style='fill:none;stroke:url(#_Linear3);stroke-width:1px;stroke-linecap:butt;'/></g><g id='NFT-Name' transform='matrix(1,0,0,1,-101.214,-27.9044)'><text x='132.888px' y='103.174px' style='font-family:Arial-BoldMT, Arial, sans-serif;font-weight:700;font-size:30px;fill:white;'>Community Pass #",
                Strings.toString(tokenId),
                "</text></g>",
                "<g id='Community-Name' transform='matrix(1,0,0,1,-101.028,1.83238)'><text x='132.888px' y='103.174px' style='font-family: ArialMT, Arial, sans-serif;font-size:16px;fill:white;'>",
                communityName,
                "</text></g>",
                "<g id='Tier-Label' transform='matrix(1,0,0,1,-99.7931,93.2012)'><text x='132.888px' y='103.174px' style='font-family:Arial-BoldMT, Arial, sans-serif;font-weight:700;font-size:14px;fill:white;'>ACCESS TIER</text></g><g id='Tier-Value' transform='matrix(1,0,0,1,-100.719,116.139)'><text x='132.888px' y='103.174px' style='font-family:ArialMT, Arial, sans-serif;font-size:12px;fill:white;'>",
                accessTier,
                "</text></g>",
                "<g id='VIP-Value' transform='matrix(1,0,0,1,285.666,116.076)'><text x='147.767px' y='103.174px' style='font-family:ArialMT, Arial, sans-serif;font-size:12px;fill:white;'>Status</text></g><g id='VIP-Label' transform='matrix(1,0,0,1,271.259,93.379)'><text x='107.073px' y='103.174px' style='font-family:Arial-BoldMT, Arial, sans-serif;font-weight:700;font-size:14px;fill:white;'>VIP MEMBER</text></g><g id='Status-Indicator' transform='matrix(1.5,0,0,1.5,-206.72,-104.147)'><circle cx='421.756' cy='212.735' r='2.221' style='fill:",
                vipColor,
                ";'/><path d='M421.756,210.181C420.347,210.181 419.202,211.325 419.202,212.735C419.202,214.144 420.347,215.289 421.756,215.289C423.166,215.289 424.31,214.144 424.31,212.735C424.31,211.325 423.166,210.181 421.756,210.181ZM421.756,210.514C422.982,210.514 423.977,211.509 423.977,212.735C423.977,213.96 422.982,214.955 421.756,214.955C420.531,214.955 419.535,213.96 419.535,212.735C419.535,211.509 420.531,210.514 421.756,210.514Z' style='fill:white;'/></g>",
                "<defs><linearGradient id='_Linear1' x1='0' y1='0' x2='1' y2='0' gradientUnits='userSpaceOnUse' gradientTransform='matrix(480.115,-9.09108e-14,6.87349e-14,447.554,6.48198,145.865)'><stop offset='0' style='stop-color:",
                primaryColor,
                ";stop-opacity:1'/><stop offset='0.5' style='stop-color:",
                secondaryColor,
                ";stop-opacity:1'/><stop offset='1' style='stop-color:",
                primaryColor,
                ";stop-opacity:1'/></linearGradient><linearGradient id='_Linear2' x1='0' y1='0' x2='1' y2='0' gradientUnits='userSpaceOnUse' gradientTransform='matrix(480.115,0,0,277.216,6.48198,145.865)'><stop offset='0' style='stop-color:white;stop-opacity:0.3'/><stop offset='0.37' style='stop-color:white;stop-opacity:1'/><stop offset='0.67' style='stop-color:white;stop-opacity:1'/><stop offset='1' style='stop-color:white;stop-opacity:0.3'/></linearGradient><linearGradient id='_Linear3' x1='0' y1='0' x2='1' y2='0' gradientUnits='userSpaceOnUse' gradientTransform='matrix(489.422,0,0,2e-06,5.28881,130)'><stop offset='0' style='stop-color:white;stop-opacity:0.3'/><stop offset='0.37' style='stop-color:white;stop-opacity:1'/><stop offset='0.67' style='stop-color:white;stop-opacity:1'/><stop offset='1' style='stop-color:white;stop-opacity:0.3'/></linearGradient></defs></svg>"
            )
        );

        // Get all the JSON metadata in place and base64 encode it.
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "Community NFT #',
                        Strings.toString(tokenId),
                        '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(nftSvg)),
                        '", "attributes": [ { "trait_type": "AccessTier", "value": ',
                        accessTier,
                        '}, { "trait_type": "Color", "value": ',
                        colorPatternName,
                        "} ]}"
                    )
                )
            )
        );

        tokenURI = string(
            abi.encodePacked("data:application/json;base64,", json)
        );
    }
}
