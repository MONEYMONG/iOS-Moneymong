import UIKit

import DesignSystem

final class ColorVC: UITableViewController {
  
  private var items = [
    ["White": [Colors.White._1]],
    ["Black": [Colors.Black._1]],
    ["Gray": [Colors.Gray._1, Colors.Gray._2, Colors.Gray._3, Colors.Gray._4, Colors.Gray._5, Colors.Gray._6, Colors.Gray._7, Colors.Gray._8, Colors.Gray._9, Colors.Gray._10]],
    ["Blue": [Colors.Blue._1, Colors.Blue._2, Colors.Blue._3, Colors.Blue._4]],
    ["SkyBlue": [Colors.SkyBlue._1]],
    ["Mint": [Colors.Mint._1, Colors.Mint._2, Colors.Mint._3]],
    ["Yellow": [Colors.Yellow._1]],
    ["Red": [Colors.Red._1, Colors.Red._2, Colors.Red._3]],
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
  }
  
  private func setupView() {
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
    title = "Colors"
  }
}

extension ColorVC {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items[section].values.first!.count
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return items.count
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return items[section].keys.first
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
    
    let colorName = items[indexPath.section].keys.first!
    let color = items[indexPath.section].values.first![indexPath.row]
    
    cell.textLabel?.text = "     \(colorName)_\(indexPath.row + 1)"
    cell.textLabel?.font = .systemFont(ofSize: 20)
    
    let image = UIGraphicsImageRenderer(size: .init(width: 40, height: 40)).image { rendererContext in
      color.setFill()
      rendererContext.fill(CGRect(origin: .zero, size: .init(width: 40, height: 40)))
    }
    
    cell.imageView?.image = image
    cell.imageView?.layer.cornerRadius = 20
    cell.imageView?.layer.borderColor = UIColor.black.cgColor
    cell.imageView?.layer.borderWidth = 1
    cell.imageView?.clipsToBounds = true
    return cell
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
  
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
  }
}
