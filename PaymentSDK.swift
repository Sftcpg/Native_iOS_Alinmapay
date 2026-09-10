//
//  PaymentSDK.swift
//  PaymentSDK
//
//  Created by Concerto on 18/06/26.
//

import Foundation
public import Combine
import UIKit


public final class InAppSDK : ObservableObject  {

    public static let shared = InAppSDK()
    var requestHash:String = ""
    var data: String = ""
    
    private init() {}
//    @Published public var apicardBrand: String = ""
    @Published public var apipaymentInst: String = ""
    var onCardBrandReceived: ((String) -> Void)?
    private(set) var supportedPaymentModes: [String] = []
    public private(set) var configuration: SDKConfiguration?
    public weak var delegate: PaymentDelegate?
    // Callback
    private var paymentCompletion: ((PaymentResult) -> Void)?
    
    internal var paymentRequest: PaymentRequestData?
    
    public func initialize(
        configuration: SDKConfiguration
    ) {

        self.configuration = configuration
        SDKThemeManager.shared.theme = configuration.theme
        print("SDK Initialized")
        print("Terminal Id : \(configuration.terminalId)")
        print("BASE URL : \(configuration.baseURL)")
    }
    
    public var currentConfiguration: SDKConfiguration? {
        return configuration
    }
    // Add this
       public var merchantKey: String? {
           return configuration?.merchantKey
       }
    
    
    public func startPayment(
        request: PaymentRequestData,
        completion: @escaping (PaymentResult) -> Void
    ) {

           self.paymentRequest = request
           self.paymentCompletion = completion

        guard let config = configuration else {
            return
        }
        getSupportedPaymentMethod { [weak self] result in

                guard let self = self else { return }

                switch result {

                case .success(let response):

                    print("Supported Modes : \(response.supportedPaymentModes)")

                    self.supportedPaymentModes =
                        response.supportedPaymentModes
                    
        let signature = Utility.generateSignature(
            orderId: request.trackId,
            terminalId: config.terminalId,
            password: config.password,
            merchantKey: config.merchantKey,
            amount: request.amount,
            currency: request.currency
        )
        
        
        let apiRequest = InitiatePaymentRequest(

            terminalId: config.terminalId,
            password: config.password,

            paymentType: request.transactionType,
            currency: request.currency,
            amount: request.amount,
            referenceID:request.transactionId,
            order: Order(
                orderId: request.trackId,
                        description: ""
                        ),
            
            customer: Customer(
                                 customerEmail: request.email,
                                 billingAddressStreet: "Ram Nagar Ayodhya",
                                 billingAddressCity: "UK",
                                 billingAddressState: "MH",
                                 billingAddressPostalCode: "210210",
                                 billingAddressCountry: request.countryCode
                              ),
                                paymentInstrument: PaymentInstrument(
                                    paymentMethod: "CCI"
                                ),
                                additionalDetails: ReqAdditionalDetails(
                                    userData: ""
                                ),
                                tokenization: Tokenization(
                                    operation: request.cardOperation,
                                    cardToken: request.cardToken
                                ),
            merchantIP: "10.10.11.94",
            customerIP: "10.10.11.94",

            tokenizationType: "3DS2",

            signature: signature
        )
        
    
       // initiatePayment(apiRequest)
                    
                    self.initiatePayment(apiRequest)

                 case .failure(let error):

                     print(
                         "Get Supported Payment Method Failed : \(error)"
                     )

                     let result =
                         PaymentResult(
                             rawJson: nil,
                             transactionId: nil,
                             transactionDateTime: nil,
                             result: "FAILURE",
                             responseCode: "999",
                             responseDescription:
                                 "Unable to fetch supported payment methods.",
                             orderId: nil,
                             amount: nil,
                             originalAmount: nil,
                             paymentMethod: nil,
                             maskedCard: nil,
                             cardBrand: nil,
                             cardToken: nil,
                             cardHolderName: nil,
                             signature: nil,
                             terminalId: nil
                         )

                     completion(result)
                 }
             }
         }
    // MARK: - Internal SDK Method

        private func initiatePayment(
            _ request: InitiatePaymentRequest
        ) {

            guard let jsonData = try? JSONEncoder().encode(request)
            else {
                return
            }
            
            
            print("===== REQUEST =====")
            print(String(data: jsonData, encoding: .utf8) ?? "")


            APIManager.shared.request(
                endpoint: .initiatePayment,
                body: jsonData
            ) { [weak self] result in
                
                
                

                switch result {

                case .success(let data):

                    self?.handleInitiateResponse(data)

                case .failure(let error):

                    print(error.localizedDescription)
                }
            }
        }
    
    
    private func initiateApplepayPayment(
        _ request: InitiateApplePay
    ) {

        guard let jsonData = try? JSONEncoder().encode(request)
        else {
            return
        }
        
        
        print("===== REQUEST =====")
        print(String(data: jsonData, encoding: .utf8) ?? "")


        APIManager.shared.request(
            endpoint: .initiatePayment,
            body: jsonData
        ) { [weak self] result in
            
            
            

            switch result {

            case .success(let data):
                let datat1 = String(
                    data: data,
                    encoding: .utf8
                ) ?? "{}"
                print("Response Run: \(datat1)")
                self?.handleInitiateResponse(data)

            case .failure(let error):

                print(error.localizedDescription)
            }
        }
    }

    private func handleInitiateResponse(_ data: Data) {

        do {

            let response = try JSONDecoder().decode(
                InitiatePaymentResponse.self,
                from: data
            )
            print("Data : \(data)")

            let rawJson = String(
                data: data,
                encoding: .utf8
            ) ?? "{}"
            
//            print("Transaction Id : \(response.transactionId)")
//            print("Response Code : \(response.responseCode)")
//            print("Order Id : \(response.orderDetails.orderId)")
//            print("Result : \(response.result ??  "")")

            if response.responseCode != "001" {
                
             
//                print(response.responseDescription)
                _ = response.result
                print(rawJson)
                let result = response.toPaymentResult(rawJson: rawJson)
            //    print(response.responseDescription ?? "")
              
                DispatchQueue.main.async {
                   
                    SDKNavigator.shared.closeAllSDKScreens
                    {
                        self.notifyPaymentResult(result)
                    }
                }
               
                          return
                  }
           else
            {
               DispatchQueue.main.async {
                   SDKNavigator.shared.openPaymentScreen(
                    response: response
                   )
               }
           }
        } catch {

            print(error)
        }
    }
    
    internal func notifyPaymentResult(
        _ result: PaymentResult
    ) {

        DispatchQueue.main.async {

            self.paymentCompletion?(result)
        }
    }
    
    
    func submitPayment(
        request: SubmitPaymentRequest
    ) {

        do {

            let jsonData = try JSONEncoder().encode(request)
            print(String(data: jsonData, encoding: .utf8) ?? "")
            LoaderManager.shared.show()
            

            APIManager.shared.request(

                endpoint: .submitPaymentDetails,

                body: jsonData

            ) { result in

                
                LoaderManager.shared.hide()
                
                switch result {

                case .success(let data):
                    print("Payment Datat")
                    self.handleSubmitPayment(data)

                case .failure(let error):
                   // let respjsonData = try JSONEncoder().encode(data)
                    print("Payment Failed")

                    print(error)
                }
            }

        } catch {

            print(error)
        }
    }
    
    func submitCVVPayment(
        request: SubmitPaymentRequest
    ) {
//        4111114626771111
        do {

            let jsonData = try JSONEncoder().encode(request)
            print(String(data: jsonData, encoding: .utf8) ?? "")
            
            
            LoaderManager.shared.show()
            

            APIManager.shared.request(

                endpoint: .submitCVVPaymentDetails,

                body: jsonData

            ) { result in

                
                LoaderManager.shared.hide()
                
                switch result {

                case .success(let data):
                    print("Payment Datat1")
                    self.handleSubmitPayment(data)

                case .failure(let error):
                  // let respjsonData = try JSONEncoder().encode(data)
                  print("Payment Failed")
                  //  print(respjsonData)
                    
//                let result = data.toPaymentResult()
//
//              DispatchQueue.main.async {
//                  // paymentCompletion?(result)/
//                  SDKNavigator.shared.closeAllSDKScreens {
//
//                      self.notifyPaymentResult(result)
//                  }
//              }
                    print(error)
                }
            }

        } catch {

            print(error)
        }
    }
    
    // SUPPORTED PAYMENT
    public func getSupportedPaymentMethod(
        completion: @escaping (
            Result< SupportedPaymentMethodResponse,
                Error
            >
        ) -> Void
    ) {

        guard let requestHeader =
                createRequestHeader()
        else {
            completion(
                .failure(
                    NetworkError.invalidRequest
                )
            )
            return
        }

        let headers = [
            "requestHeader": requestHeader
        ]

        APIManager.shared.request(
            endpoint: .getSupportedPaymentMethod,
            method: "POST",
            body: nil,
            headers: headers
        ) { result in

            switch result {

            case .success(let data):

                do {

                    let response =
                        try JSONDecoder().decode(
                            SupportedPaymentMethodResponse.self,
                            from: data
                        )

                    completion(
                        .success(response)
                    )

                } catch {
                    completion(
                        .failure(error)
                    )
                }

            case .failure(let error):
                completion(
                    .failure(error)
                )
            }
        }
    }
    
    private func createRequestHeader() -> String? {

        guard let configuration =
                InAppSDK.shared.configuration
        else {
            return nil
        }

        let header = SupportedPaymentMethodHeader(
            terminalId: configuration.terminalId,
            password: configuration.password
        )

        do {

            let data =
                try JSONEncoder().encode(header)

            return data.base64EncodedString()

        } catch {

            print("Header Encoding Error : \(error)")
            return nil
        }
    }
    
    private func handleSubmitPayment(
        _ data: Data
    ) {

        print("===== SUBMIT PAYMENT RESPONSE =====")

         if let responseString = String(data: data, encoding: .utf8) {
             print(responseString)
         }
        do {

            let response = try JSONDecoder().decode(

                SubmitPaymentResponse.self,

                from: data
            )
            let rawJson = String(data: data, encoding: .utf8) ?? "{}"
            print("===== SUBMIT PAYMENT RESPONSE  \(response.status)")


            if response.responseCode == "005" {
                print(response.identifierFlag ?? "")
                DispatchQueue.main.async {
                    self.openThreeDS(response)
                }

                return

            }
            else
            {
                           print(response.responseDescription ?? "")
                            let result = response.toPaymentResult(rawJson: rawJson)
                
                           DispatchQueue.main.async {
                
                               SDKNavigator.shared.closeAllSDKScreens {
                
                                   self.notifyPaymentResult(result)
                               }
                           }
            }

        }
        catch {

            print(error)
        }
    }
    
    
    private func openThreeDS(
        _ response: SubmitPaymentResponse
    ) {

        DispatchQueue.main.async {
            // Check if 3DS Challenge response is available
                   guard let challengeResponse = response.threeDSChallengeResponse else {

                       print("3DS Challenge Response not found")
                       return
                   }

            

            // Extract CReq from redirect HTML
                 guard let creq = HTMLUtility.extractCReq(
                     from: challengeResponse.redirectHtml
                 ) else {

                     print("Unable to extract CReq")
                     return
                 }

            // Generate HTML for WebView
                   let html = HTMLUtility.generateHTML(
                       acsURL: challengeResponse.acsUrl,
                       creq: creq
                   )

            SDKNavigator.shared.openThreeDSScreen(
                html: html
            )
        }
    }
    
    public func getCardBrandDetails(cardBin: String) {
    fetchCardBrandDetails(cardBin: cardBin)
}

private func fetchCardBrandDetails(cardBin: String) {

    APIManager.shared.request(
        endpoint: .getCardBrandDetails(cardBin),
        method: "POST"
    ) { [weak self] result in

        switch result {

        case .success(let data):
            self?.handleCardBrandResponse(data)

        case .failure(let error):
            print(error)
        }
    }
}
    private func handleCardBrandResponse(
        _ data: Data
    ) {

        do {

            print("===== CARD BRAND RESPONSE =====")
            print(String(data: data, encoding: .utf8) ?? "")

            let response = try JSONDecoder().decode(
                [String: [String]].self,
                from: data
            )

            guard let values = response["1"] else {
                return
            }

            print("Brand : \(values[0])")
            print("Payment Method : \(values[10])")
            
            let brand = values[0]
            let paymentMethod = values[10]
            DispatchQueue.main.async {
                self.onCardBrandReceived?(brand)
                      InAppSDK.shared.apipaymentInst = paymentMethod
                  }

        } catch {

            print("Decode Error : \(error)")
        }
    }
    
    public func startApplePay(
        request: PaymentRequestData,
        completion: @escaping (PaymentResult) -> Void
    ) {

        self.paymentRequest = request
        self.paymentCompletion = completion
        
        guard let config = configuration else {
            return
        }
        
        ApplePayManager.shared.onPaymentKeyGenerated =
              { [weak self] paymentKey in

                  guard let self = self else {
                      return
                  }

                  // Now create the API request
                  self.createInitiateApplePayRequest(
                      request: request,
                      config: config,
                      paymentKey: paymentKey
                  )
              }

          // Only start Apple Pay
          ApplePayManager.shared.startApplePay(
              request: request
          )
        
   
      
    }
    
    
    private func createInitiateApplePayRequest(
        request: PaymentRequestData,
        config: SDKConfiguration,
        paymentKey: String
    ) {

        var deviceInfo:[String: Any] = [:]
        var deviceInfoJsonString:String = ""
        
        
        let ModelName = UIDevice.current.name
        let version = UIDevice.current.systemVersion
        let platfrom = UIDevice.current.model
        
        let signature = Utility.generateSignature(
            orderId: request.trackId,
            terminalId: config.terminalId,
            password: config.password,
            merchantKey: config.merchantKey,
            amount: request.amount,
            currency: request.currency
        )

        let apiRequest = InitiateApplePay(

            terminalId: config.terminalId,

            password: config.password,

            paymentType: request.transactionType,

            currency: request.currency,

            amount: request.amount,

            referenceID: request.transactionId,
            order: Order(
                orderId: request.trackId,
                description: ""
            ),

           

           

            customer: Customer(
                customerEmail: request.email,
                billingAddressStreet: "Ram Nagar Ayodhya",
                billingAddressCity: "UK",
                billingAddressState: "MH",
                billingAddressPostalCode: "210210",
                billingAddressCountry: request.countryCode
            ),

            merchantIP: "10.10.11.94",

            customerIP: "10.10.11.94",
            paymentInstrument: PaymentInstrument(
                paymentMethod: "APPLEPAY"
            ),

          

            // THIS IS THE IMPORTANT PART
            PaymentToken: paymentKey,
            
            additionalDetails: ReqAdditionalDetails(
                userData: ""
            ),
            
            tokenization: Tokenization(
                operation: request.cardOperation,
                cardToken: request.cardToken
            ),
            
            deviceInfo: DeviceInfo(deviceModel: ModelName, pluginVersion: "1.0.0", clientPlatform: platfrom, devicePlatform: platfrom, deviceOSVersion: version, pluginName: "Native iOS"),
           

         

            signature: signature
        )

        print("===== INITIATE APPLE PAY REQUEST CREATED =====")

        // THIS IS WHAT YOU WANT
        self.initiateApplepayPayment(apiRequest)
    }
}
    
    
