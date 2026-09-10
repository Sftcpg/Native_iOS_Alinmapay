//
//  APIManager.swift
//  PaymentSDK
//
//  Created by Concerto on 18/06/26.
//

import Foundation

final class APIManager {

    static let shared = APIManager()
    var configuration: SDKConfiguration?
    private init() {}

    func request(
        endpoint: APIEndpoint,
        method: String = "POST",
        body: Data? = nil,
        headers: [String: String] = [:],
        completion: @escaping (Result<Data, Error>) -> Void
    ) {

        
        
        guard let baseURL =
                InAppSDK.shared.configuration?.baseURL else {
            print("❌ baseURL is nil")
            completion(.failure(NetworkError.invalidURL))
            return
        }

        print("✅ Base URL: \(baseURL)")
        print("✅ Endpoint: \(endpoint.path)")
        print("✅ Full URL: \(baseURL + endpoint.path)")

        guard let url = URL(string: baseURL + endpoint.path) else {
            print("❌ Invalid URL: \(baseURL + endpoint.path)")
            completion(.failure(NetworkError.invalidURL))
            return
        }

        print("URL \(url)")
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        request.timeoutInterval = 60

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        headers.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                completion(.failure(error))
                return
            }
            print("===== RESPONSE =====")
           
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            print("===== HTTP STATUS =====")
              print(httpResponse.statusCode)

              print("===== HEADERS =====")
              print(httpResponse.allHeaderFields)

              if let data = data {

                  print("===== RAW RESPONSE =====")
                  print("Data Length : \(data.count)")

                  if let responseString = String(data: data, encoding: .utf8) {
                      print(responseString)
                  } else {
                      print("Unable to convert response to UTF-8")
                      print(data as NSData)
                  }

              } else {

                  print("Response data is nil")
              }

            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.serverError(httpResponse.statusCode)))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }

            completion(.success(data))

        }.resume()
    }
}
