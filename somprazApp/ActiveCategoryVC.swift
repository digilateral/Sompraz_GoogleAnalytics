//
//  ActiveCategoryVC.swift
//  somprazApp
//
//  Created by digiLATERAL on 08/12/23.
//

import UIKit

class ActiveCategoryVC: UIViewController {
    
    
    @IBOutlet weak var category1Btn: UIButton!
    @IBOutlet weak var category2Btn: UIButton!
    @IBOutlet weak var category3Btn: UIButton!
    @IBOutlet weak var category4Btn: UIButton!
    
    var selectedDoctorID = ""
    var selectedDoctorName = ""
    var doctorName: String = "" // Property to hold the doctorName
    var selectedMRID = ""
    var selectedQuestionType = ""
    
    var arrCategories = [OnlyActiveCategory]()
    var arrFormattedCategories = [FormattedCategory]()
    
    var arrSyncCategories = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MRID :", selectedMRID)
       
        
        category2Btn.isUserInteractionEnabled = true
        category2Btn.isUserInteractionEnabled = true
        category2Btn.isUserInteractionEnabled = true
        category2Btn.isUserInteractionEnabled = true
        
        
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "backImage1"), for: .normal) // Set your custom back button image
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        // Add the custom back button to the view
        view.addSubview(backButton)
        // Position the custom back button as needed
        backButton.frame = CGRect(x: 16, y: 40, width: 30, height: 30) // Adjust the frame as needed
        
        view.bringSubviewToFront(backButton)
        
        do {
            // Assuming you have some data in UserDefaults named 'savedUserData'
            
            if let savedUserData = UserDefaults.standard.value(forKey: UserDefaultsKeys.syncData.rawValue) {
                
                let arrSync = try JSONDecoder().decode(syncModel.self, from: savedUserData as! Data)
                print("Local data")
                print(arrSync)
                arrSyncCategories = [String]()
                for i in 0..<arrSync.count {
                    let dic = arrSync[i]
                    if dic.userId == selectedDoctorID {
                        let category = dic.categoryName
                        arrSyncCategories.append(category)
                    }
                }
                
                
            } else {
                print("Error: No data found in UserDefaults.")
            }
        } catch let decodingError {
            print("Error decoding JSON data for User Categories: \(decodingError)")
        }
        
//        do {
//            // Assuming you have some data in UserDefaults named 'savedUserData'
//            let key = "BlurCategories" + selectedDoctorID
//            if let savedUserData = UserDefaults.standard.value(forKey: key) {
//                arrFormattedCategories = [FormattedCategory]()
//                arrFormattedCategories = try JSONDecoder().decode([FormattedCategory].self, from: savedUserData as! Data)
//                
//            } else {
//                print("Error: No data found in UserDefaults.")
//            }
//        } catch let decodingError {
//            print("Error decoding JSON data for User Categories: \(decodingError)")
//        }
        
        
        
        
        do {
            // Assuming you have some data in UserDefaults named 'savedUserData'
            
            if let savedUserData = UserDefaults.standard.value(forKey: UserDefaultsKeys.ActiveCategoriesArray.rawValue) {
                arrCategories = [OnlyActiveCategory]()
              
                arrCategories = try JSONDecoder().decode([OnlyActiveCategory].self, from: savedUserData as! Data)
                print(arrCategories)
                loadbuttonUI()
            } else {
                print("Error: No data found in UserDefaults.")
            }
        } catch let decodingError {
            print("Error decoding JSON data for User Categories: \(decodingError)")
        }
    }
//    
//    func updateBlurButtons() {
//        for i in 0..<arrSyncCategories.count {
//            let name = arrSyncCategories[i]
//            if name.lowercased() == "politics" {
//                category1Btn.addBlurEffect(style: .dark,cornerRadius: 20)
//                category1Btn.isUserInteractionEnabled = false
//            } else if name.lowercased() == "history" {
//                category2Btn.addBlurEffect(style: .dark,cornerRadius: 20)
//                category2Btn.isUserInteractionEnabled = false
//            } else if name.lowercased() == "science" {
//                category3Btn.addBlurEffect(style: .dark,cornerRadius: 20)
//                category3Btn.isUserInteractionEnabled = false
//            } else if name.lowercased() == "mathematics" {
//                category4Btn.addBlurEffect(style: .dark,cornerRadius: 20)
//                category4Btn.isUserInteractionEnabled = false
//            }
//        }
//    }
    
    func loadbuttonUI() {
        //        category1Btn.setTitle("\(arrCategories[0].name)", for: .normal)
        //        category2Btn.setTitle("\(arrCategories[1].name)", for: .normal)
        //        category3Btn.setTitle("\(arrCategories[2].name)", for: .normal)
        //        category4Btn.setTitle("\(arrCategories[3].name)", for: .normal)
        
        for i in 0..<arrCategories.count {
            let name = arrCategories[i].name
            if name.lowercased() == "politics" {
                category1Btn.setBackgroundImage(UIImage(named: "POLITICS_1.png"), for: .normal)
                for j in 0..<arrFormattedCategories.count {
                    if arrFormattedCategories[j].categoryName == name {
                        if arrFormattedCategories[j].isPlayed {
                            category1Btn.addBlurEffect(style: .dark,cornerRadius: 20)
                            category1Btn.isUserInteractionEnabled = false
                        }
                    }
                }
                
            } else if name.lowercased() == "history" {
                category2Btn.setBackgroundImage(UIImage(named: "HISTORY.png"), for: .normal)
                for j in 0..<arrFormattedCategories.count {
                    if arrFormattedCategories[j].categoryName == name {
                        if arrFormattedCategories[j].isPlayed {
                            category2Btn.addBlurEffect(style: .dark,cornerRadius: 20)
                            category2Btn.isUserInteractionEnabled = false
                        }
                    }
                }
            } else if name.lowercased() == "science" {
                category3Btn.setBackgroundImage(UIImage(named: "SCIENCE.png"), for: .normal)
                for j in 0..<arrFormattedCategories.count {
                    if arrFormattedCategories[j].categoryName == name {
                        if arrFormattedCategories[j].isPlayed {
                            category3Btn.addBlurEffect(style: .dark,cornerRadius: 20)
                            category3Btn.isUserInteractionEnabled = false
                        }
                    }
                }
            } else if name.lowercased() == "mathematics" {
                category4Btn.setBackgroundImage(UIImage(named: "MATHS_1.png"), for: .normal)
                for j in 0..<arrFormattedCategories.count {
                    if arrFormattedCategories[j].categoryName == name {
                        if arrFormattedCategories[j].isPlayed {
                            category4Btn.addBlurEffect(style: .dark,cornerRadius: 20)
                            category4Btn.isUserInteractionEnabled = false
                        }
                    }
                }
            }
        }
//        updateBlurButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Reachability.isConnectedToNetwork() {
            self.updateLastSyncDate()
        }
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onBtnTapped(_ sender: UIButton) {
        
        var intTag = ""
        var selectedCategory = ""
        
        switch sender.tag {
        case 1:
            selectedCategory = "Politics"
            
        case 2:
            selectedCategory = "History"
            
        case 3:
            selectedCategory = "Science"
            
        case 4:
            selectedCategory = "Mathematics"
            
            
        default:
            break
        }
        
        let VC = storyboard?.instantiateViewController(withIdentifier: "QuesAnsVC") as! QuesAnsVC
        
        VC.Id = intTag
        VC.selectedCategory = selectedCategory
        VC.selectedDoctorID = selectedDoctorID
        VC.selectedDoctorName = selectedDoctorName
        VC.selectedMRID = selectedMRID
        VC.selectedQuestionType = selectedQuestionType
        self.navigationController?.pushViewController(VC, animated: true)
        
    }
    func updateBlurbutton(doctorsList: DoctorModel) {
        for i in 0..<doctorsList.count {
            let doctor = doctorsList[i].isPlayed
            if doctor {
                switch i {
                case 0:
                    category1Btn.addBlurEffect(style: .dark,cornerRadius: 30)
                    category1Btn.isUserInteractionEnabled = false
                case 1:
                    category2Btn.addBlurEffect(style: .dark,cornerRadius: 30)
                    category2Btn.isUserInteractionEnabled = false
                case 2:
                    category3Btn.addBlurEffect(style: .dark,cornerRadius: 30)
                    category3Btn.isUserInteractionEnabled = false
                case 3:
                    category4Btn.addBlurEffect(style: .dark,cornerRadius: 30)
                    category4Btn.isUserInteractionEnabled = false
                default:
                    break
                }
            }
        }
    }
    
    
}
