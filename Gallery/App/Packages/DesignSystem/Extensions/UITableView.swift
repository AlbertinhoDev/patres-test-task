import UIKit

extension UITableView {
    func register<T: UITableViewCell>(_ type: T.Type) {
        register(type, forCellReuseIdentifier: type.reuseId)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(_ type: T.Type, indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: type.reuseId, for: indexPath) as? T else {
            fatalError("Не зарегистрирована ячейка: \(T.reuseId)")
        }
        return cell
    }
}
