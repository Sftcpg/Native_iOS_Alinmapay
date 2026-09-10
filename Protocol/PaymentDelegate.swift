//
//  PaymentDelegate.swift
//  PaymentSDK
//
//  Created by Concerto on 18/06/26.
//

public protocol PaymentDelegate: AnyObject {

    /// Payment completed successfully
    func paymentDidSucceed(response: SubmitPaymentResponse)

       /// Payment failed
    func paymentDidFail(response: SubmitPaymentResponse)

       /// User cancelled payment
       func paymentDidCancel()
}
