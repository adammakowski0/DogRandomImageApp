//
//  HomeViewModel.swift
//  DogImage
//
//  Created by Adam Makowski on 29/09/2024.
//

import SwiftUI
import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var dogDataURL: String = ""
    @Published var isLoading: Bool = false
    @Published var isFavorite: Bool = false

    var cancelables = Set<AnyCancellable>()
//    func downloadDogImage() async -> [DogDataModel]? {
//        guard let url = URL(string: "https://random.dog/woof.json") else {return nil}
//        do {
//            let (data, response) = try await URLSession.shared.data(from: url)
//            guard
//                let response = response as? HTTPURLResponse,
//                response.statusCode >= 200 && response.statusCode < 300 else {return nil}
//            return try JSONDecoder().decode([DogDataModel].self, from: data)
//        }
//        catch {
//            print(error.localizedDescription)
//            return nil
//        }
//    }
    func downloadDogImage() {
        self.isLoading = true
        guard let url = URL(string: "https://random.dog/woof.json") else { return }
        
        NetworkManager.download(url: url)
            .decode(type: DogImageModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] returnedImage in
                self?.dogDataURL = returnedImage.url
                self?.isLoading = false
            })
            .store(in: &cancelables)
    }
    
    func addToFavorites() {
        isFavorite.toggle()
    }
}

struct DogImageModel: Codable {
    let fileSizeBytes: Double
    let url: String
    var isFavorite: Bool?
}
