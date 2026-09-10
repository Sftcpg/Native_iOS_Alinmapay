
import SwiftUI
import PaymentSDK

struct ContentView: View {

    @State private var paymentMessage = ""

    @State private var selectedTransactionType = "Purchase"
    @State private var selectedOperation = "Update"

    @State private var userAmount = ""
    @State private var userData = ""
    @State private var userEmail = ""
    @State private var transactionId = ""
    @State private var orderId = ""
    @State private var cardToken = ""
    @State private var applePayMerchantId = ""

    let transactionTypes = [
        "Purchase",
        "PreAuth",
        "Tokenization",
        "Transaction Enquiry"
        
    ]

    let cardOperations = [
        "Add",
        "Update",
        "Delete"
    ]
//If LOGO
    
    let branding = SDKMerchantBranding.logo(
        UIImage(named: "merchantlogo")!
    )
    // IF Text
    
//    let branding = SDKMerchantBranding.text("ABC Store")
    // MARK: Theme

    private var sdkTheme : SDKTheme {
        SDKTheme(
            primaryColor: .black,
            
            
            merchantBranding: branding,
            backgroundColor: .white,// Appy this Background color not edit apply to page
            
            textColor: .brown,//Appy tp Label
            buttonTextColor: .red, // Remove this and check
            
            borderColor: .gray, // Check what is this
           
            primaryButtonStyle: SDKButtonStyle(
                backgroundColor: .blue,
                textColor: .orange,
                cornerRadius: 5,
                
                height: 35
            ),
            labelStyle: SDKTextStyle( color: .brown, height: 26, isBold: true),
            inputStyle: SDKInputStyle(backgroundColor: Color.white, borderColor: Color.black, borderWidth: 1, cornerRadius: 15)
            
            //        editStyle: SDKTex
            
            
            
        )
    }

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 12) {

                // MARK: Logo

                if let logo = sdkTheme.logo {

                    Image(uiImage: logo)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 70)
                        .frame(maxWidth: .infinity)
                }

                // MARK: Header

                Text("Payment SDK Demo")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(
                        sdkTheme.textColor
                    )

                // MARK: Transaction Type

                label("Transaction Type")

                Picker(
                    "Transaction Type",
                    selection: $selectedTransactionType
                ) {
                    ForEach(
                        transactionTypes,
                        id: \.self
                    ) {
                        Text($0)
                    }
                }
                .pickerStyle(.menu)
                .padding()
                .frame(maxWidth: .infinity,maxHeight: 30)
                .background(
                    Color.gray.opacity(0.1)
                )
                .cornerRadius(
                    sdkTheme.inputStyle.cornerRadius
                )

                // MARK: Tokenization

                if selectedTransactionType == "Tokenization" {

                    label("Card Operation")

                    Picker(
                        "Card Operation",
                        selection: $selectedOperation
                    ) {
                        ForEach(
                            cardOperations,
                            id: \.self
                        ) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding()
                    .frame(maxWidth: .infinity,maxHeight: 30)
                    .background(
                        Color.gray.opacity(0.1)
                    )
                    .cornerRadius(
                        sdkTheme.inputStyle.cornerRadius
                    )

                   
                }

                SDKLabelField(title: "Card Token", textStyle: sdkTheme.labelStyle , width: 100)

                SDKTextField(
                    title: "Enter Card Token",
                 
                    text: $cardToken,
                    style : sdkTheme.inputStyle
                )
                // MARK: Amount

                SDKLabelField(title: "Amount", textStyle: sdkTheme.labelStyle , width: 100)

                SDKTextField(
                    title: "Enter Amount",
                    text: $userAmount,
                    style : sdkTheme.inputStyle
                )

                // MARK: Order ID

                label("Order ID")

                SDKTextField(
                    title: "Enter Order ID",
                    text: $orderId,
                    style : sdkTheme.inputStyle
                )

                // MARK: Metadata

                label("Metadata")

                SDKTextField(
                    title: "Enter Metadata",
                    text: $userData,
                    style : sdkTheme.inputStyle
                )

                // MARK: Email

                label("Email")

                SDKTextField(
                    title: "Enter Email",
                    text: $userEmail,
                    style : sdkTheme.inputStyle
                )

                // MARK: Transaction ID

                label("Transaction ID")

                SDKTextField(
                    title: "Enter Transaction ID",
                    text: $transactionId,
                    style : sdkTheme.inputStyle
                )

                // MARK: Apple Pay Merchant Identifier

                label("Apple Pay Merchant Identifier")

                SDKTextField(
                    title:
                    "merchant.com.company.payment",
                    text: $applePayMerchantId,
                    style : sdkTheme.inputStyle
                )

                // MARK: Apple Pay

                SDKButton(
                    title: "Pay with Apple Pay",
                    systemImage: "applelogo",
                    style: sdkTheme.primaryButtonStyle
                ) {

                    startApplePay()
                }

                // MARK: Start Payment

                SDKButton(
                    title: "Start Payment",
                    style: sdkTheme.primaryButtonStyle
                ) {

                    startPayment()
                }

                // MARK: Result

                if !paymentMessage.isEmpty {

                    Text(paymentMessage)
                        .padding()
                        .foregroundColor(
                            sdkTheme.textColor
                        )
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                        .background(
                            Color.gray.opacity(0.1)
                        )
                        .cornerRadius(12)
                }
            }
            .padding()
        }
    }
}

// MARK: Helper Methods

extension ContentView {

    @ViewBuilder
    private func label(
        _ text: String
    ) -> some View {

        Text(text)
            .font(.caption)
            .foregroundColor(
                sdkTheme.textColor
            )
    }

    private func startPayment() {

        guard validate() else {
            return
        }
        // baseURL: "http://10.10.11.208:8788/CORE_2.2.2",
        let config = SDKConfiguration(
            terminalId: "Routing",
            password: "Password@123",
            merchantKey: "d49406528388682669387b3bad6883571fc5b14e15c94416e21c94a201543ad9",
            baseURL: "http://10.10.11.208:8788/CORE_2.2.2",
           
           
            theme: sdkTheme
        )

        InAppSDK.shared.initialize(
            configuration: config
        )

        let request =
            createPaymentRequest()

        InAppSDK.shared.startPayment(
            request: request
        ) { result in

            paymentMessage = """
            Result : \(result.rawJson ?? "")
            
            """
            
//            paymentMessage = """
//            Result : \(result.result ?? "")
//            Code : \(result.responseCode ?? "")
//            Description : \(result.responseDescription ?? "")
//            Card Token: \(result.cardToken ?? "")
//            Transaction Id : \(result.transactionId ?? "")
//            
//            """
        }
    }

    private func startApplePay() {

        guard validate() else {
            return
        }

        let config = SDKConfiguration(
            terminalId: "AMRouting",
            password: "Password@123",
            merchantKey: "d49406528388682669387b3bad6883571fc5b14e15c94416e21c94a201543ad9",
            baseURL: "http://10.10.11.208:8788/CORE_2.2.2",
            theme: sdkTheme
        )

        InAppSDK.shared.initialize(
            configuration: config
        )

        let request =
            createPaymentRequest()
        
        


        InAppSDK.shared.startApplePay(
            request: request
        ) { result in

            paymentMessage = """
            Result : \(result.rawJson ?? "")
            
            """
            
//            Result : \(result.result ?? "")
//            Code : \(result.responseCode ?? "")
//            Description : \(result.responseDescription ?? "")
//            Card Token : \(result.cardToken ?? "")
//            Transaction Id : \(result.transactionId ?? "")
//            Transaction Id : \(result.transactionId ?? "")
//            """
        }
    }

            
            private func createPaymentRequest()
        -> PaymentRequestData {
    
            PaymentRequestData(
                amount: userAmount,
                transactionType: getPaymentType(),
                currency: "SAR",
                email: userEmail,
                address: "Ram Nagar Ayodhya",
                city: "Mumbai",
                state: "MH",
                zip: "210210",
                countryCode: "SA",
                trackId: orderId,
                cardOperation:
                    selectedTransactionType == "Tokenization"
                    ? getCardOperation()
                    : "",
                cardToken:
                    cardToken,
                tokenType:
                    selectedTransactionType == "Tokenization"
                    ? "1"
                    : "0",
                transactionId: transactionId,
                metadata: userData
            )
        }
    //    // MARK: Validation
    //
        private func validate() -> Bool {
    
            if userAmount.isEmpty {
                paymentMessage = "Amount is mandatory"
                return false
            }
    
            if orderId.isEmpty {
                paymentMessage = "Order ID is mandatory"
                return false
            }
    
//            if selectedTransactionType == "Tokenization" {
//    
//                if cardToken.trimmingCharacters(
//                    in: .whitespacesAndNewlines
//                ).isEmpty {
//    
//                    paymentMessage =
//                    "Card Token is mandatory"
//    
//                    return false
//                }
//            }
    
            return true
        }
    
    
    //    // MARK: Payment Type
   
        private func getPaymentType() -> String {
    
            switch selectedTransactionType {
    
            case "Purchase":
                return "1"
    
            case "PreAuth":
                return "4"
    
            case "Tokenization":
                return "12"
                
            case "Transaction Enquiry":
                return "10"
    
            default:
                return "1"
            }
        }
    
    
    private func getCardOperation() -> String {

        switch selectedOperation {
            
        case "Add":
            return "A"

        case "Update":
            return "U"

        case "Delete":
            return "D"


        default:
            return "1"
        }
    }
    
}
