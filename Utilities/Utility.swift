import Foundation

import CommonCrypto

struct Utility {

    static func generateSignature(
        orderId: String,
        terminalId: String,
        password: String,
        merchantKey: String,
        amount: String,
        currency: String
    ) -> String {

        let data = "\(orderId)|\(terminalId)|\(password)|\(merchantKey)|\(amount)|\(currency)"

        print("Signature Data : \(data)")

        return sha256(str: data)
    }

    static func sha256(str: String) -> String {

        guard let strData = str.data(using: .utf8) else {
            return ""
        }

        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))

        strData.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, UInt32(strData.count), &digest)
        }

        return digest.map { String(format: "%02x", $0) }.joined()
    }
    
    

}
