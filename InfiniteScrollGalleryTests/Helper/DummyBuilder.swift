//
//  DummyBuilder.swift
//  InfiniteScrollGalleryTests
//
//  Created by Aulia Nastiti on 06/10/23.
//

import Foundation

@testable import InfiniteScrollGallery

func createGalleryResponse(_ page: Int = 1) -> GalleryResponse {
  return GalleryResponse(
    pagination: createPagination(page),
    data: createGalleryItems(),
    config: createConfig()
  )
}

func createGalleryItems() -> [Gallery] {
  return [
    createGallery(),
    createGallery(),
    createGallery(imageId: nil)
  ]
}

func createPagination(_ page: Int) -> Pagination {
  return Pagination(
    total: 1,
    limit: 20,
    offset: 2,
    totalPages: 100,
    currentPage: page
  )
}

func createConfig() -> Config {
  return Config(iiifUrl: randomString(2))
}

func createGallery(imageId: String? = randomString(2)) -> Gallery {
  return Gallery(id: Int.random(in: 0..<100), imageId: imageId)
}
