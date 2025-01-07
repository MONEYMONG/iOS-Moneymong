import UIKit

import BaseFeatureInterface

protocol ImagePickerPresentable {
  func imagePicker(
    target: UIViewController,
    animated: Bool,
    delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate
  )
}

extension ImagePickerPresentable {
  func imagePicker(
    target: UIViewController,
    animated: Bool,
    delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate
  ) {
    let picker: UIImagePickerController = {
      let v = UIImagePickerController()
      v.sourceType = .photoLibrary
      return v
    }()
    picker.delegate = delegate
    picker.modalPresentationStyle = .fullScreen
    target.present(picker, animated: animated)
  }
}
