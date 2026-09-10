//
//  SubmitPaymentMapper.swift
//  PaymentSDK
//
//  Created by Concerto on 06/07/26.
//

import Foundation

extension SubmitPaymentResponse {

    func toPaymentResult(rawJson: String) -> PaymentResult {

        return PaymentResult(
            rawJson: rawJson,
            transactionId: transactionId,
            transactionDateTime: transactionDateTime,

            result: result,
            responseCode: responseCode,
            responseDescription: responseDescription,

            orderId: orderDetails?.orderId,

            amount: amountDetails?.amount,
            originalAmount: amountDetails?.originalAmount,

            paymentMethod: paymentMethod,

            maskedCard: cardDetails?.maskedCard,
            cardBrand: cardDetails?.cardBrand,
            cardToken: tokenization?.cardToken ,

            cardHolderName: customerDetails?.cardHolderName,

            signature: signature,
            terminalId: terminalId
        )
    }
}
