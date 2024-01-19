//
//  VC6.swift
//  somprazApp
//
//  Created by digiLATERAL on 18/10/23.
//

import UIKit

class LeaderBoardVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var lbImgView: UIImageView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var boardIV: UIImageView!
    @IBOutlet weak var lbLabel: UILabel!
    @IBOutlet weak var no3Lbl: UILabel!
    @IBOutlet weak var no2Lbl: UILabel!
    @IBOutlet weak var no1Lbl: UILabel!
    @IBOutlet weak var PlayedDocLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var lastSyncDateLbl: UILabel!
    
    
    var selectedDoctorName = ""
    var selectedDoctorID = ""
    var leaderboard = [CategoryLeaderboard]()
    var filteredLeaderboard = [CategoryLeaderboard]()
    var selectedCategory: String = "selectedCategory"
    var score = 0
    var selectedMRID = ""
    var selectedDoctorState = ""
    var dateString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Load last sync date from UserDefaults and update the label
        if let lastSyncDate = UserDefaults.standard.value(forKey: UserDefaultsKeys.lastSyncDate.rawValue) as? Date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy HH:mm:ss"
            let formattedDate = dateFormatter.string(from: lastSyncDate)
            lastSyncDateLbl.text = "Last Sync Date : \(formattedDate)"
        } else {
            lastSyncDateLbl.text = "Last Sync: Never"
        }
        
        do {
            // Assuming you have some data in UserDefaults named 'savedUserData'
            
            if let savedUserData = UserDefaults.standard.value(forKey: UserDefaultsKeys.selectedDoctorState.rawValue) {
                let state = try JSONDecoder().decode(String.self, from: savedUserData as! Data)
                print(state)
                selectedDoctorState = state
            } else {
                print("No data found in UserDefaults.")
            }
        } catch let decodingError {
            print("Error decoding JSON data for User Categories: \(decodingError)")
        }
        
        
        boardIV.layer.borderWidth = 2
        boardIV.layer.cornerRadius = 20
        boardIV.layer.borderColor =  UIColor.white.cgColor
        lbLabel.layer.borderWidth = 2
        //        lbLabel.layer.cornerRadius = 20
        lbLabel.layer.borderColor =  UIColor.blue.cgColor
        lbLabel.layer.masksToBounds = true
        PlayedDocLbl.layer.borderWidth = 2
        PlayedDocLbl.layer.borderColor = UIColor.lightGray.cgColor
        PlayedDocLbl.layer.masksToBounds = true
        lastSyncDateLbl.layer.borderWidth = 2
        lastSyncDateLbl.layer.borderColor = UIColor.lightGray.cgColor
        lastSyncDateLbl.layer.masksToBounds = true
        
        
        if Reachability.isConnectedToNetwork() {
            getdoctorsCategory()
        } else {
            
            DispatchQueue.main.async {
                do {
                    // Assuming you have some data in UserDefaults named 'savedUserData'
                    
                    if let savedUserData = UserDefaults.standard.value(forKey: "\(self.selectedCategory)") {
                        
                        self.leaderboard = [CategoryLeaderboard]()
                        let value = try JSONDecoder().decode([String: [CategoryLeaderboard]].self, from: savedUserData as! Data)
                        if let tempArray = value[self.selectedCategory] {
                            self.leaderboard = tempArray
                            self.displayLeaderboard()
                        }
                        
                    } else {
                        print("Error: No data found in UserDefaults.")
                    }
                } catch let decodingError {
                    print("Error decoding JSON data for User Categories: \(decodingError)")
                }
                
            }
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        print(selectedCategory)
        print("MRID :", selectedMRID)
        print("NewScore: \(score)")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Reachability.isConnectedToNetwork() {
            self.updateLastSyncDate()
        }
    }
    
    
    @IBAction func homBtnTapped(_ sender: UIButton) {
        navigationController?.popToViewController(ofClass: HomeVC.self)
    }
    
    func getdoctorsCategory() {
        if let categoryName = selectedCategory.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
           let mrId = selectedMRID.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
           let url = URL(string: "https://quizapi-omsn.onrender.com/api/get/leaderboard/\(categoryName)/\(mrId)") {
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let leaderboardData = try JSONDecoder().decode(LeaderBoardModel.self, from: data)
                        
                        DispatchQueue.main.async {
                            self.leaderboard = leaderboardData.categoryLeaderboard
                            
                            self.displayLeaderboard()
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                } else if let error = error {
                    print("Error fetching data: \(error)")
                }
            }.resume()
        }
    }
    
    func displayLeaderboard() {
        
        //           let mrId = selectedMRID.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
        //            self.leaderboard = leaderboardData.categoryLeaderboard
        
        // Sort the leaderboard in descending order based on the score
        self.leaderboard.sort { $0.score ?? 0 > $1.score ?? 0  }
        
        // Filter the leaderboard to include only those with a score greater than -1
        self.filteredLeaderboard = self.leaderboard.filter { $0.score ?? 0 > -1 }
        
        self.lbLabel.text = "Category: " + selectedCategory
        print("Score: \(self.score)")
        self.PlayedDocLbl.text = " \(self.selectedDoctorName)  \(selectedDoctorState), Score: \(self.score) points"
        
        
        
        // Update the top 3 labels
        if self.filteredLeaderboard.count >= 3 {
            if let name = self.filteredLeaderboard[0].doctorName,
               let score = self.filteredLeaderboard[0].score {
                self.no1Lbl.text = " \(name) \n \(score) points"
            }
            
            if let name = self.filteredLeaderboard[1].doctorName,
               let score = self.filteredLeaderboard[1].score {
                self.no2Lbl.text = " \(name) \n \(score) points"
            }
            
            if let name = self.filteredLeaderboard[2].doctorName,
               let score = self.filteredLeaderboard[2].score {
                self.no3Lbl.text = " \(name) \n \(score) points"
            }
            
        } else {
            // Handle the case when there are not enough entries in the leaderboard
            self.no1Lbl.text = " -"
            self.no2Lbl.text = " -"
            self.no3Lbl.text = " -"
        }
        print("Data loaded and table view reloaded. Count: \(self.leaderboard.count)")
        self.tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = filteredLeaderboard.count
        return max(count - 4, 0)
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorTVC", for: indexPath) as! DoctorTVC
        let index = indexPath.row + 4
        let doctorInfo = filteredLeaderboard[index]
        let name = doctorInfo.doctorName ?? ""
        let state = doctorInfo.state ?? ""
        
        cell.lblName.text = "\(index).     Dr. \(name)  \(state)"
        /*  \(doctorInfo.score) points"*/
        if let score = doctorInfo.score {
            cell.scoreLbl.text = "\(score) points"
        }
        
        return cell
    }
}


func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let spacingView = UIView()
    spacingView.backgroundColor = .clear
    return spacingView
}

func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 10 // Adjust this value as needed
}



