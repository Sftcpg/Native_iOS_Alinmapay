//
//  HTMLUtility.swift
//  PaymentSDK
//
//  Created by Concerto on 02/07/26.
//

import Foundation

final class HTMLUtility {

    static func extractCReq(from html: String) -> String? {

        let pattern = #"name="creq"\s+value="([^"]+)""#

        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return nil
        }

        let range = NSRange(html.startIndex..., in: html)

        guard let match = regex.firstMatch(in: html, range: range) else {
            return nil
        }

        guard let valueRange = Range(match.range(at: 1), in: html) else {
            return nil
        }

        return String(html[valueRange])
    }

    static func generateHTML(
        acsURL: String,
        creq: String
    ) -> String {

        return """
        <!DOCTYPE html>

        <html>

        <head>
            <title>3DS Challenge</title>
        </head>

        <body onload="document.getElementById('CReqForm').submit();">

            <form id="CReqForm"
                  method="POST"
                  action="\(acsURL)">

                <input
                    type="hidden"
                    name="creq"
                    value="\(creq)" />

            </form>

        </body>

        </html>
        """
    }
}
