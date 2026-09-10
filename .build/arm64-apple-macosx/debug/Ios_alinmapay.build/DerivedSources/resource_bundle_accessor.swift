import Foundation

extension Foundation.Bundle {
    static nonisolated let module: Bundle = {
        let mainPath = Bundle.main.bundleURL.appendingPathComponent("Ios_alinmapay_Ios_alinmapay.bundle").path
        let buildPath = "/Users/admin/Documents/iOS/InApp/SDK/new/PaymentSDK/.build/arm64-apple-macosx/debug/Ios_alinmapay_Ios_alinmapay.bundle"

        let preferredBundle = Bundle(path: mainPath)

        guard let bundle = preferredBundle ?? Bundle(path: buildPath) else {
            // Users can write a function called fatalError themselves, we should be resilient against that.
            Swift.fatalError("could not load resource bundle: from \(mainPath) or \(buildPath)")
        }

        return bundle
    }()
}