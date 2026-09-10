//
//  InitiatePaymentMapper.swift
//  PaymentSDK
//
//  Created by Concerto on 10/07/26.
//

import Foundation

extension InitiatePaymentResponse {

    func toPaymentResult(rawJson: String) -> PaymentResult {

        return PaymentResult(
            rawJson: rawJson,
            
            transactionId: transactionId,
            transactionDateTime: nil,
            result: result,
            responseCode: responseCode,
            responseDescription: responseDescription,
            orderId: orderDetails.orderId,
            amount: amountDetails?.amount,
            originalAmount: amountDetails?.originalAmount,
            paymentMethod: nil,
            maskedCard: nil,
            cardBrand: nil,
            cardToken: tokenizationDetails?.cardToken,
            cardHolderName: nil,
            signature: nil,
            terminalId: nil
        )
    }
}
