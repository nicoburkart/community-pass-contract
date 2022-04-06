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
        string memory vipColor = vip ? "#25FF42" : "#FF5B5B";

        string memory nftSVG = string(
            abi.encodePacked(
                "<svg width='100%' height='100%' viewBox='0 0 325 500' version='1.1' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' xml:space='preserve' xmlns:serif='http://www.serif.com/' style='fill-rule:evenodd;clip-rule:evenodd;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:1.5;'><g id='Background' transform='matrix(1.10392,0,0,1.18884,-30.6864,-47.2098)'><path d='M322.202,420.999C312.552,422.301 303.276,426.629 295.909,433.996C288.542,441.363 284.213,450.64 282.912,460.289L67.088,460.289C65.787,450.639 61.458,441.363 54.091,433.996C46.724,426.629 37.448,422.3 27.798,420.998L27.798,79.002C37.448,77.7 46.724,73.371 54.091,66.004C61.458,58.637 65.787,49.361 67.088,39.711L282.912,39.711C284.213,49.361 288.542,58.638 295.909,66.005C303.276,73.372 312.552,77.701 322.202,79.002L322.202,302.935C314.481,302.935 308.212,309.112 308.212,316.719C308.212,324.327 314.481,330.504 322.202,330.504L322.202,420.999ZM27.798,330.504C35.519,330.504 41.788,324.327 41.788,316.719C41.788,309.112 35.519,302.935 27.798,302.935L27.798,330.504Z' style='fill:url(#_Linear1);'/><path d='M322.202,420.999C312.552,422.301 303.276,426.629 295.909,433.996C288.542,441.363 284.213,450.64 282.912,460.289L67.088,460.289C65.787,450.639 61.458,441.363 54.091,433.996C46.724,426.629 37.448,422.3 27.798,420.998L27.798,79.002C37.448,77.7 46.724,73.371 54.091,66.004C61.458,58.637 65.787,49.361 67.088,39.711L282.912,39.711C284.213,49.361 288.542,58.638 295.909,66.005C303.276,73.372 312.552,77.701 322.202,79.002L322.202,302.935C314.481,302.935 308.212,309.112 308.212,316.719C308.212,324.327 314.481,330.504 322.202,330.504L322.202,420.999ZM319.938,419.219L319.938,332.453C312.064,331.376 305.947,324.765 305.947,316.719C305.947,308.674 312.064,302.063 319.938,300.986C319.938,300.986 319.938,80.782 319.938,80.782C310.5,79.122 301.494,74.681 294.249,67.436C287.023,60.21 282.589,51.229 280.949,41.814C280.949,41.814 69.051,41.814 69.051,41.814C67.411,51.228 62.977,60.209 55.751,67.435C48.506,74.68 39.5,79.122 30.062,80.781L30.062,300.987C37.936,302.063 44.053,308.674 44.053,316.719C44.053,324.764 37.936,331.376 30.062,332.452L30.062,419.219C39.5,420.878 48.506,425.32 55.751,432.565C62.977,439.791 67.411,448.772 69.051,458.186C69.051,458.186 280.949,458.186 280.949,458.186C282.589,448.772 287.023,439.791 294.249,432.565C301.494,425.32 310.5,420.879 319.938,419.219ZM27.798,330.504C35.519,330.504 41.788,324.327 41.788,316.719C41.788,309.112 35.519,302.935 27.798,302.935L27.798,330.504Z' style='fill:white;'/><g transform='matrix(4.24134,0,0,1,-148.815,0)'><path d='M46.519,316.624L106.175,316.624' style='fill:none;stroke:rgb(250,250,250);stroke-width:0.59px;stroke-dasharray:2.93,2.34,0,0;'/></g></g><g id='vip_status' transform='matrix(1,0,0,1,0,13.5248)'><g transform='matrix(1,0,0,1,16.3689,112.795)'><g transform='matrix(1,0,0,1,132.931,-46.4313)'><text x='91.539px' y='155.009px' style='font-family: SignPainter-HouseScript, SignPainter;font-size:30px;fill:white;'>Status</text></g><g transform='matrix(1,0,0,1,8.38654,-80.2467)'><circle cx='203.525' cy='179.861' r='4.822' style='fill:",
                vipColor,
                ";'/></g></g><g transform='matrix(1,0,0,1,129.938,31.3681)'><text x='139.956px' y='155.009px' style='font-family:Times-Roman, Times;font-size:20px;fill:rgb(223,223,223);'>VIP</text></g></g><g id='tier' transform='matrix(1,0,0,1,0,13.5248)'><g transform='matrix(1,0,0,1,-104.322,65.8355)'><text x='127.749px' y='155.009px' style='font-family:SignPainter-HouseScript, SignPainter;font-size:30px;fill:white;'>",
                accessTier,
                "</text></g><g transform='matrix(1,0,0,1,-104.698,31.3681)'><text x='127.749px' y='155.009px' style='font-family:Times-Roman, Times;font-size:20px;fill:rgb(223,223,223);'>TIER</text></g></g><g id='community_name' transform='matrix(1,0,0,1,6.74606,262.47)'><text x='86.914px' y='155.009px' style='font-family:Times-Roman, Times;font-size:30px;fill:rgb(223,223,223);'>",
                communityName,
                "</text></g><g transform='matrix(1,0,0,1,-87.2751,11.7772)'><g transform='matrix(56,0,0,56,129.518,110.938)'><path d='M0.954,-0.151C0.949,-0.158 0.942,-0.16 0.937,-0.151C0.899,-0.08 0.854,-0.015 0.814,-0.013C0.777,-0.011 0.764,-0.058 0.792,-0.115C0.816,-0.164 0.864,-0.23 0.883,-0.275C0.903,-0.323 0.895,-0.382 0.859,-0.383C0.827,-0.384 0.76,-0.337 0.713,-0.292C0.725,-0.336 0.708,-0.389 0.674,-0.39C0.638,-0.391 0.565,-0.332 0.52,-0.282C0.535,-0.321 0.538,-0.36 0.522,-0.386C0.516,-0.396 0.506,-0.396 0.5,-0.386C0.449,-0.305 0.384,-0.231 0.32,-0.23C0.322,-0.235 0.322,-0.241 0.322,-0.246C0.328,-0.32 0.298,-0.325 0.274,-0.356C0.253,-0.383 0.238,-0.392 0.207,-0.39C0.147,-0.386 0.086,-0.327 0.048,-0.26C0.003,-0.181 -0.012,-0.093 0.031,-0.035C0.071,0.019 0.122,0.02 0.158,0.008C0.232,-0.016 0.295,-0.12 0.315,-0.206C0.35,-0.203 0.38,-0.212 0.408,-0.231C0.379,-0.175 0.354,-0.124 0.344,-0.091C0.328,-0.041 0.333,-0.007 0.354,0.01C0.364,0.018 0.369,0.015 0.373,0.007C0.413,-0.087 0.461,-0.179 0.519,-0.242C0.583,-0.312 0.633,-0.339 0.643,-0.335C0.662,-0.327 0.555,-0.19 0.523,-0.107C0.496,-0.036 0.508,0.002 0.524,0.018C0.533,0.027 0.542,0.024 0.547,0.012C0.589,-0.081 0.638,-0.176 0.72,-0.258C0.784,-0.322 0.819,-0.335 0.827,-0.332C0.842,-0.326 0.753,-0.216 0.717,-0.132C0.682,-0.051 0.712,0.017 0.798,0.018C0.855,0.019 0.919,-0.033 0.947,-0.088C0.959,-0.112 0.959,-0.144 0.954,-0.151ZM0.258,-0.246C0.238,-0.263 0.231,-0.292 0.234,-0.313C0.238,-0.343 0.259,-0.348 0.264,-0.316C0.267,-0.298 0.264,-0.275 0.258,-0.246ZM0.25,-0.221C0.243,-0.195 0.231,-0.166 0.214,-0.135C0.165,-0.045 0.104,-0.008 0.077,-0.032C0.051,-0.055 0.064,-0.146 0.108,-0.221C0.13,-0.259 0.158,-0.293 0.185,-0.316C0.187,-0.277 0.215,-0.24 0.25,-0.221Z' style='fill:rgb(254,255,255);fill-rule:nonzero;'/></g><text x='103.646px' y='110.938px' style='font-family:SignPainter-HouseScript, SignPainter;font-size:56px;fill:rgb(254,255,255);'>Community Pass</text></g><g id='id' transform='matrix(1,0,0,1,-66.2823,206.113)'><text x='195.17px' y='110.938px' style='font-family:SignPainter-HouseScriptSemibold, SignPainter;font-size:36px;fill:white;'>#",
                Strings.toString(tokenId),
                "</text></g><defs><linearGradient id='_Linear1' x1='0' y1='0' x2='1' y2='0' gradientUnits='userSpaceOnUse' gradientTransform='matrix(2.7734e-14,420.578,-452.93,2.5753e-14,175,39.7109)'><stop offset='0' style='stop-color:",
                primaryColor,
                ";stop-opacity:1'/><stop offset='1' style='stop-color:",
                secondaryColor,
                ";stop-opacity:1'/></linearGradient></defs></svg>"
            )
        );

        /* string memory nftSvg = string(
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
        ); */

        // Get all the JSON metadata in place and base64 encode it.
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "Community Pass #',
                        Strings.toString(tokenId),
                        '", "description": "An example of how to create an NFT contract for communities.", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(nftSVG)),
                        '", "attributes": [{"trait_type": "Tier", "value": "',
                        accessTier,
                        '"}, {"trait_type": "Color Pattern", "value": "',
                        colorPatternName,
                        '"}, {"trait_type": "VIP Status", "value": ',
                        vip ? '"active"' : '"offline"',
                        "}]}"
                    )
                )
            )
        );

        tokenURI = string(
            abi.encodePacked("data:application/json;base64,", json)
        );
    }
}
