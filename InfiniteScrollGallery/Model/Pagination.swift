struct Pagination: Codable, Equatable {
    let total: Int
    let limit: Int
    let offset: Int
    let totalPages: Int
    let currentPage: Int
}
