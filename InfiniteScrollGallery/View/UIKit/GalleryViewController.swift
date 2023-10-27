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
    
    galleryView.textField.delegate = self
    
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
    handleError(state.error)
    self.galleryView.gridView.reloadData()
  }
  
  private func handleError(_ error: GalleryErrorState?) {
    let lastCell = getLastCell()
    if error == .errorEmptyData {
      self.galleryView.showError("Failed to load data") {
        if self.galleryView.textField.text?.isEmpty == false {
          self.viewModel.search(self.galleryView.textField.text ?? "")
        } else {
          self.viewModel.initialLoad()
        }
      }
    } else if error == .errorOnScroll {
      lastCell?.loadingView.stopAnimating()
      let itemId = gallery.last?.id ?? 0
      lastCell?.showError {
        lastCell?.hideError()
        self.viewModel.checkIfLoadNext(itemId)
      }
    } else if error == nil {
      lastCell?.loadingView.startAnimating()
      lastCell?.hideError()
      self.galleryView.hideError()
    }
  }
  
  private func getLastCell() -> LoadingViewCell? {
    let lastSection = galleryView.gridView.numberOfSections - 1
    let lastItem = galleryView.gridView.numberOfItems(inSection: lastSection) - 1
    guard lastSection >= 0 && lastItem >= 0 else { return nil }
    
    let indexPath = IndexPath(item: lastItem, section: lastSection)
    let lastCell = galleryView.gridView.cellForItem(at: indexPath) as? LoadingViewCell
      
    guard let lastCell = lastCell else { return nil }
  
    return lastCell
  }
}

extension GalleryViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return gallery.count + 1
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if indexPath.row != gallery.count {
      guard let cell = galleryView.gridView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? GalleryCell else {
        return UICollectionViewCell()
      }
      guard let imageId = gallery[indexPath.row].imageId else {
        return cell
      }
    
      let url = "\(viewModel.viewState.imageUrl)/\(imageId)\(ApiConstant.imageUrlPath)"
      cell.configure(url)
      
      return cell
    } else {
      guard let cell = galleryView.gridView.dequeueReusableCell(withReuseIdentifier: "loadingCell", for: indexPath) as? LoadingViewCell else {
        return UICollectionViewCell()
      }
      
      cell.loadingView.startAnimating()
      cell.isUserInteractionEnabled = true
      
      return cell
    }
    
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    let shouldLoadNext = galleryView.textField.text == viewModel.viewState.query
    let errorNotVisible = viewModel.viewState.error == nil
    if indexPath.row == gallery.count - 1 && shouldLoadNext && errorNotVisible {
      let itemId = gallery[indexPath.row].id
      viewModel.checkIfLoadNext(itemId)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let spacing = (galleryView.gridView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 0
    let areaWidth = UIScreen.main.bounds.width  - spacing * 2
    let defaultGridItemSize = areaWidth / 3
    let widthPerItem = indexPath.row != gallery.count ? defaultGridItemSize : areaWidth
    let size = CGSize(width: widthPerItem, height: defaultGridItemSize)
    
    return size
  }
}

extension GalleryViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
