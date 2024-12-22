//
//  UserCardView.swift
//  ebuddy-technical-test
//
//  Created by danny santoso on 12/20/24.
//

import SDWebImageSwiftUI
import SwiftUI

struct UserCardView: View {
    
    private let user: User
    
    init(user: User) {
        self.user = user
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.bgCardGeneral)
                .shadow(color: .gray.opacity(0.3), radius: 8, x: 0, y: 4)
            
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .center) {
                    if let name = user.name {
                        Text(name)
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.textPrimary)
                    }
                    if user.isVerified ?? false || user.instagramURL != nil {
                        HStack(spacing: 8) {
                            if let isVerified = user.isVerified, isVerified {
                                Image("verified")
                            }
                            if let instagramURL = user.instagramURL, !instagramURL.isEmpty {
                                Image("instagram")
                                    .renderingMode(.template)
                                    .foregroundStyle(.textPrimary)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
                .padding(.horizontal, 8)
                
                ZStack(alignment: .center) {
                    ZStack {
                        if let imageURL = user.imageURL {
                            WebImage(url: URL(string: imageURL))
                                .resizable()
                                .indicator(.activity)
                                .transition(.fade(duration: 0.5))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .frame(maxHeight: .infinity, alignment: .top)
                        }
                        
                        if user.isOnline ?? false {
                            HStack(alignment: .center, spacing: 4) {
                                Image("lightning")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundStyle(.textPrimary)
                                    .frame(width: 16, height: 16)
                                Text("Available today!")
                                    .font(.caption)
                                    .foregroundColor(.textPrimary)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.gray.opacity(0.8))
                            .clipShape(RoundedRectangle(cornerRadius: 100))
                            .padding(8)
                            .frame(maxHeight: .infinity, alignment: .top)
                        }
                    }
                    .frame(height: 200)
                    .frame(maxHeight: .infinity, alignment: .top)
                    
                    if let games = user.games, !games.isEmpty {
                        HStack {
                            ForEach(games.prefix(2), id: \.self) { game in
                                WebImage(url: URL(string: game))
                                    .resizable()
                                    .indicator(.activity)
                                    .transition(.fade(duration: 0.5))
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                        .padding(.horizontal, 8)
                    }
                }
                .frame(height: 220)
                
                if (user.ratting != nil && user.reviews != nil) || user.rate != nil {
                    VStack(alignment: .leading, spacing: 4) {
                        if let ratting = user.ratting, let reviews = user.reviews {
                            HStack(alignment: .center, spacing: 4) {
                                Image("star")
                                Text("\(ratting, specifier: "%.1f")")
                                    .font(.subheadline)
                                    .bold()
                                    .foregroundColor(.textPrimary)
                                Text("(\(reviews))")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                        }
                        if let rate = user.rate {
                            HStack(alignment: .center, spacing: 4) {
                                Image("flame")
                                Text("\(rate, specifier: "%.2f")/1Hr")
                                    .font(.subheadline)
                                    .foregroundColor(.textPrimary)
                            }
                        }
                    }
                    .padding(4)
                }
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 8)
        }
    }
}
