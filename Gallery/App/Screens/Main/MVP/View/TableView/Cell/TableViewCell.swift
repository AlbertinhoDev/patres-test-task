import UIKit

final class TableViewCell: UITableViewCell {
    private var currentPost: TableCellModel?
    var onLikeButtonTapped: ((TableCellModel) -> Void)?
    var onDoubleTap: ((Int) -> Void)?
 
    private lazy var commonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var leftStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var rightStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var postImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 2
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var doubleTapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        gesture.numberOfTapsRequired = 2
        gesture.numberOfTouchesRequired = 1
        return gesture
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupDoubleTap()
    }
    
    @objc private func didTapLikeButton() {
        guard let like = currentPost else { return }
        onLikeButtonTapped?(like)
    }
    
    func configureCell(model: TableCellModel) {
        postImage.image = model.image
        titleLabel.text = model.title
        bodyLabel.text = model.body
        
        if model.like {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            likeButton.tintColor = .red
        } else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likeButton.tintColor = UIColor.black
        }
        
        currentPost = model
    }
    
    private func setupDoubleTap() {
        contentView.addGestureRecognizer(doubleTapGesture)
        doubleTapGesture.delaysTouchesBegan = false
    }
    
    @objc private func handleDoubleTap() {
        guard let postId = currentPost?.id else { return }
        onDoubleTap?(postId)
    }

    private func setupCell() {
        backgroundColor = .clear
        contentView.addSubview(commonStackView)
        
        commonStackView.addArrangedSubview(leftStackView)
        commonStackView.addArrangedSubview(rightStackView)
        
        leftStackView.addArrangedSubview(titleLabel)
        leftStackView.addArrangedSubview(bodyLabel)
        
        rightStackView.addArrangedSubview(postImage)
        rightStackView.addArrangedSubview(likeButton)
        
        NSLayoutConstraint.activate([
            commonStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            commonStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            commonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            commonStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            postImage.widthAnchor.constraint(equalToConstant: 150),
            postImage.heightAnchor.constraint(equalToConstant: 200),
            
            likeButton.widthAnchor.constraint(equalToConstant: 30),
            likeButton.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
