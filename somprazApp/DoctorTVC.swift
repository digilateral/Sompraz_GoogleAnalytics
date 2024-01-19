//
//  DoctorTVC.swift
//  somprazApp
//
//  Created by digiLATERAL on 18/10/23.
//

import UIKit

class DoctorTVC: UITableViewCell {
    
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblID: UILabel!
    @IBOutlet weak var scoreLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // Set a clear background color
        self.backgroundColor = .clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
