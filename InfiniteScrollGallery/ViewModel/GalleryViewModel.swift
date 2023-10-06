//
//  GalleryViewModel.swift
//  InfiniteScrollGallery
//
//  Created by Aulia Nastiti on 06/10/23.
//

import Combine
import Foundation

struct GalleryViewState {
  let response: GalleryResponse? = nil
}

class GalleryViewModel: ObservableObject {
  private let fetchGallery: FetchGallery

  private var cancellables: Set<AnyCancellable> = []

  @Published var viewState: GalleryViewState = GalleryViewState()

  init(
    _ fetchGallery: FetchGallery
  ) {
    self.fetchGallery = fetchGallery
  }

  func initialLoad() {
    fetchGallery
      .execute(1)
      .receive(on: RunLoop.main)
      .sink(
        receiveCompletion: { completion in
          switch completion {
          case .finished:
           print("FINISHED")
          case .failure(let error):
            print("ERROR \(error)")
          }
        },
        receiveValue: { result in
          print("RESULT: \(result)")
        }
      )
      .store(in: &cancellables)
  }
}
