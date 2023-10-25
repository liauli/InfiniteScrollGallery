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
  
  private var viewModel = ViewModelProvider.instance.provideGalleryViewModel()
  private var cancellables: Set<AnyCancellable> = []
  
  private var gallery: [Gallery] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemBackground
    view.addSubview(galleryView)
    galleryView.translatesAutoresizingMaskIntoConstraints = false
    
    galleryView.gridView.dataSource = self
    galleryView.gridView.delegate = self
    
    NSLayoutConstraint.activate([
      galleryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      galleryView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      galleryView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      galleryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
    
    viewModel.$viewState.sink { [weak self] state in
      self?.render(state)
    }.store(in: &cancellables)
    
    viewModel.initialLoad()
  }
  
  private func render(_ state: GalleryViewState) {
    self.gallery = state.gallery
    self.galleryView.gridView.reloadData()
    self.galleryView.loadingView.isHidden = !state.isLoading
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
    if indexPath.row == gallery.count - 1 {
      let itemId = gallery[indexPath.row].id
      viewModel.checkIfLoadNext(itemId)
    }
  }
}
