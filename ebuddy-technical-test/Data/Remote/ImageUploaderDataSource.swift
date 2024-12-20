//
//  ImageUploaderDataSource.swift
//  ebuddy-technical-test
//
//  Created by danny santoso on 12/20/24.
//

import Foundation
import Combine

protocol ImageUploaderDataSourceProtocol: AnyObject {
    func uploadImage(file data: Data, name fileName: String, type mimeType: String) -> AnyPublisher<ImageUploaderResponse, Error>
}

final class ImageUploaderDataSource: NSObject {
    
    private let service: UploaderServiceProtocol
    
    init(service: UploaderServiceProtocol) {
        self.service = service
    }
}

extension ImageUploaderDataSource: ImageUploaderDataSourceProtocol {
    func uploadImage(file data: Data, name fileName: String, type mimeType: String) -> AnyPublisher<ImageUploaderResponse, Error> {
        return service.upload(to: ImageUploaderResponse.self, url: URL(string: NSString.imageUploaderURL()), fileData: data, fileName: fileName, mimeType: mimeType)
    }
}
