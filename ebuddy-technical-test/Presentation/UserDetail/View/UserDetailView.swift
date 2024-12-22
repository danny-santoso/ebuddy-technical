//
//  UserDetailView.swift
//  ebuddy-technical-test
//
//  Created by danny santoso on 12/21/24.
//

import SDWebImageSwiftUI
import SwiftUI

struct DetailUserView: View {
    
    @StateObject private var viewModel: UserDetailViewModel
    
    init(viewModel: UserDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            if let imageURL = viewModel.user.imageURL{
                Button(action: {
                    viewModel.isPickerPresented.toggle()
                }) {
                    WebImage(url: URL(string: imageURL))
                        .resizable()
                        .indicator(.activity)
                        .transition(.fade(duration: 0.5))
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                        .padding(16)
                }
                .sheet(isPresented: $viewModel.isPickerPresented) {
                    ImagePickerView(selectedImage: $viewModel.selectedImage)
                }
            }
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("Name: ")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    Text(viewModel.user.name ?? "-")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .foregroundColor(.textPrimary)
                }
                HStack {
                    Text("Gender: ")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    Text(viewModel.user.gender?.stringValue ?? "-")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .foregroundColor(.textPrimary)
                }
                HStack {
                    Text("Email: ")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    Text(viewModel.user.email ?? "-")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .foregroundColor(.textPrimary)
                }
                HStack {
                    Text("Rate:")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    if let rate = viewModel.user.rate {
                        Text("\(rate, specifier: "%.2f")/1Hr")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .foregroundColor(.textPrimary)
                    } else {
                        Text("-")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .foregroundColor(.textPrimary)
                    }
                }
                if let games = viewModel.user.games, !games.isEmpty {
                    Text("List Of Games")
                        .font(.title3)
                        .bold()
                        .padding(.top, 20)
                        .foregroundColor(.textPrimary)
                    HStack {
                        ForEach(games.prefix(2), id: \.self) { game in
                            WebImage(url: URL(string: game))
                                .resizable()
                                .indicator(.activity)
                                .transition(.fade(duration: 0.5))
                                .frame(width: 70, height: 70)
                                .clipShape(Circle())
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .padding(32)
    }
}
