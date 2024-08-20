import UIKit
import Kingfisher

class PremiereTableViewCell: UITableViewCell {
    
    let containerView = UIView()
    let posterImageView = UIImageView()
    let titleLabel = UILabel()
    let detailsLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(posterImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(detailsLabel)
        
        containerView.backgroundColor = .accentLight
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true
        
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.numberOfLines = 0
        
        detailsLabel.font = UIFont.systemFont(ofSize: 16)
        detailsLabel.textColor = .gray
        detailsLabel.numberOfLines = 0
    }
    
    private func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerView.heightAnchor.constraint(equalToConstant: 120),
            
            posterImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 120),
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 4/3),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            
            detailsLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            detailsLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            detailsLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with premiere: Premiere) {
        titleLabel.text = premiere.nameRu
        detailsLabel.text = "\(premiere.genres.first?.genre ?? "") | \(premiere.countries.first?.country ?? "") \(premiere.duration ?? 0) мин"
        
        if let url = URL(string: premiere.posterUrl.absoluteString) {
            posterImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "photo"), options: [
                .transition(.fade(0.2)),
                .cacheOriginalImage
            ])
        } else {
            posterImageView.image = UIImage(systemName: "photo")
        }
    }
}
