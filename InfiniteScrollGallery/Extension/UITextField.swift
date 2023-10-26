//
//  UITextField.swift
//  InfiniteScrollGallery
//
//  Created by Aulia Nastiti on 25/10/23.
//

import Combine
import UIKit

public extension UITextField {
    /// A publisher emitting any text changes to a this text field.
  var textPublisher: AnyPublisher<String, Never> {
    controlPublisher(for: .editingChanged)
      .map { $0 as! UITextField }
      .map { $0.text! }
      .eraseToAnyPublisher()
  }
}
