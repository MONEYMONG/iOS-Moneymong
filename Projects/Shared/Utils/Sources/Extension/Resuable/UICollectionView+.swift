import UIKit

public extension UICollectionView {
  func register<T: UICollectionViewCell>(_ : T.Type) where T: ResuableView {
    self.register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
  }
  
  func registerHeader<T: UICollectionReusableView>(_ : T.Type) where T: ResuableView {
    self.register(T.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.reuseIdentifier)
  }
  
  func registerFooter<T: UICollectionReusableView>(_ : T.Type) where T: ResuableView {
    self.register(T.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: T.reuseIdentifier)
  }
  
  func dequeueCell<T: UICollectionViewCell>(_ : T.Type, for indexPath: IndexPath) -> T where T: ResuableView {
    return self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
  }
  
  func dequeueHeader<T: UICollectionReusableView>(_ : T.Type, for indexPath: IndexPath) -> T where T: ResuableView {
    self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
  }
  
  func dequeueFooter<T: UICollectionReusableView>(_ : T.Type, for indexPath: IndexPath) -> T where T: ResuableView {
    self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
  }
}
