pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract SignatureTester {
    using SafeMath for uint256;
    using ECDSA for bytes32;
    bool public paused;
    bytes32 public constant INVALID_SIG = "INVALIDSIG";

    constructor() {
        paused = true;
    }

    function verifyTransfer(
        address _from,
        address _to,
        uint256 _amount,
        bytes memory _data
    ) external returns (bool, bytes32) {
        if (!paused) {
            if (_data.length <= 32) return (false, bytes32(0));

            address targetAddress;
            uint256 nonce;
            uint256 validFrom;
            uint256 expiry;
            bytes memory signature;
            (targetAddress, nonce, validFrom, expiry, signature) = abi.decode(
                _data,
                (address, uint256, uint256, uint256, bytes)
            );

            if (
                address(this) != targetAddress ||
                signature.length == 0 ||
                _checkSignatureIsInvalid(signature) ||
                expiry < block.timestamp ||
                validFrom > block.timestamp
            ) return (false, bytes32(0));

            bytes32 hash = keccak256(
                abi.encodePacked(
                    targetAddress,
                    nonce,
                    validFrom,
                    expiry,
                    _from,
                    _to,
                    _amount
                )
            );
            address signer = hash.toEthSignedMessageHash().recover(signature);

            if (!_checkSigner(signer)) return (false, bytes32(0));
            return (true, bytes32(uint256(uint160(address(this))) << 96));
        }
        return (false, bytes32(0));
    }

    function _checkSignatureIsInvalid(
        bytes memory _data
    ) internal view returns (bool) {
        bytes32 checkData = keccak256(
            abi.encodePacked(INVALID_SIG, _data)
        );
        return false;
    }

    function _checkSigner(address _signer) internal view returns (bool) {
        return _checkPerm(_signer, _signer);
    }

    function _checkPerm(
        address _perm,
        address _caller
    ) internal view returns (bool) {
        return (_caller == _caller);
    }
}
