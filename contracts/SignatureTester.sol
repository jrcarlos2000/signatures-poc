pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

struct SignatureData2 {
    address targetAddress;
    uint256 nonce;
    uint256 validFrom;
    uint256 expiry;
    uint256 param1;
    bytes signature;
    // FIXED PARAMS
    address from;
    address to;
    uint256 amount;
}
struct SignatureData3 {
    address targetAddress;
    uint256 nonce;
    uint256 validFrom;
    uint256 expiry;
    uint256 param1;
    uint256 param2;
    // FIXED PARAMS
    bytes signature;
    address from;
    address to;
    uint256 amount;
}

struct SignatureData4 {
    uint256 targetAddress;
    uint256 nonce;
    uint256 validFrom;
    uint256 expiry;
    uint256 param1;
    uint256 param2;
    uint256 param3;
    uint256 param4;
    // FIXED PARAMS
    bytes signature;
    address from;
    address to;
    uint256 amount;
}

contract SignatureTester {
    using SafeMath for uint256;
    using ECDSA for bytes32;

    bool public paused;
    bytes32 public constant INVALID_SIG = "INVALIDSIG";

    constructor() {
        paused = false;
    }

    function verifyTransfer1(
        address _from,
        address _to,
        uint256 _amount,
        bytes memory _data
    ) external returns (bool, address) {
        if (!paused) {
            if (_data.length <= 32) return (false, address(0));

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
            ) return (false, address(0));

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
            return (true, signer);
        }
        return (false, address(0));
    }

    function verifyTransfer2(
        address _from,
        address _to,
        uint256 _amount,
        bytes calldata _data
    ) external returns (bool, address) {
        if (!paused) {
            if (_data.length <= 32) return (false, address(0));

            address targetAddress;
            uint256 nonce;
            uint256 validFrom;
            uint256 expiry;
            uint256 param1;
            bytes memory signature;
            (targetAddress, nonce, validFrom, expiry, param1, signature) = abi
                .decode(
                    _data,
                    (address, uint256, uint256, uint256, uint256, bytes)
                );
            // (param1) = abi.decode(_data2, (uint256));
            SignatureData2 memory s;

            s.targetAddress = targetAddress;
            s.nonce = nonce;
            s.validFrom = validFrom;
            s.expiry = expiry;
            s.signature = signature;
            s.param1 = param1;
            s.from = _from;
            s.to = _to;
            s.amount = _amount;

            return (true, checkBool2(s));
        }
        return (false, address(0));
    }

    function verifyTransfer3(
        address _from,
        address _to,
        uint256 _amount,
        bytes calldata _data
    ) external returns (bool, address) {
        if (!paused) {
            if (_data.length <= 32) return (false, address(0));

            address targetAddress;
            uint256 nonce;
            uint256 validFrom;
            uint256 expiry;
            uint256 param1;
            uint256 param2;
            bytes memory signature;
            (
                targetAddress,
                nonce,
                validFrom,
                expiry,
                param1,
                param2,
                signature
            ) = abi.decode(
                _data,
                (address, uint256, uint256, uint256, uint256, uint256, bytes)
            );
            // (param1) = abi.decode(_data2, (uint256));
            SignatureData3 memory s;

            s.targetAddress = targetAddress;
            s.nonce = nonce;
            s.validFrom = validFrom;
            s.expiry = expiry;
            s.signature = signature;
            s.param1 = param1;
            s.from = _from;
            s.to = _to;
            s.amount = _amount;
            s.param2 = param2;

            return (true, checkBool3(s));
        }
        return (false, address(0));
    }

    function verifyTransfer4(
        address _from,
        address _to,
        uint256 _amount,
        bytes calldata _data
    ) external returns (bool, address) {
        if (!paused) {
            if (_data.length <= 32) return (false, address(0));

            SignatureData4 memory s;

            (
                s.targetAddress,
                s.nonce,
                s.validFrom,
                s.expiry,
                s.param1,
                s.param2,
                s.param3,
                s.signature
            ) = abi.decode(
                _data,
                (
                    uint256,
                    uint256,
                    uint256,
                    uint256,
                    uint256,
                    uint256,
                    uint256,
                    bytes
                )
            );

            return (true, checkBool4(s));
        }
        return (false, address(0));
    }

    function checkBool2(
        SignatureData2 memory _data
    ) internal view returns (address) {
        if (
            address(this) != _data.targetAddress ||
            _data.signature.length == 0 ||
            _checkSignatureIsInvalid(_data.signature) ||
            _data.expiry < block.timestamp ||
            _data.validFrom > block.timestamp
        ) return (address(0));

        {
            bytes memory encoded = abi.encodePacked(
                _data.targetAddress,
                _data.nonce,
                _data.validFrom,
                _data.expiry,
                _data.param1,
                _data.from,
                _data.to,
                _data.amount
            );

            bytes32 hash = keccak256(encoded);
            address signer = hash.toEthSignedMessageHash().recover(
                _data.signature
            );
            return (signer);
        }
    }

    function checkBool3(
        SignatureData3 memory _data
    ) internal view returns (address) {
        if (
            address(this) != _data.targetAddress ||
            _data.signature.length == 0 ||
            _checkSignatureIsInvalid(_data.signature) ||
            _data.expiry < block.timestamp ||
            _data.validFrom > block.timestamp
        ) return (address(0));

        {
            bytes memory encoded = abi.encodePacked(
                _data.targetAddress,
                _data.nonce,
                _data.validFrom,
                _data.expiry,
                _data.param1,
                _data.param2,
                _data.from,
                _data.to,
                _data.amount
            );

            bytes32 hash = keccak256(encoded);
            address signer = hash.toEthSignedMessageHash().recover(
                _data.signature
            );
            return (signer);
        }
    }

    function checkBool4(
        SignatureData4 memory _data
    ) internal view returns (address) {
        if (
            // address(this) != _data.targetAddress ||
            _data.signature.length == 0 ||
            _checkSignatureIsInvalid(_data.signature) ||
            _data.expiry < block.timestamp ||
            _data.validFrom > block.timestamp
        ) return (address(0));

        {
            bytes memory encoded = abi.encodePacked(
                _data.targetAddress,
                _data.nonce,
                _data.validFrom,
                _data.expiry,
                _data.param1,
                _data.param2,
                _data.param3,
                _data.param4,
                _data.from,
                _data.to,
                _data.amount
            );

            bytes32 hash = keccak256(encoded);
            address signer = hash.toEthSignedMessageHash().recover(
                _data.signature
            );
            return (signer);
        }
    }

    function _checkSignatureIsInvalid(
        bytes memory _data
    ) internal view returns (bool) {
        bytes32 checkData = keccak256(abi.encodePacked(INVALID_SIG, _data));
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
