//
//  UserListCoordinator.swift
//  ebuddy-technical-test
//
//  Created by danny santoso on 12/21/24.
//

import SwiftUI

enum UserListDestination {
    case userDetail(User)
}

class UserListCoordinator: Coordinator {
    
    func navigate(to destination: UserListDestination) -> AnyView {
        switch destination {
        case .userDetail(let user):
            let viewModel = UserDetailViewModel(
                uploadImageUseCase: Injection.init().provideUploadImage(),
                updateImageProfileUseCase: Injection.init().provideUpdateImage(),
                user: user)
            return AnyView(DetailUserView(viewModel: viewModel))
        }
    }
}
