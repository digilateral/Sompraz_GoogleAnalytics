import UIKit

class CustomTimeoutAlertViewController: UIViewController {
    

    @IBOutlet weak var timeOutIV: UIImageView!
    @IBOutlet weak var drNameScorelbl: UILabel!
    
    var score: Int = 0 // Define the score property with an initial value
        var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        drNameScorelbl.text = name + "your score is \(score) points"
        drNameScorelbl.text = "\(name), your score is \(score) points"
    }

    
}
