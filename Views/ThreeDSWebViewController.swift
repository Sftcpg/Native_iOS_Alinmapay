import UIKit
import WebKit

final class ThreeDSWebViewController: UIViewController {

    private var webView: WKWebView!
    private let html: String
    
    private var paymentCompleted = false

    init(html: String) {
        self.html = html
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {

        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true

        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = self

        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        webView.loadHTMLString(
            html,
            baseURL: nil
        )
    }
}
// MARK: - WKNavigationDelegate

extension ThreeDSWebViewController: WKNavigationDelegate {

    func webView(
        _ webView: WKWebView,
        didFinish navigation: WKNavigation!
    ) {

        print("3DS Page Loaded Successfully")
    }

//    func webView(
//        _ webView: WKWebView,
//        decidePolicyFor navigationAction: WKNavigationAction,
//        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
//    ) {
//
////        if let url = navigationAction.request.url {
////
////            print("Redirect URL:")
////            print(url.absoluteString)
////
////            // Change this according to your success/failure URL
////            if url.absoluteString.contains("notification") {
////
////                print("3DS Completed")
////
////                dismiss(animated: true)
////            }
////        }
//
//        if let url = navigationAction.request.url {
//
//               print("Redirect URL:")
//               print(url.absoluteString)
//
//               // Parse query parameters
//               if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
//                  let queryItems = components.queryItems {
//
//                   // Get data parameter
//                   if let dataValue = queryItems.first(where: { $0.name == "data" })?.value {
//
//                       print("===================================")
//                       print("Encrypted Response:")
//                       print(dataValue)
//                       print("===================================")
//                       
//                     
//                           
//                           let decodedData = dataValue.replacingOccurrences(of: " ", with: "+")
//                           
//                     
//                       
//                       guard let merchantKey = InAppSDK.shared.currentConfiguration?.merchantKey else {
//                           print("Merchant Key not found")
//                           return
//                       }
//
//                           //                                       let responsedata1 = """
////                       let merKey = InAppSDK.initialize(<#T##self: InAppSDK##InAppSDK#>)
////                       config.merchantKey
////                           
//                           
//                       let decryptedData = decryptData(encryptedResponse: decodedData, hexKey: merchantKey)
//                 
//                           print("Response Body : \(decryptedData)")
//                      
//                           
//                       }
//                       // Stop loading if required
//                       decisionHandler(.cancel)
//
//                       // Call your SDK callback/API
//                       //handlePaymentResponse(dataValue)
//
//                       return
//                   }
//
//                   // Get terminalId if required
////                   if let terminalId = queryItems.first(where: { $0.name == "termId" })?.value {
////
////                       print("Terminal Id : \(terminalId)")
//                  
//               
//           }
//        decisionHandler(.allow)
//    }

//    func webView(
//        _ webView: WKWebView,
//        decidePolicyFor navigationAction: WKNavigationAction,
//        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
//    ) {
//        
//        guard let url = navigationAction.request.url else {
//            decisionHandler(.allow)
//            return
//        }
//        
//        
//        print("Redirect URL:")
//        print(url.absoluteString)
//        
//        // Only process the final URL that contains data=
//        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
//           let queryItems = components.queryItems,
//           let dataValue = queryItems.first(where: { $0.name == "data" })?.value {
//            
//            print("Final Redirect Received")
//            print("Encrypted Response: \(dataValue)")
//            
//            let encodedData = dataValue.replacingOccurrences(of: " ", with: "+")
//            
//            guard let merchantKey = InAppSDK.shared.currentConfiguration?.merchantKey else {
//                decisionHandler(.allow)
//                return
//            }
//            
//            do {
//                
//                let decrypted = try DecryptionUtil.decodeAndDecryptV2(
//                    encryptedResponse: encodedData,
//                    merKey: merchantKey
//                )
//                
//                print(decrypted)
//                
//                // Notify merchant app
//                // InAppSDK.shared.delegate?.paymentDidSucceed(
//                //     response: decrypted
//                // )
//                
//            } catch {
//                //
//                //                InAppSDK.shared.delegate?.paymentDidFail(
//                //                    response:
//                //            )
//                
//                decisionHandler(.cancel)
//                
//                dismiss(animated: true)
//                
//                return
//            }
//            
//            // Allow every intermediate redirect
//            decisionHandler(.allow)
//        }
//    }
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {

        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }

        print("Redirect URL:")
        print(url.absoluteString)

        if url.absoluteString == "about:blank" {
              decisionHandler(.allow)
              return
          }

        
        // Allow all intermediate redirects
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {

            decisionHandler(.allow)
            return
        }

        // Final redirect contains encrypted response
        if let dataValue = queryItems.first(where: { $0.name == "data" })?.value {

            print("Final Redirect Received")
            guard !paymentCompleted else {
                   decisionHandler(.cancel)
                   return
               }

               paymentCompleted = true

            let encodedData = dataValue.replacingOccurrences(of: " ", with: "+")

            guard let merchantKey = InAppSDK.shared.currentConfiguration?.merchantKey else {

                decisionHandler(.allow)
                return
            }

            do {

                let decrypted = try DecryptionUtil.decodeAndDecryptV2(
                    encryptedResponse: encodedData,
                    merKey: merchantKey
                )

                print("===== DECRYPTED RESPONSE =====")
                print(decrypted)

                let jsonData = Data(decrypted.utf8)

                let response = try JSONDecoder().decode(
                    SubmitPaymentResponse.self,
                    from: jsonData
                )



              //  InAppSDK.shared.notifyPaymentResult(result)
                let result = response.toPaymentResult(rawJson: decrypted)

                decisionHandler(.cancel)
                DispatchQueue.main.async {

                    SDKNavigator.shared.closeAllSDKScreens {

                        InAppSDK.shared.notifyPaymentResult(result)
                    }
                }
                
                
                
                return

            } catch {

                print(error)

                decisionHandler(.cancel)
                return
            }
        }

        // Continue loading intermediate URLs
        decisionHandler(.allow)
    }
    func webView(
        _ webView: WKWebView,
        didFail navigation: WKNavigation!,
        withError error: Error
    ) {

        print("Navigation Error: \(error.localizedDescription)")
    }
    
    // AES decryption function
    func decryptData(encryptedResponse: String, hexKey: String) -> String? {
        // Convert the hex key to bytes
        let keyBytes = hexStringToBytes(hexKey)

        do {
            // Create AES object with ECB mode and PKCS7 padding
         //   let aes = try AES(key: keyBytes, blockMode: ECB(), padding: .pkcs7)
           
           // let merchantdata = Common.Globle.merchantKey
            print("Decryption merchantdata: \(hexKey)")
            // Base64 decode the encrypted string
            var base64Encoded = encryptedResponse
            let remainder = base64Encoded.count % 4
            if remainder != 0 {
                base64Encoded = base64Encoded.padding(toLength: base64Encoded.count + (4 - remainder), withPad: "=", startingAt: 0)
            }
            guard let encryptedData = Data(base64Encoded: base64Encoded) else {
                print("Failed to Base64 decode the input string")
                return nil
            }

            
            let decryptedText = try DecryptionUtil.decodeAndDecryptV2(encryptedResponse: encryptedResponse, merKey: hexKey)
               print("Decrypted Response Body : \(decryptedText)")
            //let decryptedBytes = "DATATATTATAT "

            // Convert decrypted bytes to a UTF-8 string
           // let decryptedString = "String(bytes: decryptedBytes, encoding: .utf8)"

            return decryptedText
        } catch {
            print("Decryption error: \(error)")
            return nil
        }
    }

func hexStringToBytes(_ hexString: String) -> [UInt8] {
    var startIndex = hexString.startIndex
    return stride(from: 0, to: hexString.count, by: 2).compactMap { _ in
        let endIndex = hexString.index(startIndex, offsetBy: 2)
        let byteString = hexString[startIndex..<endIndex]
        startIndex = endIndex
        return UInt8(byteString, radix: 16)
    }
}

}
