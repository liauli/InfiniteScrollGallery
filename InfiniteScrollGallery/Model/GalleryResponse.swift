struct GalleryResponse: Codable, Equatable {
  let pagination: Pagination
  let data: [Gallery]
  let config: Config
}
