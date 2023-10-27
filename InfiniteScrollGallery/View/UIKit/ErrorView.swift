//
//  ErrorView.swift
//  InfiniteScrollGallery
//
//  Created by Aulia Nastiti on 26/10/23.
//

import UIKit

class ErrorView: UIView {
  private let messageLabel: UILabel = UILabel()
  let refreshButton: UIButton = UIButton()

  var action: (() -> Void)?

  override init(frame: CGRect) {
    super.init(frame: frame)

    addSubview(messageLabel)
    addSubview(refreshButton)

    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    refreshButton.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      messageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),

      refreshButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      refreshButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 8),
    ])

    refreshButton.setTitle("Refresh", for: .normal)
    refreshButton.setTitleColor(.blue, for: .normal)
    refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func set(message: String) {
    messageLabel.text = message
  }

  @objc func refreshButtonTapped() {
    action?()
  }
}
