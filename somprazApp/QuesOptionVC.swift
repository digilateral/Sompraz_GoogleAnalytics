//
//  QuesOptionVC.swift
//  somprazApp
//
//  Created by digiLATERAL on 28/11/23.
//

import UIKit

class QuesOptionVC: UIViewController {
    
    @IBOutlet weak var ques4Btn: UIButton!
    
    @IBOutlet weak var quesMultipleBtn: UIButton!
    
    var selectedDoctorID = ""
    var selectedDoctorName = ""
    var selectedMRID = ""
    
    var selectedQuestionType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MRID :", selectedMRID)
        
        // Create a custom back button
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "backImage1"), for: .normal) // Set your custom back button image
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        // Add the custom back button to the view
        view.addSubview(backButton)
        // Position the custom back button as needed
        backButton.frame = CGRect(x: 16, y: 40, width: 30, height: 30) // Adjust the frame as needed
        
        view.bringSubviewToFront(backButton)
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        if Reachability.isConnectedToNetwork() {
            self.updateLastSyncDate()
        }
    }
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    
    func quiz1() {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ActiveCategoryVC") as! ActiveCategoryVC
        VC.selectedMRID = self.selectedMRID
        VC.selectedQuestionType = "MULTIPLE"
        VC.selectedDoctorID = selectedDoctorID
        VC.selectedDoctorName = selectedDoctorName
        
        // sync question type in userDefaults
        UserDefaults.set("MULTIPLE", forKey: UserDefaultsKeys.selectedQuestionType.rawValue)
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    
    func quiz2() {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ActiveCategoryVC") as! ActiveCategoryVC
        VC.selectedMRID = self.selectedMRID
        VC.selectedQuestionType = "FOUR"
        VC.selectedDoctorID = selectedDoctorID
        VC.selectedDoctorName = selectedDoctorName
        // sync question type in userDefaults
        UserDefaults.set("FOUR", forKey: UserDefaultsKeys.selectedQuestionType.rawValue)
        
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    //    func submitScore() {
    //        // Define the URL for the API
    //        let apiUrl = "https://quizapi-omsn.onrender.com/api/submit/score"
    //        
    //        // Define the JSON data to be sent in the request
    //        let json: [String: Any] = [
    //            "totalPoints": score,
    //            "categoryName": selectedCategory,
    //            "userId": selectedDoctorID
    //        ]
    //        
    //        do {
    //            let jsonData = try JSONSerialization.data(withJSONObject: json)
    //            
    //            // Create the URLRequest
    //            var request = URLRequest(url: URL(string: apiUrl)!)
    //            request.httpMethod = "POST"
    //            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //            request.httpBody = jsonData
    //            
    //            // Create a URLSession task for the request
    //            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
    //                if let error = error {
    //                    print("Error: \(error)")
    //                    // Handle the error, e.g., show an alert
    //                } else if let data = data {
    //                    // Handle the response data, if needed
    //                    print("Response data: \(String(data: data, encoding: .utf8) ?? "No data")")
    //                    
    //                    //            post api to save tottals points ,categoryname and userid
    //                    //            api = https://quizapi-omsn.onrender.com/api/submit/score
    //                }
    //            }
    //            
    //            // Execute the task
    //            task.resume()
    //        } catch {
    //            print("Error serializing JSON: \(error)")
    //            // Handle the error, e.g., show an alert
    //        }
    //    }
    
    @IBAction func ques4BtnTapped(_ sender: UIButton) {
        quiz2()
    }
    
    @IBAction func quesMultipleBtnTapped(_ sender: UIButton) {
        quiz1()
    }
    
}
