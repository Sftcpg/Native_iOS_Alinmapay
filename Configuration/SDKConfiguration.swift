//
//  SDKConfiguration.swift
//  PaymentSDK
//
//  Created by Concerto on 18/06/26.
//

public final class SDKConfiguration {

   // public static let shared = SDKConfiguration()
    public let terminalId: String
        public let password: String
        public let merchantKey: String
        public let baseURL: String
    public let theme: SDKTheme
    

        public init(
            terminalId: String,
            password: String,
            merchantKey: String,
            baseURL: String,
            theme: SDKTheme = .light
        ) {
            self.terminalId = terminalId
            self.password = password
            self.merchantKey = merchantKey
            self.baseURL = baseURL
            self.theme = theme
        }
    }
