//
//  FirebaseService.swift
//  ebuddy-technical-test
//
//  Created by danny santoso on 12/19/24.
//

import Combine
import FirebaseFirestore

protocol FirebaseServiceProtocol {
    func getDocuments<Response: Decodable>(to type: Response.Type, collection path: String) -> AnyPublisher<[Response], Error>
}

final class FirebaseService {
    
    enum FirebaseServiceError: Error {
        case unknownError
        case decodingError
    }
    
    private let firestore: Firestore
    
    static func sharedInstance(firestore: Firestore) -> FirebaseService {
        return FirebaseService(firestore: firestore)
    }
    
    init(firestore: Firestore) {
        self.firestore = firestore
    }
}

extension FirebaseService: FirebaseServiceProtocol {
    func getDocuments<Response: Decodable>(to type: Response.Type, collection path: String) -> AnyPublisher<[Response], Error> {
        return Future<[Response], Error> { [weak self] completion in
            self?.firestore.collection(path).getDocuments() { (result, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let documents = result?.documents else {
                    completion(.failure(FirebaseServiceError.unknownError))
                    return
                }
                
                do {
                    let decodedData: [Response] = try documents.map { document in
                        guard let data = document.data().decode(to: Response.self) else {
                            throw FirebaseServiceError.decodingError
                        }
                        return data
                    }
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}
