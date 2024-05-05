//
//  NetworkService.swift
//  AcharyaPrashantApp
//
//  Created by Sathiyaraj on 04/05/24.
//
import Foundation
import UIKit
public enum NetworkError: Error {
    case networkError(Error)
    case invalidResponse
    case httpError(Int)
    case noData
    case authenticationError
    case decodingError(Error)
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    // Add more HTTP methods as needed
}

public class NetworkService {
    public static let shared = NetworkService()
    private init() {}
    
    static public func request<T: Decodable>(url: URL, method: HTTPMethod, parameters: [String: Any]? = nil, multipartFormData: MultipartFormData? = nil, responseType: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // Add POST parameters if provided
        if let parameters = parameters, method == .post {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = parameters.queryString.data(using: .utf8)
        }
        
        // Add multipart form data if provided
        if let multipartFormData = multipartFormData {
            let boundary = multipartFormData.boundary
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpBody = multipartFormData.body
        }
       
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error occurred: \(error)")
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            switch httpResponse.statusCode {
            case 200..<300:
                guard let data = data else {
                    print("No data received")
                    completion(.failure(.noData))
                    return
                }
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    print("Data decoded successfully")
                    completion(.success(decodedData))
                } catch let decodingError {
                    print("Error decoding data: \(decodingError)")
                    completion(.failure(.decodingError(decodingError)))
                }
            case 401:
                completion(.failure(.authenticationError))
            default:
                completion(.failure(.httpError(httpResponse.statusCode)))
            }
        }.resume()
    }
}

// Extension to convert dictionary to query string
extension Dictionary where Key == String, Value == Any {
    var queryString: String {
        var output = ""
        for (key, value) in self {
            let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let encodedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            output += "\(encodedKey)=\(encodedValue)&"
        }
        return String(output.dropLast())
    }
}

// Struct to handle multipart form data
public struct MultipartFormData {
    let boundary: String
    let body: Data
}
extension Dictionary where Key == String, Value == Data {
    var multipartFormData: MultipartFormData {
        let boundary = UUID().uuidString
        var body = Data()
        for (key, value) in self {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(key)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!)
            body.append(value)
            body.append("\r\n".data(using: .utf8)!)
        }
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return MultipartFormData(boundary: boundary, body: body)
    }
}
