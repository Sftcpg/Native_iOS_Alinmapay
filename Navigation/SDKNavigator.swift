//
//  SDKNavigator.swift
//  PaymentSDK
//
//  Created by Concerto on 25/06/26.
//

import SwiftUI

final class SDKNavigator {

    static let shared = SDKNavigator()

    private init() {}

    func openPaymentScreen(
        response: InitiatePaymentResponse
    ) {

//        let paymentView = PaymentMethodView(
//          
//            transactionId: response.transactionId
//        )
//        let paymentView = PaymentMethodView(
//            supportedModes: response.supportedPaymentModes
//        )

        let paymentView = PaymentMethodDisp( paymentResponse: response,supportedModes:
                                                InAppSDK.shared
                                                    .supportedPaymentModes)
        
        let controller = UIHostingController(
            rootView: paymentView
        )

        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = scene.windows.first?.rootViewController {
            controller.modalPresentationStyle = .fullScreen
            rootVC.present(controller, animated: true)
        }
    }
    
    
    func openApplePayBottomSheet(
        request: PaymentRequest
    ) {

        let sheet = ApplePayBottomSheet(
            paymentRequest: request
        )

        let controller = UIHostingController(
            rootView: sheet
        )

        controller.modalPresentationStyle = .pageSheet

        self.topViewController()?.present(
            controller,
            animated: true
        )
    }
    
    
    func openThreeDSScreen(html: String) {

        DispatchQueue.main.async {

            let controller = ThreeDSWebViewController(html: html)
            controller.modalPresentationStyle = .fullScreen

            guard let topVC = self.topViewController() else {
                return
            }

            topVC.present(controller, animated: true)
        }
    }
    
    func closeAllSDKScreens(completion: (() -> Void)? = nil) {

        guard let rootVC = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first?
                .windows
                .first(where: { $0.isKeyWindow })?
                .rootViewController else {

            completion?()
            return
        }

        rootVC.dismiss(animated: true) {
            completion?()
        }
    }
    
    
    private func topViewController(
        controller: UIViewController? =
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first?
                .windows
                .first(where: { $0.isKeyWindow })?
                .rootViewController
    ) -> UIViewController? {

        if let nav = controller as? UINavigationController {
            return topViewController(controller: nav.visibleViewController)
        }

        if let tab = controller as? UITabBarController {
            return topViewController(controller: tab.selectedViewController)
        }

        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }

        return controller
    }	
}
