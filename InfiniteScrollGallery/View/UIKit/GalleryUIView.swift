//
//  GalleryView.swift
//  InfiniteScrollGallery
//
//  Created by Aulia Nastiti on 25/10/23.
//

import UIKit

class GalleryUIView: UIView {
  let textField: UITextField = {
      let textField = UITextField()
      textField.placeholder = "Search"
      return textField
  }()

  let gridView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    
    let spacing : CGFloat = layout.minimumInteritemSpacing
    let widthPerItem = (UIScreen.main.bounds.width  - spacing * 2) / 3
    let size = CGSize(width: widthPerItem, height: widthPerItem)
    layout.itemSize = size
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(GalleryCell.self, forCellWithReuseIdentifier: "Cell")
    collectionView.register(LoadingViewCell.self, forCellWithReuseIdentifier: "loadingCell")
    
    return collectionView
  }()

  let errorView = ErrorView()
  
  private var gallery: [Gallery] = []
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(textField)
    addSubview(gridView)
    addSubview(errorView)
    
    errorView.isHidden = true
    
    textField.translatesAutoresizingMaskIntoConstraints = false
    gridView.translatesAutoresizingMaskIntoConstraints = false
    errorView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      textField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
      textField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
      textField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
      
      gridView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 10),
      gridView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
      gridView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
      gridView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 10),
      
      errorView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 10),
      errorView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
      errorView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
      errorView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 10),
    ])
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func showError(_ message: String, _ action: @escaping () -> Void) {
    gridView.isHidden = true
    errorView.isHidden = false
    errorView.set(message: message)
    errorView.action = action
  }
  
  func hideError() {
    gridView.isHidden = false
    errorView.isHidden = true
  }
  
}
