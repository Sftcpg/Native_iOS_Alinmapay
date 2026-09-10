//
//  CardPaymentView.swift
//  PaymentSDK
//
//  Created by Concerto on 25/06/26.
//

import SwiftUI



struct CardPaymentView: View {

    
    @Binding var cardDetails: CardDetails
    
//    @State private var cardNumber = ""
//    @State private var expiryMonth = ""
//    @State private var expiryYear = ""
//    @State private var cvv = ""
//    @State private var cardHolderName = ""

    var body: some View {

        VStack(alignment: .leading, spacing: 5) {

            // MARK: Card Logos

//            HStack {
//
//                Spacer()
//
//                Image("visa")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 45, height: 30)
//
//                Image("mastercard")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 45, height: 30)
//
//                Image("amex")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 45, height: 30)
          //  }

            // MARK: Card Number

            Text("Card Number")
                .font(.headline)

            TextField("Card Number", text: $cardDetails.cardNumber)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
                .onChange(of: cardDetails.cardNumber) { value in

                    cardDetails.cardNumber = value.filter { $0.isNumber }

                    if cardDetails.cardNumber.count > 18 {
                        cardDetails.cardNumber = String(cardDetails.cardNumber.prefix(18))
                    }
                }

            // MARK: Expiry & CVV

            HStack(spacing: 15) {

                VStack(alignment: .leading) {

                    Text("Expiry")

                    HStack {

                        TextField("MM", text: $cardDetails.expiryMonth)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                            .onChange(of: cardDetails.expiryMonth) { value in

                                cardDetails.expiryMonth = value.filter { $0.isNumber }

                                if cardDetails.expiryMonth.count > 2 {
                                    cardDetails.expiryMonth = String(cardDetails.expiryMonth.prefix(2))
                                }

                                if let month = Int(cardDetails.expiryMonth),
                                   month > 12 {

                                    cardDetails.expiryMonth = "12"
                                }
                            }

                        Text("/")

                        TextField("YYYY", text: $cardDetails.expiryYear)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                            .onChange(of: cardDetails.expiryYear) { value in

                                cardDetails.expiryYear = value.filter { $0.isNumber }

                                if cardDetails.expiryYear.count > 4 {
                                    cardDetails.expiryYear = String(cardDetails.expiryYear.prefix(4))
                                }
                            }
                           
                    }
                }

                VStack(alignment: .leading) {

                    Text("CVV")

                    SecureField("CVV", text: $cardDetails.cvv)
                        .keyboardType(.numberPad)
                        .onChange(of: cardDetails.cvv) { value in

                            cardDetails.cvv = value.filter { $0.isNumber }

                            if cardDetails.cvv.count > 4 {
                                cardDetails.cvv = String(cardDetails.cvv.prefix(4))
                            }
                        }
                        .textFieldStyle(.roundedBorder)
                }
            }

            // MARK: Card Holder

            Text("Cardholder Name")
                .font(.headline)

            TextField("Cardholder Name", text: $cardDetails.cardHolderName)
                .textFieldStyle(.roundedBorder)
                .onChange(of: cardDetails.cardHolderName) { value in

                    cardDetails.cardHolderName = value.filter {

                        $0.isLetter ||
                        $0.isWhitespace
                    }

                    if cardDetails.cardHolderName.count > 50 {
                        cardDetails.cardHolderName = String(cardDetails.cardHolderName.prefix(50))
                    }
                }
               

        }
        .padding(15)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
        )
        .cornerRadius(12)
    }
}
	
