import UIKit
import Kingfisher

final class FavoriteFilmCell: UITableViewCell {

    static let identifier = "FavoriteFilmCell"

    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var gradientImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "rectangle")
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .accent
        contentView.addSubview(posterImageView)
        contentView.addSubview(gradientImageView)
        gradientImageView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            gradientImageView.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor),
            gradientImageView.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor),
            gradientImageView.bottomAnchor.constraint(equalTo: posterImageView.bottomAnchor),
            gradientImageView.heightAnchor.constraint(equalToConstant: 40),

            titleLabel.leadingAnchor.constraint(equalTo: gradientImageView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: gradientImageView.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: gradientImageView.bottomAnchor, constant: -8)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with film: Film) {
        if let url = URL(string: film.posterUrl) {
            posterImageView.kf.setImage(with: url)
        }
        titleLabel.text = film.nameRu ?? film.nameOriginal
    }
}
