import Foundation

protocol MainDisplayLogic: AnyObject {
    func showActivityIndicator(show: Bool)
    func showAlert(title: String, message: String)
    func updateTableView(sections: [Section], posts: [TableCellModel])
}
