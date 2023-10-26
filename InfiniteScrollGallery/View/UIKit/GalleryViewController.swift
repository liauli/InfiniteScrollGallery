//
//  GalleryViewController.swift
//  InfiniteScrollGallery
//
//  Created by Aulia Nastiti on 24/10/23.
//

import Combine
import UIKit

class GalleryViewController: UIViewController {
  private var galleryView: GalleryUIView = GalleryUIView()
  private var loadingView: LoadingView = LoadingView()
  
  private var viewModel = ViewModelProvider.instance.provideGalleryViewModel()
  private var cancellables: Set<AnyCancellable> = []
  
  private var gallery: [Gallery] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    view.addSubview(galleryView)
    
    setupViews()
    setupLayoutConstraint()
    
    bind()
    viewModel.initialLoad()
  }
  
  private func bind() {
    viewModel.$viewState.sink { [weak self] state in
      self?.render(state)
    }.store(in: &cancellables)
  }
  
  private func setupViews() {
    galleryView.translatesAutoresizingMaskIntoConstraints = false
    
    galleryView.gridView.dataSource = self
    galleryView.gridView.delegate = self
    
    galleryView.textField.textPublisher
      .removeDuplicates()
      .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
      .sink { [weak self] text in
        if text.isEmpty {
          self?.viewModel.initialLoad()
        } else if !text.isEmpty {
          self?.viewModel.search(text)
        }
      }
      .store(in: &cancellables)
  }
  
  private func setupLayoutConstraint() {
    NSLayoutConstraint.activate([
      galleryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      galleryView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      galleryView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      galleryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
  
  private func render(_ state: GalleryViewState) {
    self.gallery = state.gallery
    self.galleryView.gridView.reloadData()
    
    if state.error == .errorEmptyData {
      self.galleryView.showError("Failed to load data") {
        if self.galleryView.textField.text?.isEmpty == false {
          self.viewModel.search(self.galleryView.textField.text ?? "")
        } else {
          self.viewModel.initialLoad()
        }
      }
    } else if state.error == nil {
      self.galleryView.hideError()
    }
  }
}

extension GalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return gallery.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = galleryView.gridView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? GalleryCell else {
      return UICollectionViewCell()
    }
    guard let imageId = gallery[indexPath.row].imageId else {
      return cell
    }
  
    let url = "\(viewModel.viewState.imageUrl)/\(imageId)\(ApiConstant.imageUrlPath)"
    cell.configure(url)
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    let shouldLoadNext = galleryView.textField.text == viewModel.viewState.query
    if indexPath.row == gallery.count - 1 && shouldLoadNext {
      let itemId = gallery[indexPath.row].id
      viewModel.checkIfLoadNext(itemId)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    if kind == UICollectionView.elementKindSectionFooter {
      let cell = galleryView.gridView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "loading", for: indexPath)
      return cell
    }
    
    return UICollectionReusableView()
  }
}
