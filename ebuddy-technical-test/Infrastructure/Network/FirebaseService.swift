//
//  FirebaseService.swift
//  ebuddy-technical-test
//
//  Created by danny santoso on 12/19/24.
//

import Combine
import FirebaseFirestore

protocol FirebaseServiceProtocol {
    func getDocuments<Response: Decodable>(
        to type: Response.Type,
        collection path: String,
        filters: [(field: String, value: Any)],
        sorting: [(field: String, descending: Bool)]
    ) -> AnyPublisher<[Response], Error>
}

extension FirebaseServiceProtocol {
    func getDocuments<Response: Decodable>(
        to type: Response.Type,
        collection path: String,
        filters: [(field: String, value: Any)] = [],
        sorting: [(field: String, descending: Bool)] = []
    ) -> AnyPublisher<[Response], Error> {
        getDocuments(
            to: type,
            collection: path,
            filters: filters,
            sorting: sorting)
    }
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
    func getDocuments<Response: Decodable>(
        to type: Response.Type,
        collection path: String,
        filters: [(field: String, value: Any)] = [],
        sorting: [(field: String, descending: Bool)] = []
    ) -> AnyPublisher<[Response], Error> {
        return Future<[Response], Error> { [weak self] completion in
            guard let self = self else {
                completion(.failure(FirebaseServiceError.unknownError))
                return
            }
            
            var query: Query = self.firestore.collection(path)
            
            for filter in filters {
                query = query.whereField(filter.field, isEqualTo: filter.value)
            }
            
            for sort in sorting {
                query = query.order(by: sort.field, descending: sort.descending)
            }
            
            query.getDocuments { (result, error) in
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
