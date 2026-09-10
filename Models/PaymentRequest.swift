import Foundation

public struct PaymentRequest: Codable {

    public let paymentType: String
    public let currency: String
    public let amount: String
    
    public let countryCode: String
    public let order: Order
    public let customer: Customer
    public let paymentInstrument: PaymentInstrument
    public let additionalDetails: ReqAdditionalDetails
    public let tokenization: Tokenization
    public let deviceinfo: DeviceInfo
    
    public init(
        amount: String,
        currency: String,
        paymentType: String,
        countryCode: String,
        order: Order,
        customer: Customer,
        paymentInstrument: PaymentInstrument,
        additionalDetails: ReqAdditionalDetails,
        tokenization: Tokenization,
        deviceinfo: DeviceInfo
    ) {
        self.amount = amount
        self.currency = currency
        self.paymentType = paymentType
        self.countryCode = countryCode
        self.order = order
        self.customer = customer
        self.paymentInstrument = paymentInstrument
        self.additionalDetails = additionalDetails
        self.tokenization = tokenization
        self.deviceinfo = deviceinfo
        
    }
    
    
}

// MARK: - Order

public struct Order: Codable {

    public let orderId: String
    public let description: String
    public init(
          orderId: String,
          description: String
      ) {
          self.orderId = orderId
          self.description = description
      }
}

// MARK: - Customer

public struct Customer: Codable {

    public let customerEmail: String
    public let billingAddressStreet: String
    public let billingAddressCity: String
    public let billingAddressState: String
    public let billingAddressPostalCode: String
    public let billingAddressCountry: String
    
    public init(
           customerEmail: String,
           billingAddressStreet: String,
           billingAddressCity: String,
           billingAddressState: String,
           billingAddressPostalCode: String,
           billingAddressCountry: String
       ) {
           self.customerEmail = customerEmail
           self.billingAddressStreet = billingAddressStreet
           self.billingAddressCity = billingAddressCity
           self.billingAddressState = billingAddressState
           self.billingAddressPostalCode = billingAddressPostalCode
           self.billingAddressCountry = billingAddressCountry
       }
}

// MARK: - Payment Instrument

public struct PaymentInstrument: Codable {

    public let paymentMethod: String
    public init(paymentMethod: String) {
          self.paymentMethod = paymentMethod
      }
}

// MARK: - Additional Details

public struct ReqAdditionalDetails: Codable {

    public let userData: String
    public init(userData: String) {
           self.userData = userData
       }
}

public struct DeviceInfo: Codable {

    let deviceModel: String
    let pluginVersion: String
    let clientPlatform: String
    let devicePlatform: String
    let deviceOSVersion: String
    let pluginName: String
}

// MARK: - Tokenization

public struct Tokenization: Codable {

    public let operation: String
    public let cardToken: String
    public init(
           operation: String,
           cardToken: String
       ) {
           self.operation = operation
           self.cardToken = cardToken
       }
}

public struct PaymentToken: Codable {
    let paymentMethod: ApplePayPaymentMethod
    let paymentData: String
    let transactionIdentifier: String
}

public struct ApplePayPaymentMethod: Codable {
    let displayName: String
    let network: String
    let type: String
}
