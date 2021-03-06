//
//  UITableView+Register.swift
//  GitFind
//
//  Created by Danmark Arqueza on 10/11/21.
//

import UIKit

public protocol ReusableProtocol {
  static var identifier: String { get }
}

public extension ReusableProtocol where Self: UIView {
  static var identifier: String {
    return String(describing: self)
  }
}

extension UITableViewCell: ReusableProtocol {}

extension UITableView {
  func register<T: UITableViewCell>(cell: T.Type) {
    register(T.self, forCellReuseIdentifier: T.identifier)
  }
}
