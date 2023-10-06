import Combine
import Foundation

enum ApiError: Error {
  case wrongPath
  case failToDecode
}

enum ApiConstant {
    static let ApiLimit = 15
}

protocol APIService {
  func fetchGalleryItems(_ page: Int) -> AnyPublisher<GalleryResponse, Error>
}

class APIServiceImpl: APIService {
  private let baseApi = "https://api.artic.edu/api/v1/artworks?limit=\(ApiConstant.ApiLimit)"
  private let urlSession: URLSession

  init(_ urlSession: URLSession) {
    self.urlSession = urlSession
  }

  func fetchGalleryItems(_ page: Int) -> AnyPublisher<GalleryResponse, Error> {
    guard let url = URL(string: "\(baseApi)&page=\(page)") else {
      return Fail(error: ApiError.wrongPath).eraseToAnyPublisher()
    }
    
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
        
    return urlSession.dataTaskPublisher(for: url)
      .map(\.data)
      .decode(type: GalleryResponse.self, decoder: decoder)
      .mapError { _ in ApiError.failToDecode }
      .eraseToAnyPublisher()
  }
}
