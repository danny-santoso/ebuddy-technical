//
//  UserDetailViewModel.swift
//  ebuddy-technical-test
//
//  Created by danny santoso on 12/21/24.
//

import UIKit
import Foundation
import Combine

final class UserDetailViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let uploadImageUseCase: UploadImageUseCase
    
    private let updateImageProfileUseCase: UpdateImageProfileUseCase
    
    @Published var user: User
    
    @Published var isPickerPresented: Bool = false
    
    @Published var selectedImage: UIImage? = nil
    
    init(uploadImageUseCase: UploadImageUseCase, updateImageProfileUseCase: UpdateImageProfileUseCase, user: User) {
        self.uploadImageUseCase = uploadImageUseCase
        self.updateImageProfileUseCase = updateImageProfileUseCase
        self.user = user
        self.setupBindings()
    }
    
    private func setupBindings() {
        $selectedImage
            .compactMap { $0 }
            .sink { [weak self] image in
                self?.uploadImage(image: image)
            }
            .store(in: &cancellables)
    }
    
    func uploadImage(image: UIImage) {
        guard let data = image.pngData() else { return }
        uploadImageUseCase.execute(file: data, name: "selectedImage.png", type: "image/png")
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] result in
                self?.updateImage(imageUrl: result.url)
            })
            .store(in: &cancellables)
    }
    
    func updateImage(imageUrl: String) {
        updateImageProfileUseCase.execute(userId: user.id, imageURL: imageUrl)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self, case .finished = completion else { return }
                self.user.imageURL = imageUrl
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
    
}
