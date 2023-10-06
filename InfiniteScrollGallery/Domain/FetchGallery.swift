import Combine
import Foundation

protocol FetchGallery {
  func execute(_ page: Int) -> AnyPublisher<GalleryResponse, Error>
}

class FetchGalleryImpl: FetchGallery {
  private let galleryRepository: GalleryRepository

  init(_ galleryRepository: GalleryRepository) {
    self.galleryRepository = galleryRepository
  }

  func execute(_ page: Int) -> AnyPublisher<GalleryResponse, Error> {
    return galleryRepository.fetchGalleryItems(page)
  }
}
