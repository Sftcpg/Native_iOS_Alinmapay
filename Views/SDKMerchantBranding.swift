//
//  SDKMerchantBranding.swift
//  PaymentSDK
//
//  Created by Concerto on 04/09/26.
//

import SwiftUI
import UIKit

public struct SDKMerchantBranding {

    public enum BrandingType {
        case none
        case logo
        case text
    }

    public var type: BrandingType
    public var logo: UIImage?
    public var text: String?

    public init() {
        self.type = .none
        self.logo = nil
        self.text = nil
    }

    public static func logo(_ image: UIImage) -> SDKMerchantBranding {
        var branding = SDKMerchantBranding()
        branding.type = .logo
        branding.logo = image
        return branding
    }

    public static func text(_ value: String) -> SDKMerchantBranding {
        var branding = SDKMerchantBranding()
        branding.type = .text
        branding.text = value
        return branding
    }

    public static func none() -> SDKMerchantBranding {
        return SDKMerchantBranding()
    }
}
