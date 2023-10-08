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
  func searchGallery(_ query: String, _ page: Int) -> AnyPublisher<GalleryResponse, Error>
}

class APIServiceImpl: APIService {
  private let baseApi = "https://api.artic.edu/api/v1/artworks"
  private let apiFields = "fields=id,image_id"
  private let apiLimit = "limit=\(ApiConstant.ApiLimit)"
  private let urlSession: URLSession

  init(_ urlSession: URLSession) {
    self.urlSession = urlSession
  }

  func fetchGalleryItems(_ page: Int) -> AnyPublisher<GalleryResponse, Error> {
    guard let url = URL(string: "\(baseApi)?\(apiLimit)&\(apiFields)&page=\(page)") else {
      return Fail(error: ApiError.wrongPath).eraseToAnyPublisher()
    }
    
    return createPublisher(url)
  }
  
  func searchGallery(_ query: String, _ page: Int) -> AnyPublisher<GalleryResponse, Error> {
    guard let url = URL(string: "\(baseApi)?q=\(query)&\(apiFields)&\(apiLimit)&page=\(page)") else {
      return Fail(error: ApiError.wrongPath).eraseToAnyPublisher()
    }
    
    return createPublisher(url)
  }
  
  private func createPublisher(_ url: URL) -> AnyPublisher<GalleryResponse, Error> {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
        
    return urlSession.dataTaskPublisher(for: url)
      .map(\.data)
      .decode(type: GalleryResponse.self, decoder: decoder)
      .mapError { error in
        return ApiError.failToDecode
      }
      .eraseToAnyPublisher()
  }
}
