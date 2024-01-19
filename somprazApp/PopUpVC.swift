//
//  PopUpVC.swift
//  somprazApp
//
//  Created by digiLATERAL on 19/12/23.
//

import UIKit

class PopUpVC: UIViewController {
    
    
    @IBOutlet weak var forgotPWLbl: UILabel!
    @IBOutlet weak var mridTF: UITextField!
    @IBOutlet weak var forgotPWBtn: UIButton!
    
    @IBOutlet weak var popView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Reachability.isConnectedToNetwork() {
            self.updateLastSyncDate()
        }
    }
    
    
    func postEmpID() {
        guard let url = URL(string: "https://quizapi-omsn.onrender.com/api/forget-mr-password") else {
            return
        }
        
        let empName = mridTF.text ?? ""
        
        guard let EmpName = empName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            // Handle encoding error
            return
        }
        
        let bodyParameters: [String: Any] = [
            "mrId": EmpName
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: bodyParameters)
            
            // Print the raw JSON data before attempting to decode
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Request JSON: \(jsonString)")
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            request.timeoutInterval = 30 // Set the timeout interval in seconds (adjust as needed)
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Network Error: \(error)")
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
                        let mrInsert = try decoder.decode(SubmitPWModel.self, from: data)
                        
                        
                        DispatchQueue.main.async {
                            // UI updates here
                            print("API Result Before Navigation: \(mrInsert)")
                            //                            
                            //                            // Create an alert controller
                            //                            let alertController = UIAlertController(title: "Password Reset", message: mrInsert.msg, preferredStyle: .alert)
                            //                            
                            //                            // Set preferred content size to increase the size of the alert
                            //                            alertController.preferredContentSize = CGSize(width: 300, height: 200) // Adjust the width and height as needed
                            //                            
                            //                            // Create an OK action
                            //                            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                            //                                // Dismiss the current view controller and navigate to the loginVC
                            //                                self.dismiss(animated: true) {
                            //                                    // Code to navigate to the loginVC (assuming loginVC is the destination)
                            //                            self.navigationController?.popViewController(animated: true)
                            //                                    
                            //                             
                            //                                }
                            //                            }
                            //                            
                            //                            // Add the OK action to the alert controller
                            //                            alertController.addAction(okAction)
                            //                            
                            //                            // Present the alert
                            //                            self.present(alertController, animated: true, completion: nil)
                            
                            if let success = mrInsert.success, success == true {
                                
                                //                             if response is success
                                
                                // Create an alert controller
                                let alertController = UIAlertController(title: "Password Reset Success", message: mrInsert.msg, preferredStyle: .alert)
                                
                                // Set preferred content size to increase the size of the alert
                                alertController.preferredContentSize = CGSize(width: 300, height: 200) // Adjust the width and height as needed
                                
                                // Create an OK action
                                let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                                    // Dismiss the current view controller and navigate to the loginVC
                                    self.dismiss(animated: true) {
                                        // Code to navigate to the loginVC (assuming loginVC is the destination)
                                        self.navigationController?.popViewController(animated: true)
                                        
                                        
                                    }
                                }
                                
                                // Add the OK action to the alert controller
                                alertController.addAction(okAction)
                                
                                // Present the alert
                                self.present(alertController, animated: true, completion: nil)
                                
                            } else {
                                //                               if response is failure
                                
                                // Create an alert controller
                                let alertController = UIAlertController(title: "Password Reset Error", message: mrInsert.msg, preferredStyle: .alert)
                                
                                // Set preferred content size to increase the size of the alert
                                alertController.preferredContentSize = CGSize(width: 300, height: 200) // Adjust the width and height as needed
                                
                                // Create an OK action
                                let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                                    // Dismiss the current view controller and navigate to the loginVC
                                    self.dismiss(animated: true) {
                                        // Code to navigate to the loginVC (assuming loginVC is the destination)
                                        self.navigationController?.popViewController(animated: true)
                                        
                                        
                                    }
                                }
                                
                                // Add the OK action to the alert controller
                                alertController.addAction(okAction)
                                
                                // Present the alert
                                self.present(alertController, animated: true, completion: nil)
                                
                                
                            }
                            
                        }
                    } catch let decodingError {
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
    
    
    
    
    @IBAction func gorgotPWBtnTapped(_ sender: UIButton) {
        
        // Check if both text fields are filled
        if let enterMrIdText = mridTF.text, !enterMrIdText.isEmpty {
            // Text fields are not empty, proceed to the next screen
            
            postEmpID()
            
        } else {
            // Display an alert if either or both text fields are empty
            let alert = UIAlertController(title: "Validation Error", message: "Please fill the text field.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    
    
}



