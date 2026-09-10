//
//  PaymentMethodDisp.swift
//  PaymentSDK
//
//  Created by Concerto on 07/07/26.
//



import SwiftUI

// MARK: - Card Model

struct CardDetails1 {

    var cardNumber: String = ""
    var expiryMonth: String = ""
    var expiryYear: String = ""
    var cvv: String = ""
    var cardHolderName: String = ""
    var cardTokenFlag: String = ""
}

// MARK: - Payment Method View

struct PaymentMethodDisp: View {
    
    // MARK: Response
    
    let paymentResponse: InitiatePaymentResponse
    
    // MARK: Payment Modes
    let supportedModes: [String]
//    private let supportedModes = [
//        "CARD",
//        "UPI"
//    ]
    
    @StateObject private var loader =
        LoaderManager.shared
    
    // MARK: Selected Payment
    
    @State private var selectedMethod = ""
    
    // MARK: Card Details
    
    @State private var cardDetails = CardDetails1()
    
    // MARK: Save Card
    
    @State private var saveCard = false
    
    // MARK: Loading
    
    @State private var isLoading = false
    
    @State private var lastCardBin = ""
    
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
    
    init(
        paymentResponse: InitiatePaymentResponse,
        supportedModes: [String]
    ) {
        self.paymentResponse = paymentResponse
        self.supportedModes = supportedModes
        _selectedMethod = State(
            initialValue: supportedModes.first ?? ""
        )
    }
    
    
    
    // MARK: Body
    var body: some View {
        ZStack {
            Color(
                UIColor.systemGroupedBackground
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {

                ScrollView {

                    VStack(spacing: 20) {

                        merchantCard()

                        paymentMethodSection()

                        amountSummary()

                      buttonsSection()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
                .onAppear {
                    InAppSDK.shared.onCardBrandReceived = { brand in

                        DispatchQueue.main.async {

                            switch brand.uppercased() {

                            case "VISA":
                                self.cardBrand = .visa

                            case "MASTERCARD":
                                self.cardBrand = .master

                            case "AMEX":
                                self.cardBrand = .amex

                            default:
                                self.cardBrand = .unknown
                            }
                        }
                    }
                       if selectedMethod.isEmpty {
                           selectedMethod = displayModes.first ?? ""
                       }
                   }
            }
        }
    }
    
    // MARK: - Header
    
    @ViewBuilder
    private func merchantCard() -> some View {

        VStack(
            alignment: .center,
            spacing: 0
        ) {

            switch sdkTheme.merchantBranding.type {

            case .logo:

                if let logo = sdkTheme.merchantBranding.logo {

                    Image(uiImage: logo)
                        .resizable()
                        .scaledToFit()
                        .frame(
                            maxWidth: 100,
                            maxHeight: 100
                        )
                }

            case .text:

                if let text = sdkTheme.merchantBranding.text {

                    Text(text)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(
                            sdkTheme.primaryColor
                        )
                }

            case .none:

                EmptyView()
            }
        }
        .frame(
            maxWidth: .infinity,
            minHeight: 70
        )
        .padding(20)
        .background(Color.white)
        .cornerRadius(25)
        .shadow(
            color: .black.opacity(0.1),
            radius: 5
        )
    }
    
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
    
//    @ViewBuilder
//    private func paymentMethodSection()
//    -> some View {
//
//        VStack(
//            alignment: .leading,
//            spacing: 25
//        ) {
//
//            Text("Select Payment Method")
//                .font(.title3)
//                .fontWeight(.bold)
//
//            HStack {
//
//                Button {
//
//                    selectedMethod = "CARD"
//
//                } label: {
//
//                    HStack {
//
//                        Image(
//                            systemName:
//                            selectedMethod == "CARD"
//                            ?
//                            "largecircle.fill.circle"
//                            :
//                            "circle"
//                        )
//
//                        Text("Card")
//                    }
//                }
//
//                Spacer()
//
//                HStack(spacing: 10) {
//
//                    Image.sdkImage(named: "ic_rupay")
//                        .resizable()
//                        .frame(width: 45,height: 30)
//
//                    Image.sdkImage(named: "ic_mastercard")
//                        .resizable()
//                        .frame(width: 45,height: 30)
//
//                    Image.sdkImage(named: "ic_amex")
//                        .resizable()
//                        .frame(width: 45,height: 30)
//                }
//            }
//
//            if selectedMethod == "CARD" {
//                if isSavedCard {
//
//                    savedCardLayout()
//
//                } else {
//
//                    fullCardLayout()
//                }            }
//
//            Button {
//
//                selectedMethod = "UPI"
//
//            } label: {
//
//                HStack {
//
//                    Image(
//                        systemName:
//                        selectedMethod == "UPI"
//                        ?
//                        "largecircle.fill.circle"
//                        :
//                        "circle"
//                    )
//
//                    Text("UPI")
//                }
//            }
//        }
//    }
//    
//    
    @ViewBuilder
    private func paymentMethodSection() -> some View {

        VStack(
            alignment: .leading,
            spacing: 20
        ) {

            Text("Select Payment Method")
                .font(.title3)
                .fontWeight(.bold)

            ForEach(displayModes,
                id: \.self
            ) { mode in

                Button {

                    selectedMethod = mode

                } label: {

                    HStack {

                        Image(
                            systemName:
                                selectedMethod == mode
                                ? "largecircle.fill.circle"
                                : "circle"
                        )
                        .foregroundColor(
                            sdkTheme.primaryColor
                        )

                        Text(
                            displayName(for: mode)
                        )

                        Spacer()

                        //paymentIcons(for: mode)
                    }
                    .foregroundColor(.black)
                }
                .buttonStyle(.plain)

                if selectedMethod == mode {

                    paymentView(for: mode)
                }
            }
        }
    }
    
    private var displayModes: [String] {

        var modes: [String] = []

        // Add a single "CARD" option if either CCI or DCI is supported
       

        if supportedModes.contains("APPLEPAY") {
            modes.append("APPLEPAY")
        }
        if supportedModes.contains("CCI") || supportedModes.contains("DCI") {
            modes.append("CARD")
        }

        if supportedModes.contains("STCPAY") {
            modes.append("STCPAY")
        }

        if supportedModes.contains("TABBY") {
            modes.append("TABBY")
        }

        return modes
    }
    
    @ViewBuilder
    private func paymentView(
        for mode: String
    ) -> some View {

        switch mode {

        case "CARD":

            if isSavedCard {
                savedCardLayout()
            } else {
                fullCardLayout()
            }

        case "APPLEPAY":

            EmptyView()

        case "STCPAY":

            EmptyView()
        case "TABBY":

            EmptyView()

        default:

            EmptyView()
        }
    }
    
    @ViewBuilder
    private func paymentIcons(
        for mode: String
    ) -> some View {

        switch mode {

        case "CCI", "DCI":
           
            HStack(spacing: 8) {

                Image.sdkImage(named: "ic_mastercard")
                    .resizable()
                    .frame(width: 35, height: 22)

                Image.sdkImage(named: "ic_rupay")
                    .resizable()
                    .frame(width: 35, height: 22)

                Image.sdkImage(named: "ic_amex")
                    .resizable()
                    .frame(width: 35, height: 22)
            }

        case "APPLEPAY":

            Image.sdkImage(named: "ic_applepay")
                .resizable()
                .frame(width: 50, height: 25)

        case "STCPAY":

            Image.sdkImage(named: "ic_stcpay")
                .resizable()
                .frame(width: 50, height: 25)

        case "TABBY":

            Image.sdkImage(named: "ic_tabby")
                .resizable()
                .frame(width: 50, height: 25)

        default:

            EmptyView()
        }
    }
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

            Text("Card Number")
                .foregroundColor(theme.textColor)
                .font(theme.font)

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
        HStack {

           

            SDKTextField(
                title: "Card Number",
                text: $cardDetails.cardNumber,
                keyboardType: .numberPad,
                style: sdkTheme.inputStyle,
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
                    
                    if number.count >= 12 {

                        let bin = String(number.prefix(12))

                        if lastCardBin != bin {
                            lastCardBin = bin
                            InAppSDK.shared.getCardBrandDetails(cardBin: bin)
                        }
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
        
            
       // HStack {

            Text("Name on Card")
                .foregroundColor(theme.textColor)
                .font(theme.font)

//            Spacer()
//
//            
//
//            Image.sdkImage(named: "ic_mastercard")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 30)
//
//            Image.sdkImage(named: "ic_rupay")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 30)
//
//            Image.sdkImage(named: "ic_amex")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 30)
//        }

        SDKTextField(
            title: "Cardholder Name",
            text: $cardDetails.cardHolderName,
            style: sdkTheme.inputStyle,
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
           
        
     

//        Text("Card Number")
//            .foregroundColor(theme.textColor)
//            .font(theme.font)
//
//        HStack {
//
//           
//
//            SDKTextField(
//                title: "Card Number",
//                text: $cardDetails.cardNumber,
//                keyboardType: .numberPad,
//                logo: "creditcard.fill",
//                validation: { value in
//
//                    let number =
//                        value.replacingOccurrences(
//                            of: " ",
//                            with: ""
//                        )
//
//                    if number.count < 16 {
//                        return "Invalid Card Number"
//                    }
//                    
//                    if number.count >= 12 {
//
//                        let bin = String(number.prefix(12))
//
//                        if lastCardBin != bin {
//                            lastCardBin = bin
//                            InAppSDK.shared.getCardBrandDetails(cardBin: bin)
//                        }
//                    }
//
//                    return nil
//                },
//                onChange: { value in
//                    formatCardNumber(value)
//                }
//            )
//
//            Spacer()
//
//            cardBrandImage()
//        }
        

        HStack(spacing: 15) {

            VStack(alignment: .leading) {
                Text("Expiry")
                    .foregroundColor(theme.textColor)
                    .font(theme.font)
                
                HStack(spacing: 5) {
                    
                    
                    SDKTextField(
                        title: "MM",
                        text: $cardDetails.expiryMonth,
                        keyboardType: .numberPad,
                        style: sdkTheme.inputStyle,
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
                        style: sdkTheme.inputStyle,
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
                    .foregroundColor(theme.textColor)
                    .font(theme.font)

                SDKTextField(
                    title: "CVV",
                    text: $cardDetails.cvv,
                    keyboardType: .numberPad,
                    style: sdkTheme.inputStyle,
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
            isOn: $saveCard,
          
        )
        .tint(theme.primaryColor)
    }
//    
//    private func formatCardNumber(_ value: String) {
//
//        let digits = value.filter { $0.isNumber }
//
//        let limited = String(digits.prefix(16))
//
//        var result = ""
//
//        for (index, char) in limited.enumerated() {
//            if index != 0 && index % 4 == 0 {
//                result += " "
//            }
//            result.append(char)
//        }
//
//        cardDetails.cardNumber = result
//
//        detectCardBrand(limited)
//
//        // Call API only once when 12 digits are entered
//        if limited.count == 12 {
//            getCardBrandDetails(cardBin: limited)
//        }
//    }
//    
    @ViewBuilder
    private func applePayLayout() -> some View {

        VStack(spacing: 20) {

            Text("Pay securely using Apple Pay")
                .font(.headline)
                .foregroundColor(.gray)

            Button {

               // startApplePay()

            } label: {

                HStack {

                    Image.sdkImage(named: "ic_applepay")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 30)

                    Text("Pay with Apple Pay")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(Color.black)
                .cornerRadius(12)
            }
        }
        .padding(.top, 10)
    }
    
    @ViewBuilder
    private func amountSummary() -> some View {

        HStack {

            Text("Total Amount:")
                .font(.system(size: 18))
                .foregroundColor(
                    sdkTheme.primaryColor
                )

            Spacer()

            Text(
                "SAR \(paymentResponse.amountDetails?.amount ?? "")"
            )
            .font(
                .system(
                    size: 20,
                    weight: .bold
                )
            )
            .foregroundColor(
                sdkTheme.primaryColor
            )
        }
        .padding(.horizontal, 25)
        .frame(
            maxWidth: .infinity,
            minHeight: 50
        )
        .background(
            RoundedRectangle(
                cornerRadius: 15
            )
            .fill(
                Color(
                    red: 0.94,
                    green: 0.95,
                    blue: 0.96
                )
            )
        )
        .overlay(
            RoundedRectangle(
                cornerRadius: 10
            )
            .stroke(
                Color.gray.opacity(0.15),
                lineWidth: 1
            )
        )
        .shadow(
            color: .black.opacity(0.08),
            radius: 5,
            x: 0,
            y: 2
        )
    }

    @ViewBuilder
    private func cardBrandImage() -> some View {
        
          switch cardBrand  {
            
            case .visa:
                Image.sdkImage(named: "ic_visa")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35)

            case .master:
                Image.sdkImage(named: "ic_mastercard")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35)

            case .amex:
                Image.sdkImage(named: "ic_amex")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35)

            default:
                EmptyView()
            }
    }
    
    
    
    // MARK: Display Name

    private func displayName(for mode: String) -> String {

        switch mode {

        case "CARD":
                return "Card"

            
            case "APPLEPAY":
                return "Apple Pay"

            case "STCPAY":
                return "STC Pay"

            case "TABBY":
                return "Tabby"
            
            case "UPI":
                return "UPI"
       

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
        
        //detectCardBrand(limited)
    }
    
//    private func detectCardBrand(_ number:String){
//        
//        if number.hasPrefix("4"){
//            
//            cardBrand = .visa
//            
//        }else if number.hasPrefix("5"){
//            
//            cardBrand = .master
//            
//        }else if number.hasPrefix("34") || number.hasPrefix("37"){
//            
//            cardBrand = .amex
//            
//        }else{
//            
//            cardBrand = .unknown
//        }
//    }
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
    
//    // MARK: - Bottom Bar
//
//    @ViewBuilder
//    private func paymentBottomBar() -> some View {
//
//        VStack(spacing: 12) {
//
////            Button {
////
////                submitPayment()
////
////            } label: {
////
////                HStack {
////
////                    if isLoading {
////
////                        ProgressView()
////                            .tint(.white)
////
////                    } else {
////
////                        Text("PAY NOW")
////                            .font(.headline)
////                            .fontWeight(.bold)
////                    }
////
////                }
////                .frame(maxWidth: .infinity)
////                .frame(height: 35)
////                .background(theme.primaryColor)
////                .foregroundColor(theme.buttonTextColor)
////                .cornerRadius(theme.buttonCornerRadius)
////            }
//            
//            SDKButton(
//                title: payButtonTitle,
//               
//                style:
//                    sdkTheme.primaryButtonStyle
//            ) {
//
//                if isSavedCard {
//
//                    submitCVVPayment()
//
//                } else {
//
//                    submitPayment()
//                }
//               
//            }
//
//
//        }
//        .padding()
//        .background(Color.white)
//        .shadow(color: .black.opacity(0.08), radius: 8, y: -3)
//    }
//    
    
    
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
    @ViewBuilder
    private func buttonsSection()
    -> some View {

        VStack(spacing: 15) {

            SDKButton(
                title: payButtonTitle,
                style:
                    sdkTheme.primaryButtonStyle
            ) {

                if isSavedCard {
                    submitCVVPayment()
                } else {
                    submitPayment()
                }
            }

            Button {

                cancelPayment()

            } label: {

                Text("Cancel Payment")
                    .frame(
                        maxWidth: .infinity
                    )
                    .frame(height: 55)
                    .background(Color.white)
                    .cornerRadius(30)
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

                       paymentMethod: InAppSDK.shared.apipaymentInst,

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
                
                referenceId: paymentResponse.transactionId!,
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

    private var payButtonTitle: String {

        guard let request = InAppSDK.shared.paymentRequest else {

            print("paymentRequest is nil")
            return "Pay Now"
        }

        print("Card Operation: \(request.cardOperation ?? "nil")")

        return request.cardOperation == "A"
            ? "Add Card"
            : "Pay Now"
    }
}
