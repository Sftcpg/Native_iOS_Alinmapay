//
//  SubmitCVVPaymentReq.swift
//  PaymentSDK
//
//  Created by Concerto on 14/07/26.
//

import Foundation

public struct SubmitCVVPaymentReq: Codable {

   public let browserDetails: BrowserDetailsCVV
    public let card: VerifyCard
    public let customerIp: String
    public let paymentId: String

    public init(
        browserDetails: BrowserDetailsCVV,
        card: VerifyCard,
        customerIp: String,
        paymentId: String
    ) {
        self.browserDetails = browserDetails
        self.card = card
        self.customerIp = customerIp
        self.paymentId = paymentId
    }
}
public struct BrowserDetailsCVV: Codable {

    public let transactionUuid: String
    public let browserLanguage: String
    public let browserScreenHeight: String
    public let browserJavascriptEnabled: Bool
    public let browserColorDepth: String
    public let browserJavaEnabled: Bool
    public let browserScreenWidth: String
    public let browserAcceptHeader: String
    public let browserTZ: String
    public let browserUserAgent: String

    public init(
        transactionUuid: String,
        browserLanguage: String,
        browserScreenHeight: String,
        browserJavascriptEnabled: Bool,
        browserColorDepth: String,
        browserJavaEnabled: Bool,
        browserScreenWidth: String,
        browserAcceptHeader: String,
        browserTZ: String,
        browserUserAgent: String
    ) {
        self.transactionUuid = transactionUuid
        self.browserLanguage = browserLanguage
        self.browserScreenHeight = browserScreenHeight
        self.browserJavascriptEnabled = browserJavascriptEnabled
        self.browserColorDepth = browserColorDepth
        self.browserJavaEnabled = browserJavaEnabled
        self.browserScreenWidth = browserScreenWidth
        self.browserAcceptHeader = browserAcceptHeader
        self.browserTZ = browserTZ
        self.browserUserAgent = browserUserAgent
    }
}
public struct VerifyCard: Codable {

    
    public let cvv: String
   
}
