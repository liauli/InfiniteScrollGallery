//
//  GalleryCell.swift
//  InfiniteScrollGallery
//
//  Created by Aulia Nastiti on 25/10/23.
//

import Kingfisher
import UIKit

class GalleryCell: UICollectionViewCell {

  private let imageView: UIImageView = {
      let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
      imageView.clipsToBounds = true
      return imageView
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(imageView)

    imageView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
      imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }

  func configure(_ url: String) {
    let url = URL(string: url)
    let image = UIImage(named: "brokenImage")
    imageView.kf.setImage(with: url, placeholder: image)
  }
}
