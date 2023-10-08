//
//  GalleryViewModel.swift
//  InfiniteScrollGallery
//
//  Created by Aulia Nastiti on 06/10/23.
//

import Combine
import Foundation

struct GalleryViewState: Equatable, Hashable {
  var isLoading: Bool = false
  var gallery: [Gallery] = []
  var currentPage: Int = 0
  var imageUrl: String = ""
  var isSearchMode: Bool = false
  var query: String = ""
}

class GalleryViewModel: ObservableObject {
  private let fetchGallery: FetchGallery
  private let searchGallery: SearchGallery

  private var cancellables: Set<AnyCancellable> = []

  @Published private(set) var viewState: GalleryViewState = GalleryViewState()
  
  @Published var queryText: String = ""
  @Published var debouncedText: String = ""

  init(
    _ fetchGallery: FetchGallery,
    _ searchGallery: SearchGallery
  ) {
    self.fetchGallery = fetchGallery
    self.searchGallery = searchGallery
    setDebouncedText()
  }
  
  private func setDebouncedText() {
    $queryText
      .removeDuplicates()
      .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
      .sink(receiveValue: { [weak self] value in
          self?.debouncedText = value
      })
      .store(in: &cancellables)
  }

  func initialLoad() {
    loadData(1)
  }
  
  func checkIfLoadNext(_ id: Int) {
    if viewState.isLoading {
      return
    }
    
    if id == viewState.gallery.last?.id {
      if viewState.isSearchMode {
        search(viewState.query, viewState.currentPage + 1)
      } else {
        loadData(viewState.currentPage + 1)
      }
    }
  }
  
  private func loadData(_ page: Int) {
    if viewState.isSearchMode {
      viewState.currentPage = 0
      viewState.isSearchMode = false
      viewState.gallery.removeAll()
    }
    
    viewState.isLoading = true
    fetchGallery
      .execute(page)
      .receive(on: RunLoop.main)
      .sink(
        receiveCompletion: { [weak self] completion in
          switch completion {
          case .finished:
            self?.viewState.isLoading = false
          case .failure(let error):
            print(error)
            //TODO: ADD ERROR HANDLING
            self?.viewState.isLoading = false
          }
        },
        receiveValue: { [weak self] result in
          let uniqueElements = result.data.filter { self?.viewState.gallery.contains($0) == false }
          self?.viewState.gallery.append(contentsOf: uniqueElements)
          self?.viewState.currentPage = result.pagination.currentPage
          self?.viewState.gallery = self?.viewState.gallery.removeDuplicates() ?? []
          self?.viewState.imageUrl = result.config.iiifUrl
        }
      )
      .store(in: &cancellables)
  }
  
  func search(_ query: String, _ page: Int = 1) {
    if query.isEmpty { return }
    
    viewState.isLoading = true
    
    if !viewState.isSearchMode || viewState.query != query {
      viewState.gallery.removeAll()
      viewState.isSearchMode = true
      viewState.currentPage = 0
    }
    
    searchGallery
      .execute(query, page)
      .receive(on: RunLoop.main)
      .removeDuplicates()
      .sink(
        receiveCompletion: { [weak self] completion in
          switch completion {
          case .finished:
            self?.viewState.isLoading = false
          case .failure(let error):
            print(error)
            //TODO: ADD ERROR HANDLING
            self?.viewState.isLoading = false
          }
        },
        receiveValue: { [weak self] result in
          let uniqueElements = result.data.filter { self?.viewState.gallery.contains($0) == false }
          self?.viewState.gallery.append(contentsOf: uniqueElements)
          self?.viewState.query = query
          self?.viewState.currentPage = result.pagination.currentPage
          self?.viewState.imageUrl = result.config.iiifUrl
        }
      )
      .store(in: &cancellables)
  }
}
