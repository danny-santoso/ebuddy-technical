//
//  HomeViewModel.swift
//  ebuddy-technical-test
//
//  Created by danny santoso on 12/19/24.
//

import Foundation
import Combine

final class UserListViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let fetchUserUseCase: FetchUserUseCase
    
    @Published var users: [User]?
    @Published var errorMessage: String?
    @Published var loadingState: Bool = false
    
    init(fetchUserUseCase: FetchUserUseCase) {
        self.fetchUserUseCase = fetchUserUseCase
    }
    
    func fetchUser() {
        loadingState = true
        fetchUserUseCase.execute(gender: .female)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .failure:
                    self.errorMessage = String(describing: completion)
                case .finished:
                    self.loadingState = false
                }
            }, receiveValue: { [weak self] users in
                self?.users = users
            })
            .store(in: &cancellables)
    }
}
