//
//  LoadingReusableCell.swift
//  InfiniteScrollGallery
//
//  Created by Aulia Nastiti on 26/10/23.
//

import UIKit

class LoadingViewCell: UICollectionViewCell {
  
  let loadingView: UIActivityIndicatorView = UIActivityIndicatorView()
  
  let errorView: ErrorView = ErrorView()
  var action: (() -> Void)?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.addSubview(errorView)
    contentView.addSubview(loadingView)
    contentView.isUserInteractionEnabled = true
    
    loadingView.translatesAutoresizingMaskIntoConstraints = false
    errorView.translatesAutoresizingMaskIntoConstraints = false
    
    errorView.isHidden = true
    
    NSLayoutConstraint.activate([
      errorView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      errorView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 10),
      errorView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
      
      loadingView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      loadingView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 10),
      loadingView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
    ])
    
    errorView.set(message: "Failed load next page")
    errorView.isUserInteractionEnabled = true
  }
  
  func showError(action: @escaping () -> Void) {
    loadingView.isHidden = true
    errorView.isHidden = false
    errorView.action = action
  }
  
  func hideError() {
    loadingView.isHidden = false
    errorView.isHidden = true
  }
  
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {

    guard isUserInteractionEnabled else { return nil }

    guard !isHidden else { return nil }
    
    guard alpha >= 0.01 else { return nil }

    guard self.point(inside: point, with: event) else { return nil }

    if self.errorView.refreshButton.point(inside: convert(point, to: errorView.refreshButton), with: event) {
      return self.errorView.refreshButton
    }

    return super.hitTest(point, with: event)
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
}
