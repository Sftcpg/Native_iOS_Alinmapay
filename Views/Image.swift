//
//  Image.swift
//  PaymentSDK
//
//  Created by Concerto on 13/07/26.
//

import SwiftUI

extension Image {

    static func sdkImage(
        named name: String
    ) -> Image {

        let bundle =
            Bundle(for: LoaderManager.self)

        if let uiImage = UIImage(
            named: name,
            in: bundle,
            compatibleWith: nil
        ) {
            return Image(uiImage: uiImage)
        }

        return Image(systemName: "photo")
    }
}
