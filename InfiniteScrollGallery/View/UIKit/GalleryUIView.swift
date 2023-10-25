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
    
    return collectionView
  }()
  
  let loadingView: UIActivityIndicatorView = UIActivityIndicatorView()
  
  private var gallery: [Gallery] = []
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(textField)
    addSubview(gridView)
    addSubview(loadingView)
    
    textField.translatesAutoresizingMaskIntoConstraints = false
    gridView.translatesAutoresizingMaskIntoConstraints = false
    loadingView.translatesAutoresizingMaskIntoConstraints = false
    
    loadingView.startAnimating()

    NSLayoutConstraint.activate([
      textField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
      textField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
      textField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
      
      
      loadingView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 10),
      loadingView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
      
      gridView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 10),
      gridView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
      gridView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
      gridView.bottomAnchor.constraint(equalTo: loadingView.topAnchor, constant: -10)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
