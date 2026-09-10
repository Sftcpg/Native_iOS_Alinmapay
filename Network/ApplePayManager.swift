//
//  ApplePayManager.swift
//  PaymentSDK
//
//  Created by Concerto on 07/07/26.
//

import Foundation
import PassKit

final class ApplePayManager: NSObject {
    
    static let shared = ApplePayManager()
    
    var paymentKey = ""
    
    var merchantPaymentRequest: PaymentRequestData?
    var onPaymentKeyGenerated: ((String) -> Void)?
    
    func startApplePay(request: PaymentRequestData) {
        
        self.merchantPaymentRequest = request
        
        let payRequest = PKPaymentRequest()
        
        payRequest.merchantIdentifier = "merchant.com"
        
        payRequest.countryCode = merchantPaymentRequest?.countryCode ?? "SA"
        
        payRequest.currencyCode = merchantPaymentRequest?.currency ?? "SAR"
        
        payRequest.supportedNetworks = [
            .visa,
            .masterCard,
            .amex
        ]
        
        payRequest.merchantCapabilities = .capability3DS
        
        payRequest.paymentSummaryItems = [
            
            PKPaymentSummaryItem(
                label: "Payment",
                amount: NSDecimalNumber(
                    string: merchantPaymentRequest?.amount ?? "0.00"
                )
            )
            
        ]
        
        let controller = PKPaymentAuthorizationController(
            paymentRequest: payRequest
        )
        
        controller.delegate = self   // ← This is why Apple calls the delegate methods
        
        controller.present { presented in
            
            print("Apple Pay Presented : \(presented)")
        }
    }
}

extension ApplePayManager: PKPaymentAuthorizationControllerDelegate {

    func paymentAuthorizationController(
        _ controller: PKPaymentAuthorizationController,
        didAuthorizePayment payment: PKPayment,
        handler completion: @escaping (PKPaymentAuthorizationResult) -> Void
    ) {

        print("Apple Pay Authorized")

        let paymentKey = ApplePayUtility.generatePaymentKey(
            payment: payment
        )

        self.paymentKey = paymentKey

        print("Payment Key")
        print(paymentKey)

        // Send PaymentToken back to InAppSDK
          self.onPaymentKeyGenerated?(paymentKey)
        
        completion(
            PKPaymentAuthorizationResult(
                status: .success,
                errors: nil
            )
        )

//        controller.dismiss {
//            
//            
//            DispatchQueue.main.async {
//
//                    guard let request = self.merchantPaymentRequest else {
//                        return
//                    }
//
////                    SDKNavigator.shared.openApplePayBottomSheet(
////                        request: request
////                    )
////                
//                self.submitApplePay()
//                }
//        }
    }

    func paymentAuthorizationControllerDidFinish(
        _ controller: PKPaymentAuthorizationController
    ) {

        controller.dismiss()
    }
    
    
    private func submitApplePay() {

        guard let request = merchantPaymentRequest else {
            return
        }

        print("Apple Pay API call")
        print("Apple Pay Amount \(request.amount)")
        print("===== Apple Pay REQUEST =====")
    
     
    }
    
}
