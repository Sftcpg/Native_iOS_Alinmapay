import Foundation

public struct InitiatePaymentResponse: Codable {

    public let rawJson: String?
    
    public let orderDetails: OrderDetails
    public let responseDescription: String?
    public let transactionDateTime: String?
    public let result: String?
    public let paymentLink: PaymentLink?
    public let tokenizationDetails: TokenDetails?
    public let terminalId: String?
    public let additionalDetails: ResAdditionalDetails?
    public let transactionId: String?
    public let amountDetails: AmountDetails?
    public let responseCode: String?
    public let supportedPaymentModes: [String]?
}

public struct OrderDetails: Codable {
    public let orderId: String
}

public struct PaymentLink: Codable {
    public let linkUrl: String
}

public struct AmountDetails: Codable {
    public let amount: String
    public let originalAmount: String
   
}

public struct TokenDetails: Codable {
    public let cardToken: String
  
   
}

public struct ResAdditionalDetails: Codable {

    public let userData: String?
}
