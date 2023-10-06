//
//  GalleryViewModel.swift
//  InfiniteScrollGallery
//
//  Created by Aulia Nastiti on 06/10/23.
//

import Combine
import Foundation

struct GalleryViewState {
  var isLoading: Bool = false
  var gallery: [Gallery] = []
  var currentPage: Int = 0
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
    loadData(1)
  }
  
  func checkIfLoadNext(_ id: Int) {
    if viewState.isLoading {
      return
    }
    
    if id == viewState.gallery.last?.id {
      loadData(viewState.currentPage + 1)
    }
  }
  
  private func loadData(_ page: Int) {
    viewState.isLoading = true
    fetchGallery
      .execute(page)
      .receive(on: RunLoop.main)
      .sink(
        receiveCompletion: { [unowned self] completion in
          switch completion {
          case .finished:
            self.viewState.isLoading = false
          case .failure(let error):
            print(error)
            self.viewState.isLoading = false
          }
        },
        receiveValue: { [unowned self] result in
          self.viewState.currentPage = result.pagination.currentPage
          self.viewState.gallery.append(contentsOf: result.data)
        }
      )
      .store(in: &cancellables)
  }
}
