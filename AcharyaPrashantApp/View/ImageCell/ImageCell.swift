import UIKit

class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupShadow()
    }
    
    func configure(with image: UIImage?) {
        thumbImageView.image = image
    }
    private func setupShadow() {
        thumbImageView.layer.cornerRadius = 10
        thumbImageView.layer.masksToBounds = true
        thumbImageView.layer.shadowColor = UIColor.black.cgColor
        thumbImageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        thumbImageView.layer.shadowOpacity = 0.4
        thumbImageView.layer.shadowRadius = 3
        thumbImageView.layer.masksToBounds = false
        thumbImageView.layer.shadowPath = UIBezierPath(roundedRect: thumbImageView.bounds, cornerRadius: thumbImageView.layer.cornerRadius).cgPath
    }
}
