struct GalleryResponse: Codable {
    let pagination: Pagination
    let data: [Gallery]
}
