//
//  UserListView.swift
//  ebuddy-technical-test
//
//  Created by danny santoso on 12/19/24.
//

import SwiftUI

struct UserListView: View {
    @StateObject private var viewModel: UserListViewModel
    
    init(viewModel: UserListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            if viewModel.loadingState {
                Text("Loading")
            } else {
                VStack {
                    if let users = viewModel.users {
                        List {
                            ForEach(users, id: \.id) { user in
                                VStack {
                                    Text(user.id)
                                    if let email = user.email {
                                        Text(email)
                                    }
                                    if let phone = user.phone {
                                        Text(phone)
                                    }
                                    if let gender = user.gender?.stringValue {
                                        Text(gender)
                                    }
                                }
                            }
                        }
                    } else if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
            }
        }.onAppear {
            viewModel.fetchUser()
        }.navigationBarTitle(
            Text("Users"),
            displayMode: .automatic
        )
    }
}
