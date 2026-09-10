//
//  ApplePayBottomSheet.swift
//  PaymentSDK
//
//  Created by Concerto on 07/07/26.
//
import SwiftUI

struct ApplePayBottomSheet: View {
    
    let paymentRequest: PaymentRequest
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var isLoading = false
    
    var body: some View {
        
        VStack(spacing: 25) {
            
            Image(systemName: "applelogo")
                .font(.system(size: 45))
            
            Text("Apple Pay")
                .font(.title2)
                .bold()
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                
                HStack {
                    
                    Text("Amount")
                    
                    Spacer()
                    
                    Text("\(paymentRequest.currency) \(paymentRequest.amount)")
                        .bold()
                }
                
                HStack {
                    
                    Text("Order ID")
                    
                    Spacer()
                    
                    Text(paymentRequest.order.orderId)
                }
                
            }
            
            Divider()
            
            Button {
                
                submitApplePayment()
                
            } label: {
                
                if isLoading {
                    
                    ProgressView()
                    
                } else {
                    
                    Text("PAY")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                }
                
            }
            .background(Color.black)
            .cornerRadius(12)
            
            Button {
                
                dismiss()
                
            } label: {
                
                Text("Cancel")
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .overlay(
                        
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.red)
                        
                    )
                
            }
            
        }
        .padding()
    }
    
    
    private func submitApplePayment() {
        
//        guard let request = ApplePayManager.shared.paymentRequest else {
//            return
//        }
        
        print(" Click of Submit Button")
//        let submitRequest = ApplePaySubmitRequest(
//            
//            referenceId: request.referenceId,
//            
//            amount: request.amount,
//            
//            currency: request.currency,
//            
//            paymentInstrument: ApplePayInstrument(
//                paymentMethod: "APPLEPAY"
//            ),
//            
//            paymentKey: ApplePayManager.shared.paymentKey
//            
//        )
//        
//        InAppSDK.shared.submitApplePay(
//            request: submitRequest
//        )
    }
}
