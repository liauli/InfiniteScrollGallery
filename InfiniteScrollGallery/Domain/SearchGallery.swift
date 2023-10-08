import Combine
import Foundation

protocol SearchGallery {
  func execute(_ query: String, _ page: Int) -> AnyPublisher<GalleryResponse, Error>
}

class SearchGalleryImpl: SearchGallery {
  private let galleryRepository: GalleryRepository

  init(_ galleryRepository: GalleryRepository) {
    self.galleryRepository = galleryRepository
  }

  func execute(_ query: String, _ page: Int) -> AnyPublisher<GalleryResponse, Error> {
    return galleryRepository.searchGallery(query, page)
  }
}
