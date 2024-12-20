//
//  UserMapper.swift
//  ebuddy-technical-test
//
//  Created by danny santoso on 12/19/24.
//

final class UserMapper {
    static func mapUserResponsesToDomains(input userResponses: [UserResponse]) -> [User] {
        return userResponses.compactMap { response in
            guard let id = response.id else { return nil }
            return User(
                id: id,
                name: response.name,
                email: response.email,
                phone: response.phone,
                gender: response.gender != .unknown ? Gender(response: response.gender) : nil,
                imageURL: response.imageURL,
                isVerified: response.isVerified,
                isOnline: response.isOnline,
                instagramURL: response.instagramURL,
                rate: response.rate,
                ratting: response.ratting,
                reviews: response.reviews,
                games: response.games)
        }
    }
}
