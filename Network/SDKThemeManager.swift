//
//  SDKThemeManager.swift
//  PaymentSDK
//
//  Created by Concerto on 08/07/26.
//

final class SDKThemeManager {

    static let shared = SDKThemeManager()

    private init() {}

    var theme: SDKTheme = .light
}
