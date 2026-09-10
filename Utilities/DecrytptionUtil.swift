//
//  DecrytptionUtil.swift
//  PaymentSDK
//
//  Created by Concerto on 03/07/26.
//

import Foundation
import CommonCrypto

class DecryptionUtil {

    static func decodeAndDecryptV2(encryptedResponse: String, merKey: String) throws -> String {
        //print(encryptedResponse)
        //print(merKey)
        // Convert the hex key string to a byte array
        let secretKeyBytes = try hexStringToByteArray(merKey)
        if secretKeyBytes.count != 32 {
            throw NSError(domain: "DecryptionError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Key must be 32 bytes for AES-256"])
        }
        // Convert to Base64
        let base64String = secretKeyBytes.base64EncodedString()
        print("Secret Key (Base64): \(base64String)")
        //let base64String = Data(encryptedResponse).base64EncodedString()
        let encryptedResponse = encryptedResponse.trimmingCharacters(in: .whitespacesAndNewlines)

        // Decode the Base64-encoded encrypted response
        guard let decodedCipherText = Data(base64Encoded: encryptedResponse) else {
            throw NSError(domain: "DecryptionError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid Base64 encoding"])
        }

        // Initialize the cipher for AES-256-ECB decryption
        let decryptedData = try aesDecrypt(data: decodedCipherText, key: secretKeyBytes)
        print(decryptedData)
        // Update to check for valid string
        if let decryptedString = String(data: decryptedData, encoding: .utf8) {
            return decryptedString
        } else {
            print("Decrypted Data (Hex): \(decryptedData.map { String(format: "%02x", $0) }.joined())")
            throw NSError(domain: "DecryptionError", code: 3, userInfo: [NSLocalizedDescriptionKey: "Failed to decode decrypted data to UTF-8"])
        }
    }

    private static func aesDecrypt(data: Data, key: Data) throws -> Data {
        var decryptedBytes = [UInt8](repeating: 0, count: data.count)
        var numBytesDecrypted: size_t = 0

        let status = CCCrypt(
            CCOperation(kCCDecrypt),
            CCAlgorithm(kCCAlgorithmAES),
            CCOptions(kCCOptionECBMode | kCCOptionPKCS7Padding),
            key.bytes, kCCKeySizeAES256,
            nil,
            data.bytes, data.count,
            &decryptedBytes, decryptedBytes.count,
            &numBytesDecrypted
        )

        if status == kCCSuccess {
            return Data(bytes: decryptedBytes, count: numBytesDecrypted)
        } else {
            throw NSError(domain: "DecryptionError", code: 4, userInfo: [NSLocalizedDescriptionKey: "AES decryption failed with status \(status)"])
        }
    }

    


    private static func hexStringToByteArray(_ hexString: String) throws -> Data {
        var data = Data(capacity: hexString.count / 2)
        var index = hexString.startIndex
        while index < hexString.endIndex {
            let byteString = String(hexString[index...hexString.index(index, offsetBy: 1)])
            if let byte = UInt8(byteString, radix: 16) {
                data.append(byte)
            } else {
                throw NSError(domain: "DecryptionError", code: 5, userInfo: [NSLocalizedDescriptionKey: "Invalid hex string"])
            }
            index = hexString.index(index, offsetBy: 2)
        }
        return data
    }
    
    
}

extension Data {
    var bytes: [UInt8] {
        return [UInt8](self)
    }
}
