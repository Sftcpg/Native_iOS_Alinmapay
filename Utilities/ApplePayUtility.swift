import Foundation
import PassKit

public final class ApplePayUtility {

    public static func generatePaymentKey(
        payment: PKPayment
    ) -> String {

        let paymentDataBase64 = payment.token.paymentData.base64EncodedString()

        let method = payment.token.paymentMethod

        let payload: [String: Any] = [

            "paymentData": paymentDataBase64,

            "paymentMethod": [

                "displayName": method.displayName ?? "",
                "network": method.network?.rawValue ?? "",
                "type": "debit"

            ],

            "transactionIdentifier":
                payment.token.transactionIdentifier

        ]

        guard
            let jsonData = try? JSONSerialization.data(withJSONObject: payload),
            let jsonString = String(data: jsonData, encoding: .utf8)
        else {
            return ""
        }

        return jsonString
    }

}
