//
//  PaymentViewModel.swift
//  PaymentSDK
//
//  Created by Concerto on 03/07/26.
//
import Foundation
import Combine
import PaymentSDK

final class PaymentViewModel: ObservableObject, PaymentDelegate {

    @Published var message = ""

    func paymentDidSucceed(response: SubmitPaymentResponse) {
        DispatchQueue.main.async {
            self.message = "Payment Success"
        }
    }

    func paymentDidFail(response: SubmitPaymentResponse) {
        DispatchQueue.main.async {
            self.message = response.responseDescription ?? "Payment Failed"
        }
    }

    func paymentDidCancel() {
        DispatchQueue.main.async {
            self.message = "Payment Cancelled"
        }
    }
}
