//
//  NetworkError.swift
//  PaymentSDK
//
//  Created by Concerto on 24/06/26.
//

enum NetworkError: Error {

    case invalidURL
    case invalidRequest
    case invalidResponse
    case noData
    case decodingError
    case serverError(Int)
}
