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
        ZStack(alignment: .topLeading) {
            if viewModel.loadingState {
                Text("Loading")
            } else {
                VStack {
                    if let users = viewModel.users {
                        ScrollView(.horizontal) {
                            LazyHStack(alignment: .center, spacing: 16) {
                                ForEach(users) { user in
                                    viewModel.linkBuilder(for: user, content: {
                                        UserCardView(user: user)
                                            .frame(width: 170, height: 340)
                                            .frame(maxHeight: .infinity, alignment: .top)
                                    }).buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding()
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
