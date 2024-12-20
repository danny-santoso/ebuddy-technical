//
//  ImageUploaderResponse.swift
//  ebuddy-technical-test
//
//  Created by danny santoso on 12/20/24.
//

import Foundation

struct ImageUploaderResponse: Decodable {
    let fileId: String
    let name: String
    let size: Int?
    let versionInfo: VersionInfo?
    let filePath: String?
    let url: String
    let fileType: String?
    let height: Int?
    let width: Int?
    let thumbnailUrl: String?
    let AITags: String?
    
    struct VersionInfo: Decodable {
        let id: String
        let name: String
        
        enum CodingKeys: String, CodingKey {
            case id, name
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case fileId = "fileId"
        case name = "name"
        case size = "size"
        case versionInfo = "versionInfo"
        case filePath = "filePath"
        case url = "url"
        case fileType = "fileType"
        case height = "height"
        case width = "width"
        case thumbnailUrl = "thumbnailUrl"
        case AITags = "AITags"
    }
}
