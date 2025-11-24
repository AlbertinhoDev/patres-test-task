import UIKit

final class MainViewController: UIViewController {
    var presenter: MainPresenterLogic?
    private let refreshControl = UIRefreshControl()
    private lazy var tableView = UITableView()
    private var sections: [Section] = []
    private var posts: [TableCellModel] = []
    private var isScrollToTopButtonVisible = false
    
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = .lightGray
        return indicator
    }()
    
    private lazy var scrollToTopButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "chevron.up.circle.fill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 12
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.layer.shadowColor = UIColor.black.cgColor
        button.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(scrollToTop), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        Task {
            await presenter?.fillTableView()
        }
        
        setupViewController()
        setupRefreshControl()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(saveDataOnBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(saveDataOnBackground),
            name: UIApplication.willTerminateNotification,
            object: nil
        )
    }
    
    @objc private func saveDataOnBackground() {
        presenter?.saveDataInStorage()
    }
    
    private func setupViewController() {
        view.addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        view.addSubview(scrollToTopButton)
        
        NSLayoutConstraint.activate([
            scrollToTopButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollToTopButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            scrollToTopButton.widthAnchor.constraint(equalToConstant: 56),
            scrollToTopButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshControl.tintColor = .lightGray
        tableView.refreshControl = refreshControl
    }
    
    @objc private func refreshData() {
        Task {
            await presenter?.refresh()
            
            await MainActor.run {
                refreshControl.endRefreshing()
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension MainViewController: MainDisplayLogic {
    func updateTableView(sections: [Section], posts: [TableCellModel]) {
        refreshControl.endRefreshing()
        self.sections = sections
        self.posts = posts
        tableView.reloadData()
    }
    
    func showActivityIndicator(show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Повторить", style: .default) { _ in
            Task { await self.presenter?.fillTableView() }
        })
        
        present(alert, animated: true)
    }
}

extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        let rowType = sections[section].rows[row]
        
        switch rowType {
        case .post:
            let cell = tableView.dequeueReusableCell(TableViewCell.self, indexPath: indexPath)
            cell.selectionStyle = .none
            let post = posts[indexPath.row]
            cell.configureCell(model: post)
            
            cell.onLikeButtonTapped = { [weak self] post in
                let id = post.id
                self?.presenter?.updateLike(id: id)
                self?.tableView.reloadData()
            }
            
            cell.onDoubleTap = { [weak self] postId in
                self?.presenter?.updateLike(id: postId)
            }
            
            return cell
        }
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSection = tableView.numberOfSections - 1
        let lastRow = tableView.numberOfRows(inSection: lastSection) - 1
        if indexPath.section == lastSection && indexPath.row == lastRow {
            presenter?.pagination()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let threshold: CGFloat = 800
        let shouldShow = offsetY > threshold
        guard shouldShow != isScrollToTopButtonVisible else { return }
        isScrollToTopButtonVisible = shouldShow
        
        UIView.animate(
            withDuration: 0.35,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.6,
            options: [.allowUserInteraction, .beginFromCurrentState],
                animations: {
                    self.scrollToTopButton.alpha = shouldShow ? 1.0 : 0.0
                    self.scrollToTopButton.transform = shouldShow ? .identity: CGAffineTransform(scaleX: 0.6, y: 0.6)
                }
        )
    }
        
    @objc private func scrollToTop() {
        guard !posts.isEmpty else { return }
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        
        guard isScrollToTopButtonVisible else { return }
        isScrollToTopButtonVisible = false
                
        UIView.animate(withDuration: 0.3) {
            self.scrollToTopButton.alpha = 0
            self.scrollToTopButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        }
    }
}
