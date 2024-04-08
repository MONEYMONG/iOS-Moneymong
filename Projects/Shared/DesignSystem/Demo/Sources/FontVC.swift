import UIKit
import DesignSystem

final class FontVC: UITableViewController {
  
  private let items: [UIFont] = [
    Fonts.heading._1,
    Fonts.heading._2,
    Fonts.heading._3,
    Fonts.heading._4,
    Fonts.heading._5,
    Fonts.body._1,
    Fonts.body._2,
    Fonts.body._3,
    Fonts.body._4,
    Fonts.body._5,
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
  }
  
  private func setupView() {
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))    
    title = "Fonts"
  }
}

extension FontVC {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count / 2
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return section == 0 ? "Heading" : "Body"
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
    
    let style = indexPath.section == 0 ? "heading" : "body"
    
    cell.textLabel?.text = "\(style)_\(indexPath.row+1)"
    cell.textLabel?.font = items[indexPath.section * 5 + indexPath.row]
    return cell
  }
  
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
  }
}
