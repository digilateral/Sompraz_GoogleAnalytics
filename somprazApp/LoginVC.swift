//
//  ViewController.swift
//  somprazApp
//
//  Created by digiLATERAL on 09/10/23.
//

import UIKit
import KRProgressHUD
import FirebaseCore
class LoginVC: UIViewController {
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var userLoginLbl: UILabel!
    @IBOutlet weak var mainImgView: UIImageView!
    @IBOutlet weak var employeeTF: UITextField!
    @IBOutlet weak var passswordTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var forgotLbl: UILabel!
    @IBOutlet weak var somprazLbl: UILabel!
    @IBOutlet weak var forgotPwBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        forgotPwBtn.layer.borderColor = UIColor.white.cgColor
        loginBtn.layer.cornerRadius = 30
        employeeTF.delegate = self
        passswordTF.delegate = self
        
        employeeTF.alpha = 0
        passswordTF.alpha = 0
        loginBtn.alpha = 0
        loginView.alpha = 0
        
        let button = UIButton(type: .roundedRect)
              button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
              button.setTitle("Test Crash", for: [])
              button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
              view.addSubview(button)
        
        //        check()
    }
    
    @IBAction func crashButtonTapped(_ sender: AnyObject) {
          let numbers = [0]

        let _ = numbers[1]
        
      
      }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loginView.alpha = 1
        employeeTF.alpha = 1
        passswordTF.alpha = 1
        loginBtn.alpha = 1
        
        if Reachability.isConnectedToNetwork() {
            self.updateLastSyncDate()
        }
        
        // Existing code related to animations is removed
        
        // The rest of your code...
    }
    
    
    
    @IBAction func loginBtnTapped(_ sender: UIButton) {
        
    
        
        // Check if both text fields are filled
        if let enterDocNameText = employeeTF.text, !enterDocNameText.isEmpty,
           let placeText = passswordTF.text, !placeText.isEmpty {
            // Text fields are not empty, proceed to the next screen
            postMRData() 
        } else {
            // Display an alert if either or both text fields are empty
            let alert = UIAlertController(title: "Validation Error", message: "Please fill in both text fields.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func forgotPWBtnTapped(_ sender: UIButton) {
        
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "PopUpVC") as! PopUpVC
        self.navigationController?.pushViewController(VC, animated: true)
        
    }
    
    
    func postMRData() {
        KRProgressHUD.show(withMessage: "Loading...")
        guard let url = URL(string: "https://quizapi-omsn.onrender.com/api/login-mr") else {
            return
        }
        
        let MRName = employeeTF.text ?? ""
        let password = passswordTF.text ?? ""
        
        let bodyParameters: [String: Any] = [
            "MRID": MRName,
            "PASSWORD": password
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: bodyParameters, options: .prettyPrinted)
            
            // Print the raw JSON data before attempting to decode
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Request JSON: \(jsonString)")
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Network Error: \(error)")
                    KRProgressHUD.showError()
                    // Handle network error (e.g., show an alert to the user)
                    return
                }
                
                if let data = data {
                    // Print the raw JSON data received from the API
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Received JSON: \(jsonString)")
                    }
                    
                    do {
                        let decoder = JSONDecoder()
                        let mrInsert = try decoder.decode(SelectMRModel.self, from: data)
                        
                        // Save data to UserDefaults
                        if let encodedMRData = try? JSONEncoder().encode(mrInsert) {
                            
                            UserDefaults.standard.set(encodedMRData, forKey: "MRData")
                            
                            print("MRData successfully saved to UserDefaults: \(mrInsert)")
                        }
                        
                        
                        
                        
                        DispatchQueue.main.async {
                            KRProgressHUD.showSuccess()
                            // Print the decoded data
                            print("API Result Before Navigation: \(mrInsert)")
                            
                            let VC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                            print(VC.selectedMRID)
                            print(mrInsert.mrId)
                            VC.selectedMRID = mrInsert.mrId
                            self.navigationController?.pushViewController(VC, animated: true)
                        }
                    } catch let decodingError {
                        KRProgressHUD.showError()
                        print("Error decoding JSON data: \(decodingError)")
                        // Handle decoding error (e.g., show an alert to the user)
                    }
                }
            }
            task.resume()
        } catch {
            print("Error creating JSON data: \(error)")
            // Handle JSON serialization error
        }
    }
    
    
    
}
extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == employeeTF {
            passswordTF.becomeFirstResponder() // Move focus to the password field
        } else if textField == passswordTF {
            textField.resignFirstResponder() // Hide the keyboard
        }
        return true
    }
}
