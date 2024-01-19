import UIKit
import iOSDropDown
import KRProgressHUD

struct APIError: Codable {
    let msg: String
}

class HomeVC: UIViewController {
    
    @IBOutlet weak var enterDocNameTF: UITextField!
    @IBOutlet weak var enterSCcode: UITextField!
    @IBOutlet weak var placeTF: UITextField!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var orLbl: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var selectDocName: DropDown!
    @IBOutlet weak var somprazLbl: UILabel!
    
    var docDisplayList = [String]()
    var arrDocList = [SubmitDocMRIDElement]()
    var selectedDoctorID = ""
    var selectedDoctorName = ""
    var selectedMRID = ""
    var mrId = ""
    var selectedDoctorState = ""
    var arrActiveCategories = [OnlyActiveCategory]()
    
    weak var timer: Timer?
    var remainingTime = 99999999999999
    
    weak var timer1: Timer?
    var remainingTime1 = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        addBtn.layer.cornerRadius = 30
        submitBtn.layer.cornerRadius = 30
        print(selectedMRID)
        enterDocNameTF.delegate = self
        placeTF.delegate = self
        enterSCcode.delegate = self
        
        //sync MRId in userdefaults
        UserDefaults.set(selectedMRID, forKey: UserDefaultsKeys.MRId.rawValue)
        
        // Configure the DropDown to enable searching
        selectDocName.isSearchEnable = true
        selectDocName.contentMode = .left
        addLogoutButton()
        
        // Prevent the keyboard from showing up when tapping on selectDocName
        selectDocName.inputView = UIView()
        
        
        
        
        selectDocName.didSelect{(selectedText , index ,id) in
            print("Selected item: \(selectedText) at index: \(index)")
            self.selectedDoctorID = self.arrDocList[index].id
            self.selectedDoctorName = "Dr. " + self.arrDocList[index].doctorName
            self.selectedDoctorState = self.arrDocList[index].locality ?? ""
            print("Selected Doctor ID: \(id)")
            
            //sync doctor ID in userdefaults
            UserDefaults.set(self.selectedDoctorID, forKey: UserDefaultsKeys.selectDoctorId.rawValue)
            // Close the dropdown when an item is selected
            self.selectDocName.hideList()
            
            self.view.endEditing(true)
            
            // Check if user categories data is present in UserDefaults
            //            do {
            ////                UserDefaults.set(userCategories, forKey: UserDefaultsKeys.categories.rawValue)
            //                // Assuming you have some data in UserDefaults named 'savedUserData'
            //                
            //                if let savedUserData = UserDefaults.standard.data(forKey: "CategoryData") {
            //                    let decodedData: [String: [CategoryModelElement]]
            //                    decodedData = try JSONDecoder().decode([String: [CategoryModelElement]].self, from: savedUserData)
            //                    
            //                    if let categoryModel = decodedData["categories"] {
            //                        // Use categoryModel as needed
            //                        print("Successfully decoded: \(categoryModel)")
            //                    } else {
            //                        print("Error: Unable to retrieve 'categories' from decoded data.")
            //                    }
            //                } else {
            //                    print("Error: No data found in UserDefaults.")
            //                }
            //            } catch let decodingError {
            //                print("Error decoding JSON data for User Categories: \(decodingError)")
            //            }
            
            // else {
            //                   // User categories data is not present
            //                   print("Error: User categories data is not synced on the device.")
            //               }
            
        }
        
        
    }
    
    func getAllUsersData(completionHandler: @escaping (_ success: Bool?, _ error: Error?) -> ()){
        
        for i in 0..<arrDocList.count {
            let docObj = arrDocList[i]
            let tempDocID = docObj.id
            
            self.getCategorieswithQuestion(doctorId: tempDocID) { baseObj, error in
                if let baseObj = baseObj {
                    let formattedCategories = baseObj.formattedCategories
                    print(tempDocID)
                    print("Formatted Categories \(formattedCategories)")
                    if let encodedData = try? JSONEncoder().encode(formattedCategories) {
                        let key = "BlurCategories" + tempDocID
                        UserDefaults.standard.set(encodedData, forKey: key)
                        UserDefaults.standard.synchronize()
                        
                    }
                    print("BlurCategories")
                }
                if let error = error {
                    print("Error in getting categories data")
                }
            }
            
            //            if i == arrDocList.count - 1 {
            //                DispatchQueue.main.async {
            //                    ProgressHUD.showSuccess("Sync success", interaction: true)
            //                }
            //            }
        }
        
        completionHandler(true, nil)
    }
    
    func didHandleDropdownSelectAction() {
        
        
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        timer1 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer1), userInfo: nil, repeats: true)
        if Reachability.isConnectedToNetwork() {
            DispatchQueue.main.async {
                self.updateLastSyncDate()
                KRProgressHUD.show(withMessage: "Syncing Data...")
                self.submitBtn.isUserInteractionEnabled = false
            }
        }
    }
    @objc func updateTimer1() {
        if remainingTime1 > 0 {
            remainingTime1 -= 1
            
        } else {
            DispatchQueue.main.async {
                self.timer1?.invalidate()
                self.timer1 = nil
                print("Timer invalidated")
                DispatchQueue.main.async {
                    KRProgressHUD.showSuccess()
                    self.submitBtn.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    @objc func updateTimer() {
        if remainingTime > 0 {
            remainingTime -= 1
            if Reachability.isConnectedToNetwork() {
                DispatchQueue.main.async {
                    self.syncStatus()
                }
            }
        } else {
            DispatchQueue.main.async {
                self.timer?.invalidate()
                self.timer = nil
                print("Timer invalidated")
            }
        }
    }
    
    func addLogoutButton() {
        let backButton2 = UIButton(type: .custom)
        backButton2.setImage(UIImage(named: "logout"), for: .normal)
        backButton2.addTarget(self, action: #selector(backButton2Tapped), for: .touchUpInside)
        backButton2.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton2)
        
        let buttonHeight: CGFloat = 30
        let bottomSpacing: CGFloat = 40
        
        // Create constraints
        backButton2.widthAnchor.constraint(equalToConstant: 30).isActive = true
        backButton2.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        backButton2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        backButton2.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottomSpacing).isActive = true
        
        view.bringSubviewToFront(backButton2)
    }
    
    
    
    // getting Doctor details on submit button tapped
    func getDoctorList(completionHandler: @escaping (_ success: Bool?, _ error: Error?) -> ()) {
        
        //        DispatchQueue.main.async {
        //            ProgressHUD.show("Syncing Data...")
        //        }
        guard let url = URL(string: "https://quizapi-omsn.onrender.com/api/get/get-only-name-with-id") else {
            return
        }
        
        let bodyParameters: [String: Any] = [
            "mrId": selectedMRID
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
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Network Error: \(error)")
                    KRProgressHUD.showError()
                    // Handle network error (show an alert to the user)
                    //                    DispatchQueue.main.async {
                    //                        let alert = UIAlertController(title: "Network Error", message: "An error occurred while communicating with the server. Please try again later.", preferredStyle: .alert)
                    //                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    //                        alert.addAction(okAction)
                    //                        self.present(alert, animated: true, completion: nil)
                    //                    }
                    
                    return
                }
                
                if let data = data {
                    // Print the raw JSON data received from the API
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Received JSON: \(jsonString)")
                    }
                    
                    do {
                        let doctors = try JSONDecoder().decode(SubmitDocMRID.self, from: data)
                        
                        // Save the data to UserDefaults
                        if let encodedData = try? JSONEncoder().encode(doctors) {
                            UserDefaults.standard.set(encodedData, forKey: UserDefaultsKeys.doctorList.rawValue)
                            UserDefaults.standard.synchronize()
                            print("Doctor data successfully synced and saved to UserDefaults: \(doctors)")
                        }
                        
                        DispatchQueue.main.async {
                            
                            self.docDisplayList = [String]()
                            self.arrDocList = [SubmitDocMRIDElement]()
                            self.arrDocList = doctors
                            for i in 0..<doctors.count {
                                let docObj = doctors[i]
                                let name = docObj.doctorName
                                let scCode = docObj.scCode
                                
                                var strLocality = ""
                                if let locality = docObj.locality {
                                    strLocality = locality
                                }
                                
                                let n = "Dr. " + name + "        " + scCode + "        " + strLocality
                                
                                self.docDisplayList.append(n)
                            }
                            
                            self.selectDocName.optionArray = self.docDisplayList
                            
                            completionHandler(true, nil)
                            //                            DispatchQueue.main.async {
                            //                                ProgressHUD.showSuccess("Sync Success", interaction: true)
                            //                            }
                            
                        }
                    } catch let decodingError {
                        print("Error decoding JSON data: \(decodingError)")
                        // Handle decoding error (e.g., show an alert to the user)
                        
                        // Handle decoding error (show an alert to the user)
                        DispatchQueue.main.async {
                            KRProgressHUD.showError()
                            let alert = UIAlertController(title: "Decoding Error", message: "An error occurred while processing data from the server. Please try again later.", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                            completionHandler(false, error)
                        }
                        
                    }
                    
                }
            }
            task.resume()
        } catch {
            print("Error creating JSON data: \(error)")
            // Handle JSON serialization error
            
            // Handle JSON serialization error (show an alert to the user)
            DispatchQueue.main.async {
                KRProgressHUD.showError()
                let alert = UIAlertController(title: "Serialization Error", message: "An error occurred while preparing data for the server. Please try again later.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        remainingTime = 99999999999999
        remainingTime1 = 15
        startTimer()
        
        if Reachability.isConnectedToNetwork() {
            
            self.getDoctorList { success, error in
                if let success = success, success {
                    
                    self.getAllUsersData { success, error in
                        if let success = success, success {
                            if self.arrActiveCategories.count != 0 {
                                self.saveCategoryLeaderBoard()
                            }
                            //                        ProgressHUD.showSuccess("Sync success", interaction: true)
                        }
                    }
                    
                }
                
                if let error = error {
                    print(error)
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.timer?.invalidate()
            self.timer = nil
            self.timer1?.invalidate()
            self.timer1 = nil
            print("Timer invalidated")
        }
    }
    
    func syncStatus() {
        if Reachability.isConnectedToNetwork() {
            
            let status = UserDefaults.standard.value(forKey: UserDefaultsKeys.syncStatus.rawValue) as? Bool
            if let status = status, status {
                DispatchQueue.main.async {
                    
                    do {
                        // Assuming you have some data in UserDefaults named 'savedUserData'
                        
                        if let savedUserData = UserDefaults.standard.value(forKey: UserDefaultsKeys.syncData.rawValue) {
                            
                            let arrSync = try JSONDecoder().decode(syncModel.self, from: savedUserData as! Data)
                            print("Local data")
                            print(arrSync)
                            
                            for i in 0..<arrSync.count {
                                let dic = arrSync[i]
                                self.syncScore(category: dic.categoryName, userID: dic.userId, score: dic.totalPoints) { success, error in
                                    if let success = success, success {
                                        print("Sync success for previous played users")
                                        
                                        do {
                                            // Assuming you have some data in UserDefaults named 'savedUserData'
                                            //                                            ProgressHUD.show("Syncing Data...")
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                                self.getAllUsersData { success, error in
                                                    if let success = success, success {
                                                        
                                                        //                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                                                        //                                                            ProgressHUD.showSuccess("Sync success", interaction: true)
                                                        //                                                        }
                                                    }
                                                }
                                            }
                                            
                                            
                                            if let savedUserData = UserDefaults.standard.value(forKey: UserDefaultsKeys.ActiveCategoriesArray.rawValue) {
                                                var arrCategories = [OnlyActiveCategory]()
                                                arrCategories = try JSONDecoder().decode([OnlyActiveCategory].self, from: savedUserData as! Data)
                                                for i in 0..<arrCategories.count {
                                                    let category = arrCategories[i].name
                                                    
                                                    self.getdoctorsCategory(category: category) { arrLeaderboard, error in
                                                        let json = [category : arrLeaderboard]
                                                        if let encodedData = try? JSONEncoder().encode(json) {
                                                            UserDefaults.standard.set(encodedData, forKey: "\(category)")
                                                            UserDefaults.standard.synchronize()
                                                        }
                                                    }
                                                    
                                                }
                                                
                                                
                                                
                                            } else {
                                                print("Error: No data found in UserDefaults.")
                                            }
                                        } catch let decodingError {
                                            print("Error decoding JSON data for User Categories: \(decodingError)")
                                        }
                                        
                                        
                                        
                                    }
                                    
                                    if let error = error {
                                        print(error)
                                    }
                                }
                            }
                            
                            UserDefaults.standard.set(false, forKey: UserDefaultsKeys.syncStatus.rawValue)
                            UserDefaults.standard.synchronize()
                            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.syncData.rawValue)
                            
                        } else {
                            print("Error: No data found in UserDefaults.")
                        }
                    } catch let decodingError {
                        print("Error decoding JSON data for User Categories: \(decodingError)")
                    }
                    
                    
                    
                    
                    
                }
            }
        }
        
    }
    
    @objc func backButton2Tapped() {
        navigationController?.popToViewController(ofClass: LoginVC.self)
    }
    
    
    @IBAction func addBtnTapped(_ sender: UIButton) {
        
        // Check if both text fields are filled
        if let enterDocNameText = enterDocNameTF.text, !enterDocNameText.isEmpty,
           let placeText = placeTF.text, !placeText.isEmpty {
            // Text fields are not empty, proceed to the next screen
            
            postDoctorData()
            
        } else {
            // Display an alert if either or both text fields are empty
            let alert = UIAlertController(title: "Validation Error", message: "Please fill in both text fields.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    // Call on Add button
    func postDoctorData() {
        //        ProgressHUD.show("Please wait")
        guard let url = URL(string: "https://quizapi-omsn.onrender.com/api/user"),
              let docName = enterDocNameTF.text,
              let state = placeTF.text,
              let scCode = enterSCcode.text else {
            return
        }
        
        let bodyParameters: [String: Any] = [
            "doctorName": docName,
            "state": state,
            "scCode": scCode,
            "mrId": selectedMRID
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: bodyParameters, options: .prettyPrinted)
            
            // Print the raw JSON data before attempting to decode
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Request JSON: \(jsonString)")
            }
            
            var request = URLRequest(url: url, timeoutInterval: 60)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error as NSError?, error.domain == NSURLErrorDomain, error.code == NSURLErrorTimedOut {
                    print("Request timed out. Retrying...")
                    KRProgressHUD.showError()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        
                        self.postDoctorData() // Retry after 5 seconds (you can adjust as needed)
                    }
                } else if let error = error {
                    KRProgressHUD.showError()
                    print("Network Error: \(error)")
                    // Handle other types of errors
                } else if let data = data {
                    //                    ProgressHUD.showSuccess()
                    // Print the raw JSON data received from the API
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Received JSON: \(jsonString)")
                    }
                    
                    
                    self.handleDoctorResponse(data)
                }
            }
            task.resume()
        } catch {
            KRProgressHUD.showError()
            print("Error creating JSON data: \(error)")
            // Handle JSON serialization error
        }
    }
    
    func handleDoctorResponse(_ data: Data) {
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let message = json["message"] as? String,
               let id = json["Id"] as? String {
                
                DispatchQueue.main.async {
                    self.getDoctorList { success, error in
                        if let success = success, success {
                            
                            // Process the data
                            print("API Result Before Navigation: \(message), Id: \(id)")
                            let state = self.placeTF.text ?? ""
                            if let encodedData = try? JSONEncoder().encode(state) {
                                UserDefaults.standard.set(encodedData, forKey: UserDefaultsKeys.selectedDoctorState.rawValue)
                                UserDefaults.standard.synchronize()
                            }
                            
                            // Instantiate the QuesOptionVC from the storyboard
                            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                            
                            if let VC = storyboard.instantiateViewController(withIdentifier: "QuesOptionVC") as? QuesOptionVC {
                                // Set properties or pass data to the quesOptionVC if needed
                                VC.selectedDoctorID = id
                                VC.selectedDoctorName = self.enterDocNameTF.text ?? ""
                                VC.selectedMRID = self.selectedMRID
                                
                                
                                // Push the quesOptionVC onto the navigation stack
                                if let navigationController = self.navigationController {
                                    navigationController.pushViewController(VC, animated: true)
                                } else {
                                    print("Error: Navigation controller not found.")
                                }
                            } else {
                                print("Error: Unable to instantiate QuesOptionVC from the storyboard.")
                            }
                        }
                        
                        if let error = error {
                            print(error)
                        }
                    }
                    
                }
            }
        } catch {
            print("Error parsing JSON data: \(error)")
            // Handle decoding error (e.g., show an alert to the user)
        }
    }
    
    
    @IBAction func docNameDrpDownTapped(_ sender: DropDown) {
        
    }
    
    // Add an action for the Submit button
    @IBAction func submitBtnTapped(_ sender: UIButton) {
        // Check if a selection has been made in the dropdown
        if let selectedDoctor = selectDocName.text, !selectedDoctor.isEmpty, !selectedDoctorName.isEmpty {
            if let encodedData = try? JSONEncoder().encode(selectedDoctorState) {
                UserDefaults.standard.set(encodedData, forKey: UserDefaultsKeys.selectedDoctorState.rawValue)
                UserDefaults.standard.synchronize()
            }
            
            // Proceed to the next screen
            if let VC = self.storyboard?.instantiateViewController(withIdentifier: "QuesOptionVC") as? QuesOptionVC {
                print("Selected Doctor ID: \(self.selectedDoctorID)")
                
                VC.selectedMRID = selectedMRID
                VC.selectedDoctorID = selectedDoctorID
                VC.selectedDoctorName = selectedDoctorName
                
                self.navigationController?.pushViewController(VC, animated: true)
            }
        } else {
            // Display an alert if the dropdown is not selected
            let alert = UIAlertController(title: "Validation Error", message: "Please select Doctor's Name.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func getCategorieswithQuestion(doctorId: String, completionHandler: @escaping (_ success: CategoriesWithQuestions?, _ error: Error?) -> ()) {
        guard let url = URL(string: "https://quizapi-omsn.onrender.com/api/get/user-category-with-mulquestions-fourquestions/\(doctorId)") else {
            return
        }
        //        DispatchQueue.main.async {
        //            ProgressHUD.show("Syncing Data...")
        //        }
        
        URLSession.shared.makeRequest(url: url, expecting: CategoriesWithQuestions.self) { [weak self] result in
            switch result {
            case .success(let Categoriesquestions):
                print(Categoriesquestions)
                
                let arrMultipleQuestions = Categoriesquestions.multipleQuestions
                let arrfourQuestions = Categoriesquestions.onlyFourActiveQuestions
                let arrFormattedCategories = Categoriesquestions.formattedCategories
                let ActiveCategories = Categoriesquestions.onlyActiveCategories
                self?.arrActiveCategories = [OnlyActiveCategory]()
                self?.arrActiveCategories = ActiveCategories
                if let encodedData = try? JSONEncoder().encode(arrMultipleQuestions) {
                    UserDefaults.standard.set(encodedData, forKey: UserDefaultsKeys.multipleQuestionsArray.rawValue)
                    UserDefaults.standard.synchronize()
                }
                
                if let encodedData = try? JSONEncoder().encode(arrfourQuestions) {
                    UserDefaults.standard.set(encodedData, forKey: UserDefaultsKeys.FourQuestionsArray.rawValue)
                    UserDefaults.standard.synchronize()
                }
                if let encodedData = try? JSONEncoder().encode(arrFormattedCategories) {
                    UserDefaults.standard.set(encodedData, forKey: UserDefaultsKeys.FormattedCategoriesArray.rawValue)
                    UserDefaults.standard.synchronize()
                }
                if let encodedData = try? JSONEncoder().encode(self?.arrActiveCategories) {
                    UserDefaults.standard.set(encodedData, forKey: UserDefaultsKeys.ActiveCategoriesArray.rawValue)
                    UserDefaults.standard.synchronize()
                }
                
                
                completionHandler(Categoriesquestions, nil)
                //                DispatchQueue.main.async {
                //                    ProgressHUD.showSuccess("Sync Success", interaction: true)
                //                }
            case .failure(let error):
                print(error)
                completionHandler(nil, error)
                print("playAgain")
                KRProgressHUD.showError()
            }
            //             Dismiss the loading indicator when the network request is complete
            
        }
    }
    
    func saveCategoryLeaderBoard() {
        for i in 0..<arrActiveCategories.count {
            let category = arrActiveCategories[i].name
            
            self.getdoctorsCategory(category: category) { arrLeaderboard, error in
                let json = [category : arrLeaderboard]
                if let encodedData = try? JSONEncoder().encode(json) {
                    UserDefaults.standard.set(encodedData, forKey: "\(category)")
                    UserDefaults.standard.synchronize()
                }
            }
            
            
            
        }
        
    }
    
    
    func getdoctorsCategory(category: String, completionHandler: @escaping (_ id: [CategoryLeaderboard]?, _ error: Error?) -> ()) {
        //        DispatchQueue.main.async {
        //            ProgressHUD.show("Syncing Data...")
        //        }
        if let mrId = selectedMRID.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
           let url = URL(string: "https://quizapi-omsn.onrender.com/api/get/leaderboard/\(category)/\(mrId)") {
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let leaderboardData = try JSONDecoder().decode(LeaderBoardModel.self, from: data)
                        let arrLeaderboard = leaderboardData.categoryLeaderboard
                        
                        completionHandler(arrLeaderboard, nil)
                        //                        DispatchQueue.main.async {
                        //                            ProgressHUD.showSuccess("Sync Success", interaction: true)
                        //                        }
                    } catch {
                        KRProgressHUD.showError()
                        completionHandler(nil, error)
                        print("Error decoding JSON: \(error)")
                    }
                } else if let error = error {
                    KRProgressHUD.showError()
                    completionHandler(nil, error)
                    print("Error fetching data: \(error)")
                }
            }.resume()
        }
    }
    
    
    //     Add this function to sync user categories
    //     Update syncUserCategories function to accept doctorId
    //    func syncUserCategories(doctorId: String) {
    //        guard let url = URL(string: "https://quizapi-omsn.onrender.com/api/get/user-category/\(doctorId)") else {
    //            return
    //        }
    //        
    //        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
    //            if let error = error {
    //                print("Network Error: \(error)")
    //                // Handle network error (show an alert to the user)
    //                // ... (rest of your error handling code)
    //                return
    //            }
    //            
    //            if let data = data {
    //                do {
    //                    // Print the received JSON data
    //                    let jsonString = String(data: data, encoding: .utf8)
    //                    print("Received JSON data: \(jsonString ?? "")")
    //                    
    //                    let decoder = JSONDecoder()
    //                    let userCategories = try decoder.decode(CategoryModel.self, from: data)
    //                    
    //                    if let encodedData = try? JSONEncoder().encode(userCategories) {
    //                        UserDefaults.standard.set(encodedData, forKey: UserDefaultsKeys.categories.rawValue)
    //                        UserDefaults.standard.synchronize()
    //                        
    //                    }
    //                    
    //                } catch let decodingError {
    //                    print("Error decoding JSON data for User Categories: \(decodingError)")
    //                    // Handle decoding error (show an alert to the user)
    //                    // ... (rest of your error handling code)
    //                }
    //            }
    //        }
    //        task.resume()
    //    }
}
extension HomeVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == enterDocNameTF {
            placeTF.becomeFirstResponder()  // Move focus to the placeTF
        } else if textField == placeTF {
            textField.resignFirstResponder()  // Hide the keyboard
        }
        return true
    }
}

extension UIViewController {
    
    func updateLastSyncDate() {
        let currentDate = Date()
        UserDefaults.standard.set(currentDate, forKey: UserDefaultsKeys.lastSyncDate.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    
    
    // Function to sync all scores
    func syncAllScores(completionHandler: @escaping (_ success: Bool, _ error: Error?) -> ()) {
        // Check if the network is reachable
        guard isNetworkReachable() else {
            print("Network is not reachable. Unable to sync scores.")
            completionHandler(false, nil)
            return
        }
        
        let userCategoryPairs: [(String, String, Int)] = [
            ("user1", "category1", 100),
            ("user2", "category2", 150),
            // Add more user and category combinations as needed
        ]
        
        let dispatchGroup = DispatchGroup()
        
        for (userID, category, score) in userCategoryPairs {
            dispatchGroup.enter()
            syncScore(category: category, userID: userID, score: score) { success, error in
                if let error = error {
                    print("Error syncing score for user \(userID) in category \(category): \(error)")
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            completionHandler(true, nil)
        }
    }
    
    // Function to check network reachability (a simple example)
        func isNetworkReachable() -> Bool {
            // Implement your own network reachability check here
            // This is a simple example, and you may need to customize it based on your requirements
            return true
        }
    
    
    func syncScore(category: String, userID: String, score: Int, completionHandler: @escaping (_ success: Bool?, _ error: Error?) -> ()) {

        let apiUrl = "https://quizapi-omsn.onrender.com/api/v2/submit/score"
        let json: [String: Any] = [
            
            "totalPoints": score,
            "categoryName": category,
            "userId": userID
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json)
            
            print(json)

            // Create the URLRequest
            var request = URLRequest(url: URL(string: apiUrl)!)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                    completionHandler(nil, error)
                    return
                }

                guard let data = data else {
                    print("No data received from the API.")
                    completionHandler(nil, nil)
                    return
                }

                do {
                    // Decode the response JSON if needed
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    print("Response JSON: \(jsonResponse ?? [:])")

                    // Handle the response data, update the database, etc.

                    completionHandler(true, nil)
                } catch {
                    print("Error decoding response JSON: \(error)")
                    completionHandler(nil, error)
                }
            }

            // Execute the task
            task.resume()
        } catch {
            print("Error serializing JSON: \(error)")
            completionHandler(nil, error)
        }
    }

    
    
     
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


extension UINavigationController {
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
            popToViewController(vc, animated: animated)
        }
    }
}
