//
//  NetworkInterface.swift
//  ebuddy-technical-test
//
//  Created by danny santoso on 12/20/24.
//

import Foundation

extension NSString {
    public enum BaseURL {
        case development
        case staging
    }
    
    public static var environment: BaseURL = {
    #if DEBUG
        return .development
    #else
        return .staging
    #endif
    }()
    
    public static func imageUploaderURL() -> String {
        let url: String
        switch environment {
        case .development:
            url = "https://upload.imagekit.io/api/v1/files/upload"
        case .staging:
            url = "https://upload.imagekit.io/api/v1/files/upload"
        }
        return url
    }
}
