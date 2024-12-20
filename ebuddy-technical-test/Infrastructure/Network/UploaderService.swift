//
//  UploaderService.swift
//  ebuddy-technical-test
//
//  Created by danny santoso on 12/20/24.
//

import Alamofire
import Combine
import Foundation

protocol UploaderServiceProtocol: AnyObject {
    func upload<Response: Decodable>(
        to type: Response.Type,
        url: URL?,
        headers: [String: String],
        parameters: [String: Any],
        fileData: Data,
        fileName: String,
        mimeType: String
    ) -> AnyPublisher<Response, Error>
}

extension UploaderServiceProtocol {
    func upload<Response: Decodable>(
        to type: Response.Type,
        url: URL?,
        headers: [String: String] = [:],
        parameters: [String: Any] = [:],
        fileData: Data,
        fileName: String,
        mimeType: String
    ) -> AnyPublisher<Response, Error> {
        upload(
            to: type,
            url: url,
            headers: headers,
            parameters: parameters,
            fileData: fileData,
            fileName: fileName,
            mimeType: mimeType
        )
    }
}

final class UploaderService: UploaderServiceProtocol {
    
    enum UploaderServiceError: Error {
        case unknownError
        case urlNotFound
        case decodingError
    }
    
    private let urlSession: URLSession
    
    static func sharedInstance(urlSession: URLSession) -> UploaderService {
        return UploaderService(urlSession: urlSession)
    }
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func upload<Response: Decodable>(
        to type: Response.Type,
        url: URL?,
        headers extra: [String: String] = [:],
        parameters: [String: Any] = [:],
        fileData: Data,
        fileName: String,
        mimeType: String
    ) -> AnyPublisher<Response, Error> {
        let boundary = "Boundary-\(UUID().uuidString)"
        var headers: [String: String] = [
            "Content-Type": "multipart/form-data; boundary=\(boundary)",
            "Accept": "application/json",
            "Authorization": "Basic "
        ]
        headers.merge(extra) { first, _ in first }
        
        return Future<Response, Error> { promise in
            guard let url else { return promise(.failure(UploaderServiceError.urlNotFound)) }
            AF.upload(
                multipartFormData: { multipartFormData in
                    for (key, value) in parameters {
                        guard let stringValue = value as? String else { continue }
                        multipartFormData.append(Data(stringValue.utf8), withName: key)
                    }
                    multipartFormData.append(Data(fileName.utf8), withName: "fileName")
                    multipartFormData.append(fileData, withName: "file", fileName: "\(fileName).png", mimeType: mimeType)
                },
                to: url,
                headers: HTTPHeaders(headers)
            )
            .validate()
            .responseDecodable(of: Response.self) { response in
                switch response.result {
                case .success(let data):
                    promise(.success(data))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
