//
//  ImageViewModel.swift
//  AcharyaPrashantApp
//
//  Created by Sathiyaraj on 05/05/24.
//

import UIKit
import Combine

class ImagesViewModel {
    private var imageUrls: [ImagesModel] = []

    @Published private var imageData = [ImagesModel]()
    var imageDataPublisher: AnyPublisher<[ImagesModel], Never> {
        $imageData.eraseToAnyPublisher()
    }
        
      var imageDataFetched: (() -> Void)?
      var errorHandler: ((Error) -> Void)?
      
    private var cancellables = Set<AnyCancellable>()
    
    func fetchImages() {
       
        NetworkService.request(url: URLConstant.login.url!, method: .get, responseType: [ImagesModel].self) { [weak self] result in
                  switch result {
                  case .success(let images):
                      self?.imageData = images
                  case .failure(let error):
                      self?.errorHandler?(error)
                      print("Error fetching images: \(error)")
                  }
              }

      }
    
       
    func getImageUrl(for indexPath: IndexPath) -> String {
        guard indexPath.item < imageData.count else { return "" }
        let imageUrlString = "\(imageData[indexPath.item].thumbnail?.domain ?? "")/\(imageData[indexPath.item].thumbnail?.basePath ?? "")/0/\(imageData[indexPath.item].thumbnail?.key ?? "")"
        return imageUrlString
    }
    
    func numberOfImages() -> Int {
        return imageData.count
    }
}
