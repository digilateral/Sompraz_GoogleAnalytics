//
//  VC5.swift
//  somprazApp
//
//  Created by digiLATERAL on 11/10/23.
//

import UIKit
import Foundation
import KRProgressHUD

class QuesAnsVC: UIViewController {
    
    @IBOutlet weak var mainImgView: UIImageView!
    @IBOutlet weak var ques4IV: UIImageView!
    @IBOutlet weak var topicIV: UIImageView!
    @IBOutlet weak var quesLbl: UILabel!
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var stackView1: UIStackView!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var stackView2: UIStackView!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var AlertImageView: UIImageView!
    @IBOutlet weak var drNameScorelbl: UILabel!
    @IBOutlet weak var MainAlertView: UIView!
    @IBOutlet weak var quesBtn: UIButton!
    @IBOutlet weak var MainCategoryLbl: UILabel!
    
    @IBOutlet weak var mainCategoryBtn: UIButton!
    
    
    var question: String = ""
    var arrAllQuestions = [QuizModelElement]()
    var arrSelectedCategoryQuestion = [QuizModelElement]()
    var currentQuestion : QuizModelElement?
    var answers = [AnswerOption]()
    var correctAnswer: Int?
    var selectedCategory: String = ""
    var displayedQuestionsID = [String]()
    var Id: String = ""
    var selectedDoctorName = ""
    var selectedDoctorID = ""
    var selectedMRID = ""
    var selectedQuestionType = ""
    // timer
    var time = 0
    var selectedCategoryImage: UIImage?
    var selectedDrDate =  Date()
    var dateString: String?
    var isButtonEnabled = true
    
    weak var timer: Timer?
    // Add a property to store the remaining time
    var remainingTime = 60 // Adjust the initial time as needed
    var score = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btn1.setTitleColor(UIColor.black, for: .normal)
        btn2.setTitleColor(UIColor.black, for: .normal)
        btn3.setTitleColor(UIColor.black, for: .normal)
        btn4.setTitleColor(UIColor.black, for: .normal)
        
        if selectedCategory.lowercased() == "politics" {
            mainCategoryBtn.setBackgroundImage(UIImage(named: "POLITICS_1.png"), for: .normal)
            
        } else if selectedCategory.lowercased() == "history" {
            mainCategoryBtn.setBackgroundImage(UIImage(named: "HISTORY.png"), for: .normal)
            
        } else if selectedCategory.lowercased() == "science" {
            mainCategoryBtn.setBackgroundImage(UIImage(named: "SCIENCE.png"), for: .normal)
            
        } else if selectedCategory.lowercased() == "mathematics" {
            mainCategoryBtn.setBackgroundImage(UIImage(named: "MATHS_1.png"), for: .normal)
            
        }
        
        
        
        //        // Assuming you have an array of category image names
        //        let categoryImages = ["POLITICS_1", "HISTORY", "SCIENCE", "MATHS_1"]
        //
        //        // This should be defined at a broader scope, maybe as a property of your class or within the method where you're handling the category selection
        //        var selectedCategoryIndex: Int = 0 // Set an initial value or update it based on user selection
        //
        //        // Assuming you have a selectedCategoryIndex representing the index of the selected category
        //        let selectedCategoryImageName = categoryImages[selectedCategoryIndex]
        //
        //        print("Selected Category Index: \(selectedCategoryIndex)")
        //        print("Selected Category Image Name: \(selectedCategoryImageName)")
        //
        //        // Assuming MainCategoryBtn is a UIButton and you have outlets properly set up
        //        let selectedImage = UIImage(named: selectedCategoryImageName)
        //        mainCategoryBtn.setBackgroundImage(selectedImage, for: .normal)
        
        print("Selected Category (ViewDidLoad): \(selectedCategory )")
        print("MRID :", selectedMRID)
        
        self.title = "" // Set an empty title
        // or
        self.navigationItem.title = nil
        MainAlertView.isHidden = true
        
        
        displayQuestions()
        
        
        
        btn1.layer.borderWidth = 4
        btn2.layer.borderWidth = 4
        btn3.layer.borderWidth = 4
        btn4.layer.borderWidth = 4
        
        btn1.layer.borderColor = UIColor.white.cgColor
        btn2.layer.borderColor = UIColor.white.cgColor
        btn3.layer.borderColor = UIColor.white.cgColor
        btn4.layer.borderColor = UIColor.white.cgColor
        
        btn1.layer.cornerRadius = 16
        btn2.layer.cornerRadius = 16
        btn3.layer.cornerRadius = 16
        btn4.layer.cornerRadius = 16
        
        quesBtn.titleLabel?.numberOfLines = 0 // Set to 0 for unlimited lines
        quesBtn.titleLabel?.lineBreakMode = .byWordWrapping // Wrap text to the next line by word
        // Assuming quesBtn is your UIButton
        let padding: CGFloat = 16 // You can adjust the padding as needed
        
        // Set contentEdgeInsets to add padding
        quesBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        
        quesBtn.titleLabel?.textAlignment = .center
        quesBtn.setTitle("Your multiline text goes here", for: .normal)
        quesBtn.titleLabel?.font = UIFont.systemFont(ofSize: 26)
        
        // Increase the font size for each button
        btn1.titleLabel?.font = UIFont.systemFont(ofSize: 24) // Adjust the size as needed
        btn2.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        btn3.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        btn4.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        
    }
    
    func displayQuestions() {
        
        var type = ""
        
        if selectedQuestionType == "FOUR" {
            type = UserDefaultsKeys.FourQuestionsArray.rawValue
            ques4IV.image = UIImage(named: "1")
        } else if selectedQuestionType == "MULTIPLE" {
            type = UserDefaultsKeys.multipleQuestionsArray.rawValue
            ques4IV.image = UIImage(named: "3")
        }
        
        
        do {
            // Assuming you have some data in UserDefaults named 'savedUserData'
            
            if let savedUserData = UserDefaults.standard.value(forKey: type) {
                
                if selectedQuestionType == "FOUR" {
                    let arrquestions = try JSONDecoder().decode([[QuizModelElement]].self, from: savedUserData as! Data)
                    for i in 0..<arrquestions.count {
                        let arr = arrquestions[i]
                        let finalQuestion = arr.filter { $0.category == self.selectedCategory }
                        if finalQuestion.count != 0 {
                            self.loadQuestion(questions: finalQuestion, type: selectedQuestionType)
                        }
                        
                    }
                    
                } else if selectedQuestionType == "MULTIPLE" {
                    let questions = try JSONDecoder().decode([QuizModelElement].self, from: savedUserData as! Data)
                    self.loadQuestion(questions: questions, type: selectedQuestionType)
                }
                
                
                
                
            } else {
                print("Error: No data found in UserDefaults.")
            }
        } catch let decodingError {
            print("Error decoding JSON data for User Categories: \(decodingError)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.MainAlertView.isHidden = true
        }
        if Reachability.isConnectedToNetwork() {
            self.updateLastSyncDate()
        }
        
    }
    //    
    //    func setUpUI() {
    //        
    //       if Id == "AstronomyYellow" {
    //            topicIV.image = UIImage(named: "AstronomyWhite" )
    //        } else if Id == "HistoryYellow" {
    //            topicIV.image = UIImage(named: "HistoryWhite" )
    //        } else if Id == "Science Yellow" {
    //            topicIV.image = UIImage(named: "Science White 1" )
    //        } else if Id == "Literature Yellow" {
    //            topicIV.image = UIImage(named: "Literature White" )
    //        } else if Id == "Geography Yellow" {
    //            topicIV.image = UIImage(named: "Geography White" )
    //        } else if Id == "Wildlife Yellow" {
    //            topicIV.image = UIImage(named: "Wildlife White" )
    //        } else if Id == "Technology Yellow" {
    //            topicIV.image = UIImage(named: "Technology White" )
    //        } else if Id == "Mathematics Yellow" {
    //            topicIV.image = UIImage(named: "Mathematics White" )
    //        }
    //        
    //    }
    
    //    func getFourQuestion() {
    //        guard let url = URL(string: "https://backup-quiz-server.onrender.com/api/questionfour?category=\(selectedCategory)") else {
    //            print("QUIZ ERROR OCCURRED")
    //            return
    //        }
    //        
    //        let loader = self.loader()
    //        
    //        URLSession.shared.makeRequest(url: url, expecting: [QuizModelElement].self) { [weak self] result in
    //            
    //            
    //            
    //            switch result {
    //                
    //                case .success(let questions):
    //                
    //                
    //                
    //                // Limit the number of questions to display
    //                            let numberOfQuestionsToShow = 4
    //                            let limitedQuestions = Array(questions.prefix(numberOfQuestionsToShow))
    //                
    //                print(result)
    //                
    //                // Start the timer with 1 minute for four questions
    //                          self?.startTimer()
    //                self?.loadQuestion(questions: questions)
    //                
    //            case .failure(let error):
    //                print(error)
    //                print("playAgain")
    //            }
    //            //             Dismiss the loading indicator when the network request is complete
    //            self?.stopLoader(loader: loader)
    //        }
    //    }
    
    //    func getMultipleChoiceQuestion() {
    //        guard let url = URL(string: "https://backup-quiz-server.onrender.com/api/questions?category=\(selectedCategory)") else {
    //            print("QUIZ ERROR OCCURRED")
    //            return
    //        }
    //        
    //        let loader = self.loader()
    //        
    //        URLSession.shared.makeRequest(url: url, expecting: [QuizModelElement].self) { [weak self] result in
    //            switch result {
    //            case .success(let questions):
    //                print(result)
    //                DispatchQueue.main.async {
    //                    self?.displayedQuestionsID = [String]()
    //                    self?.arrAllQuestions = [QuizModelElement]()
    //                    self?.arrAllQuestions = questions
    //                    self?.updateSelectedCategoryQuestionList()
    ////                    self?.startTimer()
    //                }
    //            case .failure(let error):
    //                print(error)
    //                print("playAgain")
    //            }
    //            //             Dismiss the loading indicator when the network request is complete
    //            self?.stopLoader(loader: loader)
    //        }
    //    }
    
    func loadQuestion(questions: [QuizModelElement], type: String) {
        DispatchQueue.main.async {
            self.displayedQuestionsID = [String]()
            self.arrAllQuestions = [QuizModelElement]()
            self.arrAllQuestions = questions
            self.updateSelectedCategoryQuestionList()
            if type == "FOUR" {
                self.startTimer(initialTime: 60)
            } else {
                self.startTimer(initialTime: 240)
            }
            
            
            
        }
    }
    
    func updateCurrentQuestion() {
        print("arrSelectedCategoryQuestion count is \(arrSelectedCategoryQuestion.count)")
        if !arrSelectedCategoryQuestion.isEmpty {
            
            for i in 0..<arrSelectedCategoryQuestion.count {
                let quest = arrSelectedCategoryQuestion[i]
                if !displayedQuestionsID.contains(quest.id) {
                    currentQuestion = quest
                    displayQuestion()
                    break
                }
            }
        } else {
            self.displayNoQuestionAlert()
        }
    }
    
    func displayNoQuestionAlert() {
        self.showAlertwithImage(id: "completed")
    }
    
    func updateSelectedCategoryQuestionList() {
        // Filter questions based on the selected category
        arrSelectedCategoryQuestion = [QuizModelElement]()
        arrSelectedCategoryQuestion = arrAllQuestions.filter { $0.category == self.selectedCategory }
        
        if arrSelectedCategoryQuestion.isEmpty {
            print("No questions found for category: \(self.selectedCategory)")
            displayNoQuestionAlert()
        } else {
            self.updateCurrentQuestion() // Update the UI with the selected question
        }
    }
    
    
    func displayQuestion() {
        DispatchQueue.main.async {
            // Start the timer when the ready for display question
            if let currentQuestion = self.currentQuestion {
                self.displayedQuestionsID.append(currentQuestion.id)
                for i in 0..<self.arrSelectedCategoryQuestion.count {
                    if currentQuestion.id == self.arrSelectedCategoryQuestion[i].id {
                        self.arrSelectedCategoryQuestion.remove(at: i)
                        break
                    }
                }
                
                self.quesBtn.setTitle(currentQuestion.question, for: .normal)
                
                if currentQuestion.answerOptions.count >= 4 {
                    self.btn1.setTitle(currentQuestion.answerOptions[0].answer, for: .normal)
                    self.btn2.setTitle(currentQuestion.answerOptions[1].answer, for: .normal)
                    self.btn3.setTitle(currentQuestion.answerOptions[2].answer, for: .normal)
                    self.btn4.setTitle(currentQuestion.answerOptions[3].answer, for: .normal)
                }
            }
        }
    }
    
    
    func startTimer(initialTime: Int) {
        remainingTime = initialTime
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if remainingTime > 0 {
            remainingTime -= 1
            timerLbl.text = String(remainingTime)
        } else {
            DispatchQueue.main.async {
                self.timer?.invalidate()
                self.timer = nil
                print("Timer invalidated")
                
                self.showAlertwithImage(id: "timeout")
            }
        }
    }
    
    
    func showAlertwithImage(id: String) {
        self.drNameScorelbl.text = " \(self.selectedDoctorName), Your score is \(score) points"
        self.MainAlertView.isHidden = false
        
        // Set the image based on the provided 'id'
        if id == "timeout" {
            AlertImageView.image = UIImage(named: "timeout_1")
        } else if id == "completed" {
            AlertImageView.image = UIImage(named: "QUIZ COMPLETED")
        }
        // Stop the timer if it's running
        self.timer?.invalidate()
        self.timer = nil
        self.submitScore()
        
    }
    
    
    
    //            post api to save tottals points ,categoryname and userid
    //            api = https://quizapi-omsn.onrender.com/api/submit/score
    
    
    func submitScore() {
        //Save Request in UserDefaults
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy" // Adjust the format based on your API's requirements
        let dateString = dateFormatter.string(from: Date())
        
        // Define the JSON data to be sent in the request
        let json: [String: Any] = [
            "totalPoints": score,
            "categoryName": selectedCategory,
            "userId": selectedDoctorID
        ]
        
        let sync = syncDict(totalPoints: score, categoryName: selectedCategory, userId: selectedDoctorID, date: selectedDrDate)
        
        // Call Request
        if Reachability.isConnectedToNetwork() {
            // Define the URL for the API
            let apiUrl = "https://quizapi-omsn.onrender.com/api/v2/submit/score"
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: json)
                
                // Create the URLRequest
                var request = URLRequest(url: URL(string: apiUrl)!)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("application/json", forHTTPHeaderField: "Accept")
                
                request.httpBody = jsonData
                
                // Create a URLSession task for the request
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        print("Error: \(error)")
                        // Handle the error, e.g., show an alert
                    } else if let data = data {
                        // Handle the response data, if needed
                        print("Response data: \(String(data: data, encoding: .utf8) ?? "No data")")
                        //            post api to save tottals points ,categoryname and userid
                        //            api = https://quizapi-omsn.onrender.com/api/submit/score
                    }
                    
                    // Use a Dispatch Queue to navigate to VC6 after 4 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                        self.MainAlertView.isHidden = true
                        
                        // Create an instance of VC6
                        let vc6 = self.storyboard?.instantiateViewController(withIdentifier: "LeaderBoardVC") as! LeaderBoardVC
                        vc6.selectedDoctorID = self.selectedDoctorID
                        vc6.selectedDoctorName = self.selectedDoctorName
                        vc6.selectedCategory = self.selectedCategory
                        vc6.selectedMRID = self.selectedMRID
                        vc6.score = self.score
                        // Pass DateString to VC6
                        vc6.dateString = "Doctor entry play date is \(self.dateString)"
                        print(dateString)
                        
                        // Push VC6 onto the navigation stack
                        self.navigationController?.pushViewController(vc6, animated: true)
                    }
                }
                
                // Execute the task
                task.resume()
            } catch {
                print("Error serializing JSON: \(error)")
                // Handle the error, e.g., show an alert
            }
        } else {
            //Userdefaults for 
            
            //Userdefaults for selectedCategory
            do {
                
                if let savedUserData = UserDefaults.standard.value(forKey: UserDefaultsKeys.syncData.rawValue) {
                    
                    var arrSync = try JSONDecoder().decode(syncModel.self, from: savedUserData as! Data)
                    arrSync.append(sync)
                    if let encodedData = try? JSONEncoder().encode(arrSync) {
                        UserDefaults.standard.set(encodedData, forKey: UserDefaultsKeys.syncData.rawValue)
                        UserDefaults.standard.synchronize()
                    }
                } else {
                    print("No category found in UserDefaults.")
                    let arr : syncModel = [sync]
                    if let encodedData = try? JSONEncoder().encode(arr) {
                        UserDefaults.standard.set(encodedData, forKey: UserDefaultsKeys.syncData.rawValue)
                        UserDefaults.standard.synchronize()
                    }
                    
                    print("category data added in UserDefaults.")
                }
            } catch let decodingError {
                print("Error decoding JSON data for User Categories: \(decodingError)")
            }
            
            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.syncStatus.rawValue)
            UserDefaults.standard.synchronize()
            //             UserDefaults.standard.set(selectedDoctorID, forKey: UserDefaultsKeys.syncuserId.rawValue)
            //             UserDefaults.standard.synchronize()
            //             UserDefaults.standard.set(selectedCategory, forKey: UserDefaultsKeys.synccategoryName.rawValue)
            //             UserDefaults.standard.synchronize()
            //             UserDefaults.standard.set(score, forKey: UserDefaultsKeys.synctotalPoints.rawValue)
            //             UserDefaults.standard.synchronize()
            print("Submit Score data stored Locally")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                self.MainAlertView.isHidden = true
                
                // Create an instance of VC6
                let vc6 = self.storyboard?.instantiateViewController(withIdentifier: "LeaderBoardVC") as! LeaderBoardVC
                vc6.selectedDoctorID = self.selectedDoctorID
                vc6.selectedDoctorName = self.selectedDoctorName
                vc6.selectedCategory = self.selectedCategory
                vc6.selectedMRID = self.selectedMRID
                vc6.score = self.score
                // Push VC6 onto the navigation stack
                self.navigationController?.pushViewController(vc6, animated: true)
            }
            
        }
        //        else {
        //            // Instantiating UIAlertController
        //                let alertController = UIAlertController(
        //                                        title: "Error",
        //                                        message: "Please check your Internet Connection",
        //                                        preferredStyle: .alert)
        //
        //                // Handling OK action
        //                let okAction = UIAlertAction(title: "Try Again", style: .default) { (action:UIAlertAction!) in
        //                    self.submitScore()
        //                }
        //                // Adding action buttons to the alert controller
        //                alertController.addAction(okAction)
        //                // Presenting alert controller
        //                self.present(alertController, animated: true, completion:nil)
        //        }
        
    }
    
    func calculateScore() -> Int {
        // Implement your logic to calculate the score based on user's answers
        // Return the score value
        return score // Replace with your score calculation
    }
    
    
    func displayNextQuestion() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.resetAnswers()
            self.updateCurrentQuestion()
           
            
        }
    }
    
    func resetAnswers() {
        btn1.layer.borderColor = UIColor.white.cgColor
        btn2.layer.borderColor = UIColor.white.cgColor
        btn3.layer.borderColor = UIColor.white.cgColor
        btn4.layer.borderColor = UIColor.white.cgColor
        
        
        // Reset text color to blue
        btn1.setTitleColor(UIColor.black, for: .normal)
        btn2.setTitleColor(UIColor.black, for: .normal)
        btn3.setTitleColor(UIColor.black, for: .normal)
        btn4.setTitleColor(UIColor.black, for: .normal)
    }
    
    func setCorrectAnswerBorderColor(answer: Int) {
        // Implement the logic to set the correct answer button's border color
        // based on the 'answer' parameter.
    }
    
    func highlightCorrectAnswer(index: Int) {
        // Implement the logic to set the correct answer button's border color
        // based on the 'index' parameter.
        switch index {
        case 0:
            btn1.layer.borderColor = UIColor.green.cgColor
        case 1:
            btn2.layer.borderColor = UIColor.green.cgColor
        case 2:
            btn3.layer.borderColor = UIColor.green.cgColor
        case 3:
            btn4.layer.borderColor = UIColor.green.cgColor
        default:
            break
        }
    }
    
    func checkAnswer(button: UIButton, answerIndex: Int) {
        if let currentQuestion = currentQuestion {
            if currentQuestion.answerOptions[answerIndex].isCorrect {
                // Correct answer selected
                button.layer.borderColor = UIColor.green.cgColor
            } else {
                // Wrong answer selected
                button.layer.borderColor = UIColor.red.cgColor
                // Highlight the correct answer with a green border
                if let correctIndex = currentQuestion.answerOptions.firstIndex(where: { $0.isCorrect }) {
                    // Modify the border color of the correct answer button
                    switch correctIndex {
                    case 0: btn1.layer.borderColor = UIColor.green.cgColor
                    case 1: btn2.layer.borderColor = UIColor.green.cgColor
                    case 2: btn3.layer.borderColor = UIColor.green.cgColor
                    case 3: btn4.layer.borderColor = UIColor.green.cgColor
                    default:
                        break
                    }
                }
            }
            // Load the next question
            displayNextQuestion()
        }
    }
    
    @IBAction func onBtnTapped(_ sender: UIButton) {
        // Check if there is a current question
        if let currentQuestion = currentQuestion {
            // Check if the selected answer is correct
            if currentQuestion.answerOptions[sender.tag].isCorrect {
                // Correct answer selected
                // Increase the score by 10
                score += 10
            }

            // Update the score label with the current score
            scoreLbl.text = "Score: \(score)"

            // Disable all buttons to prevent multiple taps
            disableAllButtons()

            // Call the checkAnswer function
            checkAnswer(button: sender, answerIndex: sender.tag)
        }
    }

    func disableAllButtons() {
        for subview in view.subviews {
            if let button = subview as? UIButton, (1...4).contains(button.tag) {
                       button.isEnabled = false
            }
        }
    }

    
}

