import UIKit

class CustomTextField: UITextField {
    // Icon image view
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        return imageView
    }()

    // Padding for the icon
    private let iconPadding: CGFloat = 8.0 // Adjust as needed

    // Icon image for the text field
    var iconImage: UIImage? {
        didSet {
            iconImageView.image = iconImage
            setNeedsLayout()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // Update the frames for the icon and text field
        let iconSize = CGSize(width: 30, height: bounds.height)
        iconImageView.frame = CGRect(origin: .zero, size: iconSize)
        leftView = iconImageView
        leftViewMode = .always
        leftView?.frame.origin.x += iconPadding
    }
}
