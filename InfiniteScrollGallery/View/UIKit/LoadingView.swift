//
//  LoadingReusableCell.swift
//  InfiniteScrollGallery
//
//  Created by Aulia Nastiti on 26/10/23.
//

import UIKit

class LoadingView: UICollectionReusableView {
  
  let loadingView: UIActivityIndicatorView = UIActivityIndicatorView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(loadingView)
    backgroundColor = .lightGray
    
    loadingView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      loadingView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      loadingView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 10),
      loadingView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
    ])
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
}
