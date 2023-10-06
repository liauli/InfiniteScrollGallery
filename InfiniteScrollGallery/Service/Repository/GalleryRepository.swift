import Combine
import Foundation

protocol GalleryRepository {
  func fetchGalleryItems(_ page: Int) -> AnyPublisher<GalleryResponse, Error>
}

class GalleryRepositoryImpl: GalleryRepository {
  private let apiService: APIService
  
  init(
    _ apiService: APIService
  ) {
    self.apiService = apiService
  }

  func fetchGalleryItems(_ page: Int) -> AnyPublisher<GalleryResponse, Error> {
    return apiService.fetchGalleryItems(page).eraseToAnyPublisher()
  }
}
