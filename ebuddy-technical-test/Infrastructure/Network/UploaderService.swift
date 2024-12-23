//
//  UploaderService.swift
//  ebuddy-technical-test
//
//  Created by danny santoso on 12/20/24.
//

import Alamofire
import Combine
import Foundation
import UIKit

protocol UploaderServiceProtocol: AnyObject {
    func upload(
        url: URL?,
        headers: [String: String],
        parameters: [String: Any],
        fileData: Data,
        fileName: String,
        mimeType: String
    ) -> AnyPublisher<ImageUploaderResponse, Error>
}

extension UploaderServiceProtocol {
    func upload(
        url: URL?,
        headers: [String: String] = [:],
        parameters: [String: Any] = [:],
        fileData: Data,
        fileName: String,
        mimeType: String
    ) -> AnyPublisher<ImageUploaderResponse, Error> {
        upload(
            url: url,
            headers: headers,
            parameters: parameters,
            fileData: fileData,
            fileName: fileName,
            mimeType: mimeType
        )
    }
}

final class UploaderService: NSObject, UploaderServiceProtocol {
    
    enum UploaderServiceError: Error {
        case unknownError
        case urlNotFound
        case decodingError
        case invalidResponse
        case noData
    }
    
    var session: URLSession?
    
    private let urlSessionSubject = PassthroughSubject<ImageUploaderResponse, Error>()
    
    init(config: URLSessionConfiguration) {
        super.init()
        self.session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }
    
    static var sharedInstance: UploaderService = {
        let config = URLSessionConfiguration.background(withIdentifier: "com.dannysantoso.ebuddy-technical-test.background.upload")
        config.isDiscretionary = true
        return UploaderService(config: config)
    }()
    
    func upload(
        url: URL?,
        headers extra: [String: String] = [:],
        parameters: [String: Any] = [:],
        fileData: Data,
        fileName: String,
        mimeType: String
    ) -> AnyPublisher<ImageUploaderResponse, Error> {
        let boundary = "Boundary-\(UUID().uuidString)"
        var headers: [String: String] = [
            "Content-Type": "multipart/form-data; boundary=\(boundary)",
            "Accept": "application/json"
        ]
        if let apiKey = Bundle.main.infoDictionary?["IMAGEKIT_API_KEY"] as? String {
            headers["Authorization"] = "Basic \(apiKey)"
        }
        headers.merge(extra) { current, _ in current }
        
        guard let url, let session else { return Fail(error: UploaderServiceError.urlNotFound).eraseToAnyPublisher() }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        var body = Data()
        
        for (key, value) in parameters {
            guard let stringValue = value as? String else { continue }
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(stringValue)\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"fileName\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(fileName)\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName).png\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(fileData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        do {
            let fileURL = try createTemporaryFile(from: body, with: fileName)
            let task = session.uploadTask(with: request, fromFile: fileURL)
            task.resume()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return urlSessionSubject.eraseToAnyPublisher()
    }
    
    private func createTemporaryFile(from data: Data, with fileName: String) throws -> URL {
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileURL = tempDirectory.appendingPathComponent(fileName)
        try data.write(to: fileURL)
        return fileURL
    }
}

extension UploaderService: URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let fileURL = (task as? URLSessionUploadTask)?.originalRequest?.url {
            try? FileManager.default.removeItem(at: fileURL)
        }
        
        if let error = error {
            urlSessionSubject.send(completion: .failure(error))
        } else if let httpResponse = task.response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
            urlSessionSubject.send(completion: .finished)
        } else {
            urlSessionSubject.send(completion: .failure(UploaderServiceError.invalidResponse))
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        do {
            let decodedResponse = try JSONDecoder().decode(ImageUploaderResponse.self, from: data)
            urlSessionSubject.send(decodedResponse)
        } catch {
            urlSessionSubject.send(completion: .failure(UploaderServiceError.decodingError))
        }
    }
}

extension UploaderService: URLSessionDelegate {
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        print("Background URLSession finished")
    }
}
