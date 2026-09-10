//
//  SavedCardCVVView.swift
//  PaymentSDK
//
//  Created by Concerto on 10/07/26.
//

import SwiftUI

struct SavedCardCVVView: View {

    let paymentResponse: InitiatePaymentResponse
    let paymentRequest: PaymentRequest

    @State private var cvv = ""

    var body: some View {

        VStack(spacing: 20) {

            Text("Saved Card")
                .font(.title2)
                .bold()

            Text(maskedCard)
                .font(.headline)

            TextField(
                "Enter CVV",
                text: $cvv
            )
            .keyboardType(.numberPad)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)

            Button("Pay Now") {
//               submitPayment()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .padding()
    }

    private var maskedCard: String {

        let token =
            paymentRequest.tokenization.cardToken

        guard token.count >= 4 else {
            return "Saved Card"
        }

        let last4 = token.suffix(4)

        return "XXXX XXXX XXXX \(last4)"
    }

//    private func submitPayment() {
//
//        let request = SubmitPaymentRequest(
//
//            referenceId:
//                paymentResponse.transactionId,
//
//            customerIp: "10.10.8.222",
//
//            amount:
//                paymentRequest.amount,
//
//            currency:
//                paymentRequest.currency,
//
//            cardTokenFlag: "Y",
//
////            paymentInstrument:
////                SubmitPaymentInstrument(
////                    paymentMethod: "CCI"
////                ),
//
//            card: Card(
//                number:
//                    paymentRequest.tokenization.cardToken,
//                cvv: cvv,
//                expiryMonth: "",
//                expiryYear: ""
//            ),
//
//            customer:
//                SubmitCustomer(
//                    cardHolderName: "",
//                    customerEmail:
//                        paymentRequest.customer.customerEmail
//                ),
//
////            browserDetails:
////                BrowserDetails.current()
//        )
//
//        InAppSDK.shared.submitPayment(
//            request: request
//        )
//    }
}
