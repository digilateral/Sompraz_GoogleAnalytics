//
//  UserDefaults+Extension.swift
//  somprazApp
//
//  Created by digiLATERAL on 05/12/2023.
//

import Foundation

//
enum UserDefaultsKeys : String {
    case doctorList
    case MRId
    case selectDoctorId
    case categories
    case PlayedCategoryDoctors
    case selectedCategory
    case selectedQuestionType
    case syncScore
    case synctotalPoints
    case synccategoryName
    case syncuserId
    case lastSyncDate
    case syncData
    case date
    
    case syncStatus
    case selectedDoctorState
    
    case multipleQuestionsArray
    case FourQuestionsArray
    case FormattedCategoriesArray
    case ActiveCategoriesArray
    case LeaderboardArray
}

extension UserDefaults {
    // MARK: - Setters
    
    /// Set a value for a given key in UserDefaults.
    /// - Parameters:
    ///   - value: The value to be set.
    ///   - key: The key under which to store the value.
    class func set<T>(_ value: T, forKey key: String) {
        standard.set(value, forKey: key)
        standard.synchronize()
    }
    
    // MARK: - Getters
    
    /// Get a value for a given key from UserDefaults.
    /// - Parameters:
    ///   - key: The key for which to get the value.
    ///   - defaultValue: The default value to be returned if the key is not found.
    /// - Returns: The value associated with the key, or the default value if the key is not found.
    class func value<T>(forKey key: String, defaultValue: T) -> T {
        return standard.object(forKey: key) as? T ?? defaultValue
    }
    
    /// Get a bool value for a given key from UserDefaults.
    /// - Parameters:
    ///   - key: The key for which to get the bool value.
    ///   - defaultValue: The default bool value to be returned if the key is not found.
    /// - Returns: The bool value associated with the key, or the default value if the key is not found.
    class func bool(forKey key: String, defaultValue: Bool) -> Bool {
        return standard.bool(forKey: key)
    }
    
    /// Get an integer value for a given key from UserDefaults.
    /// - Parameters:
    ///   - key: The key for which to get the integer value.
    ///   - defaultValue: The default integer value to be returned if the key is not found.
    /// - Returns: The integer value associated with the key, or the default value if the key is not found.
    class func integer(forKey key: String, defaultValue: Int) -> Int {
        return standard.integer(forKey: key)
    }
    
    // Add more getters for other types as needed
    
    // MARK: - Remove
    
    /// Remove the value for a given key from UserDefaults.
    /// - Parameter key: The key for which to remove the value.
    class func removeValue(forKey key: String) {
        standard.removeObject(forKey: key)
    }
}


// Example for usage
// Set a value
//UserDefaults.set("John Doe", forKey: "username")
//
//// Get a value
//let username = UserDefaults.value(forKey: "username", defaultValue: "Guest")
//print("Username: \(username)")
//
//// Remove a value
//UserDefaults.removeValue(forKey: "username")
