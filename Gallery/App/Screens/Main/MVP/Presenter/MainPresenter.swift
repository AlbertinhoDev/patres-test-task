import UIKit

final class MainPresenter {
    weak var viewController: MainDisplayLogic?
    private let apiService: ApiServiceLogic
    private let monitorService: NetworkMonitorLogic
    private let storageService: StorageServiceLogic
    private var currentPage: Int = 1
    private var posts: [TableCellModel] = []
    private var isOnline = false
    
    init(
        apiService: ApiServiceLogic,
        monitorService: NetworkMonitorLogic,
        storageService: StorageServiceLogic
    ) {
        self.apiService = apiService
        self.monitorService = monitorService
        self.storageService = storageService
    }
    
    private func buildingTableView(posts: [TableCellModel]) {
        let sections: [Section] = [
            .init(type: .posts, rows: Array(repeating: .post, count: posts.count))
        ]
        
        viewController?.updateTableView(sections: sections, posts: posts)
    }
}

extension MainPresenter: MainPresenterLogic {
    func pagination() {
        currentPage += 1
        
        guard isOnline else { return }
        
        Task {
            await fillTableView()
        }
    }
    
    func fillTableView() async {
        viewController?.showActivityIndicator(show: true)
        let isConnected = await monitorService.checkConnectToNetwork()
        
        if isConnected {
            isOnline = isConnected
            
            do {
                try await loadFromNet()
            } catch {
                viewController?.showAlert (
                    title: "Сервер недоступен",
                    message: "Попробуйте снова"
                )
            }
        } else {
            guard !storageService.fetchAllPosts().isEmpty else {
                viewController?.showAlert (
                    title: "Нет подключения",
                    message: "Проверьте интернет и попробуйте снова"
                )
                
                return
            }
        
            try? await loadFromCash()
        }
    }
    
    func updateLike(id: Int) {
        let newLikeStatus = self.posts.map {
            if $0.id == id {
                var updateLike = $0
                updateLike.like.toggle()
                
                if (storageService.fetchPost(postId: $0.id)) != nil {
                    storageService.updatePost(postId: $0.id, onLike: updateLike.like)
                } else {
                    storageService.createPost(
                        post: Post(
                            id: $0.id,
                            title: $0.title,
                            body: $0.body,
                            like: updateLike.like,
                            image: $0.image.pngData() ?? Data()
                        )
                    )
                }
    
                return updateLike
            }
            return $0
        }
        
        posts = newLikeStatus
        buildingTableView(posts: posts)
    }
    
    func refresh() async {
        currentPage = 1
        posts.removeAll()
        await fillTableView()
    }
    
    func saveDataInStorage() {
        storageService.deleteAllPostsFromStorage()
        
        for postModel in posts {
            let imageData = postModel.image.pngData() ?? Data()
                
            storageService.createPost(
                post: Post(
                    id: postModel.id,
                    title: postModel.title,
                    body: postModel.body,
                    like: postModel.like,
                    image: imageData
                )
            )
        }
    }

    
    private func loadFromNet() async throws {
        let response = try await apiService.fetchData(endpoint: UserPostEndpoint(page: currentPage))
        let images = await loadImages(response: response)
        await collectData(response: response, images: images)
    }
    
    private func loadImages(response: [Response]) async -> [UIImage?] {
        await withTaskGroup(of: (Int, UIImage?).self) { group -> [UIImage?] in
            for (index, post) in response.enumerated() {
                group.addTask { [weak self] in
                    let image = try? await self?.apiService.fetchImage(endpoint: UserPhotoEndpoint(id: post.id))
                    return (index, image)
                }
            }
            
            var results = Array<UIImage?>(repeating: nil, count: response.count)
                for await (index, image) in group {
                    results[index] = image
                }
            
            return results
        }
    }
    
    private func collectData(response: [Response], images: [UIImage?]) async {
        let newPosts = zip(response, images).map { post, image in
            TableCellModel(
                image: image ?? UIImage(named: "NilImage") ?? UIImage(),
                title: post.title,
                body: post.body,
                like: loadLikeFromCache(postId: post.id),
                id: post.id
            )
        }
            
        await MainActor.run {
            if currentPage == 1 {
                self.posts = newPosts
            } else {
                self.posts.append(contentsOf: newPosts)
            }
            
            self.buildingTableView(posts: self.posts)
            self.viewController?.showActivityIndicator(show: false)
        }
    }
    
    private func loadLikeFromCache(postId: Int) -> Bool {
        guard let likeFromStorage = storageService.fetchPost(postId: postId) else { return false }
        return likeFromStorage.like
    }
    
    private func loadFromCash() async throws {
        let cachedEntities = storageService.fetchAllPosts()
        
        let cachedPosts = cachedEntities.compactMap { entity -> TableCellModel? in
            let id = entity.id
            let title = entity.title
            let body = entity.body
            let imageData = entity.image
            guard let image = UIImage(data: imageData) else {
                return nil
            }
            
            return TableCellModel(
                image: image,
                title: title,
                body: body,
                like: entity.like,
                id: id
            )
        }
        
        await MainActor.run {
            self.posts = cachedPosts
            self.currentPage = 1
            self.buildingTableView(posts: cachedPosts)
            self.viewController?.showActivityIndicator(show: false)
        }
    }
}
