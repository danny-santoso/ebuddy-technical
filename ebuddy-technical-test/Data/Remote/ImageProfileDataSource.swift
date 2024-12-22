//
//  ImageProfileDataSource.swift
//  ebuddy-technical-test
//
//  Created by danny santoso on 12/22/24.
//

import FirebaseFirestore
import Foundation
import Combine

protocol ImageProfileRemoteDataSourceProtocol: AnyObject {
    func updateImageProfile(userId: String, imageURL: String) -> AnyPublisher<Void, Error>
}

final class ImageProfileRemoteDataSource: NSObject {
    
    private let service: FirebaseServiceProtocol
    
    init(service: FirebaseServiceProtocol) {
        self.service = service
    }
}

extension ImageProfileRemoteDataSource: ImageProfileRemoteDataSourceProtocol {
    func updateImageProfile(userId: String, imageURL: String) -> AnyPublisher<Void, Error> {
        return service.updateFields(inCollection: "USERS", documentID: userId, fields: ["imageURL": imageURL])
    }
}
