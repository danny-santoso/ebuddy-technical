//
//  ImageProfileRepository.swift
//  ebuddy-technical-test
//
//  Created by danny santoso on 12/22/24.
//

import Foundation
import Combine

protocol ImageProfileRepositoryProtocol: AnyObject {
    func updateImageProfile(userId: String, imageURL: String) -> AnyPublisher<Void, Error>
}

final class ImageProfileRepository: NSObject {
    
    private let dataSource: ImageProfileRemoteDataSourceProtocol
    
    init(dataSource: ImageProfileRemoteDataSourceProtocol) {
        self.dataSource = dataSource
    }
}

extension ImageProfileRepository: ImageProfileRepositoryProtocol {
    func updateImageProfile(userId: String, imageURL: String) -> AnyPublisher<Void, Error> {
        return dataSource.updateImageProfile(userId: userId, imageURL: imageURL)
    }
}
