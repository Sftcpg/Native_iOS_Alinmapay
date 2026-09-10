//
//  PaymentMethodDisp.swift
//  PaymentSDK
//
//  Created by Concerto on 07/07/26.
//



import SwiftUI

// MARK: - Card Model

struct CardDetails {

    var cardNumber: String = ""
    var expiryMonth: String = ""
    var expiryYear: String = ""
    var cvv: String = ""
    var cardHolderName: String = ""
    var cardTokenFlag: String = ""
}

// MARK: - Payment Method View

struct PaymentMethod: View {
    
    // MARK: Response
    
    let paymentResponse: InitiatePaymentResponse
    
    // MARK: Payment Modes
    
//    private let supportedModes = [
//        "CARD",
//        "UPI"
//    ]
    
    @StateObject private var loader =
        LoaderManager.shared
    // MARK: Selected Payment
    
    @State private var selectedMethod = "CARD"
    
    // MARK: Card Details
    
    @State private var cardDetails = CardDetails1()
    
    // MARK: Save Card
    
    @State private var saveCard = false
    
    // MARK: Loading
    
    @State private var isLoading = false
    
    // MARK: Keyboard
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        
        case cardHolder
        case cardNumber
        case expiry
        case cvv
    }
    
    // MARK: Card Brand
    
    enum CardBrand {
        
        case visa
        case master
        case amex
        case mastercard
        case unknown
    }
    
    @State private var cardBrand: CardBrand = .unknown
    
    
    private var theme: SDKTheme {
        SDKThemeManager.shared.theme
    }
    
    // MARK: Theme
    
    private let sdkBlue = Color(
        red: 0/255,
        green: 92/255,
        blue: 175/255
    )
    
    private let lightGray = Color(
        UIColor.systemGray6
    )
    private var cardTokenFlag: String {
        saveCard ? "Y" : "N"
    }
    
    private var sdkTheme: SDKTheme {
        SDKThemeManager.shared.theme
    }
    
    private var isSavedCard: Bool {

        guard let request =
               InAppSDK.shared.paymentRequest
           else {
               return false
           }

           return request.transactionType == "1"
               &&
               !request.cardToken.isEmpty
    }
    
    // MARK: Body
    
    var body: some View {
        
        ZStack {
            
            Color(
                UIColor.systemGroupedBackground
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                // Header
                paymentHeader()
                
                ScrollView(showsIndicators: false) {
                    
                    VStack(spacing: 20) {
                        
                        paymentInfoCard()
                        
//                        if isSavedCard {
//
//                            savedCardLayout()
//
//                        } else {
//
//                           paymentInfoCard()
//                        }
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.horizontal,20)
                    .padding(.top,10)
                }
                paymentBottomBar()
            }
        }
    }
    
    // MARK: - Header
    
    @ViewBuilder
    private func paymentHeader() -> some View {
        
        ZStack(alignment: .top) {
            
            // Blue Background
            RoundedRectangle(cornerRadius: 0)
                .fill(
                    LinearGradient(
                        colors: [
                            sdkBlue,
                            sdkBlue.opacity(0.85)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: 150)
//                .clipShape(
//                    RoundedCorner(
//                        radius: 35,
//                        corners: [.bottomLeft, .bottomRight]
//                    )
//                )
            
            VStack(spacing: 20) {
                
                //---------------------------------------------------
                // Back Button
                //---------------------------------------------------
                
                HStack {
                    
                    Button {
                        
                        cancelPayment()
                        
                    } label: {
                        
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(
                                Circle()
                                    .fill(Color.white.opacity(0.20))
                            )
                    }
                    
                    Spacer()
                }
                
                //---------------------------------------------------
                // Merchant Logo
                //---------------------------------------------------
                
//                Image("merchant_logo")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 70, height: 70)
//                    .clipShape(Circle())
//                    .background(
//                        Circle()
//                            .fill(Color.white)
//                            .frame(width: 76, height: 76)
//                    )
                
                //---------------------------------------------------
                // Merchant Name
                //---------------------------------------------------
                
                Text("Merchant Name")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
            }
            .padding(.horizontal,20)
            .padding(.top,50)
        }
    }
    
    
    // MARK: - Payment Information
    
    
    
    
    
        @ViewBuilder
        private func paymentInfoCard() -> some View {

            VStack(
                alignment: .leading,
                spacing: 18
            ) {

                //--------------------------------------------------
                // Title
                //--------------------------------------------------

                Text("Pay with Card")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(sdkBlue)

                Divider()

                //--------------------------------------------------
                // Amount
                //--------------------------------------------------

                Text("You're paying")
                    .foregroundColor(.gray)

                Text(
                    "SAR \(paymentResponse.amountDetails?.amount)"
                )
                .font(
                    .system(
                        size: 20,
                        weight: .bold
                    )
                )
                .foregroundColor(sdkBlue)

                //--------------------------------------------------
                // Transaction ID
                //--------------------------------------------------

                VStack(
                    alignment: .leading,
                    spacing: 5
                ) {

                    Text("Transaction ID")
                        .font(.caption)
                        .foregroundColor(.gray)

                    Text(
                        paymentResponse.transactionId!
                    )
                    .font(.footnote)
                    .foregroundColor(.black)
                }

                Divider()

                //--------------------------------------------------
                // Card Layout
                //--------------------------------------------------

                if isSavedCard {

                    savedCardLayout()

                } else {

                    fullCardLayout()
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .shadow(
                color: .black.opacity(0.08),
                radius: 10,
                x: 0,
                y: 5
            )
        }
   
    
    @ViewBuilder
    private func fullCardLayout()
    -> some View {

        HStack {

            Text("Name on Card")
                .font(.headline)

            Spacer()

            

            Image.sdkImage(named: "ic_mastercard")
                .resizable()
                .scaledToFit()
                .frame(width: 30)

            Image.sdkImage(named: "ic_rupay")
                .resizable()
                .scaledToFit()
                .frame(width: 30)

            Image.sdkImage(named: "ic_amex")
                .resizable()
                .scaledToFit()
                .frame(width: 30)
        }

        SDKTextField(
            title: "Cardholder Name",
            text: $cardDetails.cardHolderName,
            style:
                sdkTheme.inputStyle,
            validation: { value in

                if value.isEmpty {
                    return "Cardholder Name required"
                }

                return nil
            },
            onChange: { value in

                cardDetails.cardHolderName =
                    value.filter {
                        $0.isLetter ||
                        $0.isWhitespace
                    }
            }
        )
           
        
     

        Text("Card Number")
            .foregroundColor(theme.textColor)
            .font(theme.font)

        HStack {

            //Image(systemName: "creditcard.fill")

            SDKTextField(
                title: "Card Number",
                text: $cardDetails.cardNumber,
                keyboardType: .numberPad,
                style:
                    sdkTheme.inputStyle,
                logo: "creditcard.fill",
               
                validation: { value in

                    let number =
                        value.replacingOccurrences(
                            of: " ",
                            with: ""
                        )

                    if number.count < 16 {
                        return "Invalid Card Number"
                    }

                    return nil
                },
             
                onChange: { value in
                    formatCardNumber(value)
                }
            )

            Spacer()

            cardBrandImage()
        }
        

        HStack(spacing: 15) {

            VStack(alignment: .leading) {
                Text("Expiry")
                
                HStack(spacing: 5) {
                    
                    
                    SDKTextField(
                        title: "MM",
                        text: $cardDetails.expiryMonth,
                        keyboardType: .numberPad,
                        style:
                            sdkTheme.inputStyle,
                        onChange:  { value in
                            
                            cardDetails.expiryMonth = value.filter { $0.isNumber }
                            
                            if cardDetails.expiryMonth.count > 2 {
                                cardDetails.expiryMonth = String(cardDetails.expiryMonth.prefix(2))
                            }
                            
                            if let month = Int(cardDetails.expiryMonth),
                               month > 12 {
                                
                                cardDetails.expiryMonth = "12"
                            }
                        }
                    )
                  
                    
                    SDKTextField(
                        title: "YYYY",
                        text: $cardDetails.expiryYear,
                        
                        keyboardType: .numberPad,
                        style:
                            sdkTheme.inputStyle,
                        onChange:  { value in
                        
                        cardDetails.expiryYear = value.filter { $0.isNumber }

                        if cardDetails.expiryYear.count > 4 {
                            cardDetails.expiryYear = String(cardDetails.expiryYear.prefix(4))
                        }
                    }
                        
                    )
                   
                }
            }

            VStack(alignment: .leading) {

                Text("CVV")

                SDKTextField(
                    title: "CVV",
                    text: $cardDetails.cvv,
                    keyboardType: .numberPad,
                    style:
                        sdkTheme.inputStyle,
                    isSecure: true,
                    validation: { value in

                        if value.count < 3 {
                            return "Invalid CVV"
                        }

                        return nil
                    },
                    onChange: { value in
                    
                    cardDetails.cvv = value.filter { $0.isNumber }

                    if cardDetails.cvv.count > 4 {
                        cardDetails.cvv = String(cardDetails.cvv.prefix(4))
                    }
                }
            
                )
               
            }
        }

        Toggle(
            "Save Card",
            isOn: $saveCard
        )
        .tint(theme.primaryColor)
    }
    
//    // MARK: Payment Mode
//
//    @ViewBuilder
//    private func paymentModeSection() -> some View {
//
//        VStack(alignment:.leading,spacing:18){
//
//            ForEach(supportedModes,id:\.self){ mode in
//
//                Button{
//
//                    selectedMethod = mode
//
//                }label:{
//
//                    HStack{
//
//                        Image(systemName:
//
//                                selectedMethod == mode ?
//
//                              "largecircle.fill.circle"
//
//                              :
//
//                                "circle"
//                        )
//
//                        Text(displayName(for: mode))
//
//                        Spacer()
//
//                    }
//                    .foregroundColor(.black)
//                }
//                .buttonStyle(.plain)
//            }
//
//            if selectedMethod == "CARD" {
//
//                EmptyView()
//
//            }
//
//        }
//    }
//
    @ViewBuilder
    private func cardBrandImage() -> some View {
        
        switch cardBrand{
            
        case .visa:
            
            Image("ic_rupay")
                .resizable()
                .scaledToFit()
                .frame(width:35)
            
        case .master:
            
            Image("ic_mastercard")
                .resizable()
                .scaledToFit()
                .frame(width:35)
            
        case .amex:
            
            Image("ic_amex")
                .resizable()
                .scaledToFit()
                .frame(width:35)
            
        default:
            
            EmptyView()
        }
    }
    
    
    
    // MARK: Display Name

    private func displayName(for mode: String) -> String {

        switch mode {

        case "CARD":
            return "Card"

        case "UPI":
            return "UPI"

        case "NETBANKING":
            return "Net Banking"

        case "WALLET":
            return "Wallet"

        default:
            return mode
        }
    }
    
    
    
    
    private func formatCardNumber(_ value:String){
        
        let digits = value.filter{$0.isNumber}
        
        let limited = String(digits.prefix(16))
        
        var result = ""
        
        for(index,char) in limited.enumerated(){
            
            if index != 0 && index % 4 == 0{
                
                result += " "
            }
            
            result.append(char)
        }
        
        cardDetails.cardNumber = result
        
        detectCardBrand(limited)
    }
    
    private func detectCardBrand(_ number:String){
        
        if number.hasPrefix("4"){
            
            cardBrand = .visa
            
        }else if number.hasPrefix("5"){
            
            cardBrand = .master
            
        }else if number.hasPrefix("34") || number.hasPrefix("37"){
            
            cardBrand = .amex
            
        }else{
            
            cardBrand = .unknown
        }
    }
    private func updateExpiry(_ value:String){
        
        let digits = value.filter{$0.isNumber}
        
        if digits.count >= 2{
            
            cardDetails.expiryMonth = String(digits.prefix(2))
            
            cardDetails.expiryYear = String(digits.dropFirst(2).prefix(2))
            
        }else{
            
            cardDetails.expiryMonth = digits
            
            cardDetails.expiryYear = ""
        }
    }
    private func cancelPayment() {
        
        let result = PaymentResult(
            rawJson: paymentResponse.rawJson,
            transactionId: paymentResponse.transactionId,
            
            transactionDateTime: nil,
            
            result: "CANCELLED",
            
            responseCode: nil,
            
            responseDescription: "Payment Cancelled",
            
            orderId: paymentResponse.orderDetails.orderId,
            
            amount: paymentResponse.amountDetails?.amount,
            
            originalAmount: paymentResponse.amountDetails?.originalAmount,
            
            paymentMethod: nil,
            
            maskedCard: nil,
            
            cardBrand: nil,
            cardToken: nil,
            cardHolderName: nil,
            
            signature: nil,
            
            terminalId: nil
        )
        
        SDKNavigator.shared.closeAllSDKScreens {
            
            InAppSDK.shared.notifyPaymentResult(result)
        }
    }
    
    // MARK: - Bottom Bar

    @ViewBuilder
    private func paymentBottomBar() -> some View {

        VStack(spacing: 12) {

//            Button {
//
//                submitPayment()
//
//            } label: {
//
//                HStack {
//
//                    if isLoading {
//
//                        ProgressView()
//                            .tint(.white)
//
//                    } else {
//
//                        Text("PAY NOW")
//                            .font(.headline)
//                            .fontWeight(.bold)
//                    }
//
//                }
//                .frame(maxWidth: .infinity)
//                .frame(height: 35)
//                .background(theme.primaryColor)
//                .foregroundColor(theme.buttonTextColor)
//                .cornerRadius(theme.buttonCornerRadius)
//            }
            
            SDKButton(
                title: "Pay Now",
               
                style:
                    sdkTheme.primaryButtonStyle
            ) {

                if isSavedCard {

                    submitCVVPayment()

                } else {

                    submitPayment()
                }
               
            }


        }
        .padding()
        .background(Color.white)
        .shadow(color: .black.opacity(0.08), radius: 8, y: -3)
    }
    
    
    
    @ViewBuilder
    private func savedCardLayout()
    -> some View {

        VStack(
            alignment: .leading,
            spacing: 20
        ) {

            Text("Saved Card")
                .font(.headline)

//            HStack {
//
//                Image(
//                    systemName:
//                        "creditcard.fill"
//                )
//
//
//
//                Spacer()
//
//                cardBrandImage()
//            }
//            .padding()
//            .overlay(
//                RoundedRectangle(
//                    cornerRadius: 10
//                )
//                .stroke(
//                    Color.gray.opacity(0.4)
//                )
//            )

            VStack(
                alignment: .leading,
                spacing: 8
            ) {

                Text("CVV")

                SecureField(
                    "Enter CVV",
                    text: $cardDetails.cvv
                )
                .keyboardType(
                    .numberPad
                )
                .textFieldStyle(
                .roundedBorder
                )
            }
        }
    }
    
    
    // MARK: Submit Payment

    private func submitPayment() {

        switch selectedMethod {

        case "CARD":

            print("Card Number : \(cardDetails.cardNumber)")
            print("Expiry Month : \(cardDetails.expiryMonth)")
            print("Expiry Year : \(cardDetails.expiryYear)")
            print("CVV : \(cardDetails.cvv)")
            print("Card Holder : \(cardDetails.cardHolderName)")

            // TODO:
            // Call Submit Card API
            let request = SubmitPaymentRequest(

                referenceId: paymentResponse.transactionId!,

                   customerIp: "10.10.8.222",

                amount: paymentResponse.amountDetails!.amount,

                   currency: "SAR",
                   cardTokenFlag: saveCard ? "Y" : "N",
                   paymentInstrument: SubmitPaymentInstrument(

                       vpaId: nil,

                       walletId: nil,

                       paymentMethod: "DCI",

                       channelName: nil
                   ),

                   card: Card(

                       number: cardDetails.cardNumber.replacingOccurrences(
                        of: " ",
                        with: ""
                    ),

                       cvv: cardDetails.cvv,

                       expiryMonth: cardDetails.expiryMonth,

                       expiryYear: cardDetails.expiryYear
                   ),

                   customer: SubmitCustomer(

                       cardHolderName: cardDetails.cardHolderName,

                       customerEmail: "mukesh.patel@concertosoft.com"
                   ),
                 
                   browserDetails: BrowserDetails(

                       transactionUuid: UUID().uuidString,

                       browserLanguage: "en-US",

                       browserScreenHeight: "768",

                       browserJavascriptEnabled: true,

                       browserColorDepth: "24",

                       browserJavaEnabled: true,

                       browserScreenWidth: "1024",

                       browserAcceptHeader: "text/html,application/xhtml+xml,application/xml",

                       browserTZ: "-330",

                       browserUserAgent: "Mozilla/5.0 (iPhone)"
                   )
               )
print(request)
               InAppSDK.shared.submitPayment(
                   request: request
               )

        case "UPI":

            print("UPI Payment")

        default:

            break
        }
    }
    
    
    
    private func submitCVVPayment() {

        switch selectedMethod {

        case "CARD":

            
            print("CVV : \(cardDetails.cvv)")
            print("Transaction ID in CVV : \(paymentResponse.transactionId)")
           
            // TODO:
            // Call Submit Card API
            let request = SubmitPaymentRequest(
                
                referenceId: paymentResponse.transactionId ?? "",
                customerIp:"10.10.8.222",
                amount:paymentResponse.amountDetails!.amount,
                currency: "SAR",
               cardTokenFlag: "",
                paymentInstrument: SubmitPaymentInstrument(

                    vpaId: nil,

                    walletId: nil,

                    paymentMethod: "DCI",

                    channelName: nil
                ),
                
               
            
                
               
                card: Card(

                    number: "",

                    cvv: cardDetails.cvv,

                    expiryMonth: "",

                    expiryYear: ""
                ),
                
                customer: SubmitCustomer(

                    cardHolderName: cardDetails.cardHolderName,

                    customerEmail: "mukesh.patel@concertosoft.com"
                ),
                browserDetails: BrowserDetails(

                          transactionUuid: UUID().uuidString,

                          browserLanguage: "en-US",

                          browserScreenHeight: "768",

                          browserJavascriptEnabled: true,

                          browserColorDepth: "24",

                          browserJavaEnabled: true,

                          browserScreenWidth: "1024",

                          browserAcceptHeader: "text/html,application/xhtml+xml,application/xml",

                          browserTZ: "-330",

                          browserUserAgent: "Mozilla/5.0 (iPhone)"
                      ),
               
               
                
         
               )
                print(request)
               InAppSDK.shared.submitCVVPayment(
                   request: request
               )

        case "UPI":

            print("UPI Payment")

        default:

            break
        }
    }

    
}

