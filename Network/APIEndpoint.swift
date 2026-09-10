enum APIEndpoint {

    case initiatePayment
    case submitPaymentDetails
    case submitCVVPaymentDetails
    case transactionStatus
    case getSupportedPaymentMethod
    case getCardBrandDetails(String)

    var path: String {
        switch self {

        case .initiatePayment:
            return "/v2/payments/pay-request"

        case .submitPaymentDetails:
               return "/api/v1/sdk/processInAppTransaction.htm"
            
        case .submitCVVPaymentDetails:
               return "/api/v1/sdk/confirmCvvTran.htm"
            
        case .getSupportedPaymentMethod:
                    return "/api/v1/sdk/getSupportedPaymentMethod.htm"

        case .getCardBrandDetails(let cardBin):
                    return "/api/v1/sdk/getCardBrandDetails.htm?cardBin=\(cardBin)"
            
           
        case .transactionStatus:
            return "/transactionStatus"
        }
    }
}
