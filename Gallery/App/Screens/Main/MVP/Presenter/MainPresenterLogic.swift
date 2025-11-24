protocol MainPresenterLogic {
    func fillTableView() async
    func updateLike(id: Int)
    func pagination()
    func refresh() async
    func saveDataInStorage()
}
