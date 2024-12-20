//
//  ImageUploaderMapper.swift
//  ebuddy-technical-test
//
//  Created by danny santoso on 12/20/24.
//

final class ImageUploaderMapper {
    static func mapImageUploaderResponseToDomains(input imageUploaderResponse: ImageUploaderResponse) -> ImageUploader {
        return ImageUploader(
            id: imageUploaderResponse.fileId,
            name: imageUploaderResponse.name,
            url: imageUploaderResponse.url)
    }
}
