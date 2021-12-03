//
//  DBManager.swift
//  SlamBook
//
//  Created by Mac on 20/10/21.
//

import Foundation
import SQLite3

class DBHelper {
    var db : OpaquePointer?
    init() {
        db = createAndOpen()
    }
    private func createAndOpen() -> OpaquePointer? {
        var db : OpaquePointer?
        do {
            let documentDir = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("SlamBook.sqlite")
            if sqlite3_open(documentDir.path, &db) == SQLITE_OK{
                print("open\(documentDir.path)")
                print("database create and open successfully...")
                return db
            }else{
                print("database allready exit")
                return db
            }
        }catch{
            print(error.localizedDescription)
        }
    return nil
    }
    
    func createUserTable(){
        var createStatement : OpaquePointer?
        let createTableQuery = "CREATE TABLE IF NOT EXISTS User(name TEXT,gender TEXT,address TEXT,email TEXT,userId TEXT PRIMARY KEY,password TEXT)"
        if sqlite3_prepare_v2(db, createTableQuery, -1, &createStatement, nil) == SQLITE_OK{
            if sqlite3_step(createStatement) == SQLITE_DONE{
                print("User table create successfully...")
            }else{
                print("unable to create user table...")
            }
        }else{
            print("unable to prepare create atble statement")
        }
    }
    
    func createFriendTable(){
        var createStatement : OpaquePointer?
        let createTableQuery = "CREATE TABLE IF NOT EXISTS Friend(name TEXT,address TEXT,gender TEXT,contact TEXT,email TEXT,birthDate TEXT,type TEXT,favDish TEXT,favGame TEXT,dream TEXT,firstMeet TEXT,userId TEXT references User(userId) ON DELETE CASCADE ON UPDATE SET NULL)"
        if sqlite3_prepare_v2(db, createTableQuery, -1, &createStatement, nil) == SQLITE_OK{
            if sqlite3_step(createStatement) == SQLITE_DONE{
                print("User table create successfully...")
            }else{
                print("unable to create user table...")
            }
        }else{
            print("unable to prepare create atble statement")
        }
    }
    
    
    func insertValuesUser(user : User){
        var insertStatement : OpaquePointer?
        let insertQuery = "INSERT INTO User(name,gender,address,email,userId,password) VALUES(?,?,?,?,?,?)"
        if sqlite3_prepare_v2(db, insertQuery, -1, &insertStatement, nil) == SQLITE_OK{
            
            let nameNS  = user.name as NSString
            let nameText = nameNS.utf8String
            sqlite3_bind_text(insertStatement, 1, nameText, -1, nil)
            
            let genderNS  = user.gender as NSString
            let genderText = genderNS.utf8String
            sqlite3_bind_text(insertStatement, 2, genderText, -1, nil)
            
            let addressNs  = user.address as NSString
            let addressText = addressNs.utf8String
            sqlite3_bind_text(insertStatement, 3, addressText, -1, nil)
            
            let emailNS  = user.email as NSString
            let emailText = emailNS.utf8String
            sqlite3_bind_text(insertStatement, 4, emailText, -1, nil)
       
            let useridNS  = user.userId as NSString
            let useridText = useridNS.utf8String
            sqlite3_bind_text(insertStatement, 5, useridText, -1, nil)
        
            let passwordNS  = user.password as NSString
            let passwordText = passwordNS.utf8String
            sqlite3_bind_text(insertStatement, 6, passwordText, -1, nil)
        
          if sqlite3_step(insertStatement) == SQLITE_DONE{
                print("user added succ.......")
          }else{
            print("unable to add")
          }
        }else{
            print("unable to prepare query!!!")
        }
        sqlite3_finalize(insertStatement)
    }
    
    typealias success = ()->()
    func insertValuesFriend(friend : Friend,successClosure:success){
        var insertStatement : OpaquePointer?
        let insertQuery = "INSERT INTO Friend(name,address,gender,contact,email,birthDate,type,favDish,favGame,dream,firstMeet,userId) VALUES(?,?,?,?,?,?,?,?,?,?,?,?)"
        if sqlite3_prepare_v2(db, insertQuery, -1, &insertStatement, nil) == SQLITE_OK{
            
            let nameNS  = friend.name as NSString
            let nameText = nameNS.utf8String
            sqlite3_bind_text(insertStatement, 1, nameText, -1, nil)
            
            let addressNs  = friend.address as NSString
            let addressText = addressNs.utf8String
            sqlite3_bind_text(insertStatement, 2, addressText, -1, nil)
            
            let genderNS  = friend.gender as NSString
            let genderText = genderNS.utf8String
            sqlite3_bind_text(insertStatement, 3, genderText, -1, nil)
            
            let contactNS  = friend.contact as NSString
            let contactText = contactNS.utf8String
            sqlite3_bind_text(insertStatement, 4, contactText, -1, nil)
            
            
            let emailNS  = friend.email as NSString
            let emailText = emailNS.utf8String
            sqlite3_bind_text(insertStatement, 5, emailText, -1, nil)
            
            let birthDateNS  = friend.birthDate as NSString
            let birthDateText = birthDateNS.utf8String
            sqlite3_bind_text(insertStatement, 6, birthDateText, -1, nil)
            
            let typeNS  = friend.type as NSString
            let typeText = typeNS.utf8String
            sqlite3_bind_text(insertStatement, 7, typeText, -1, nil)
            
            let favDishNS  = friend.favDish as NSString
            let favDishText = favDishNS.utf8String
            sqlite3_bind_text(insertStatement, 8, favDishText, -1, nil)
       
            let favGameNS  = friend.favGame as NSString
            let favGameText = favGameNS.utf8String
            sqlite3_bind_text(insertStatement, 9, favGameText, -1, nil)
            
            let dreamNS  = friend.dream as NSString
            let dreamText = dreamNS.utf8String
            sqlite3_bind_text(insertStatement, 10, dreamText, -1, nil)
        
            let firstMeetNS  = friend.firstMeet as NSString
            let firstMeetText = firstMeetNS.utf8String
            sqlite3_bind_text(insertStatement, 11, firstMeetText, -1, nil)
            
            let userIdNS  = friend.userId as NSString
            let userIDText = userIdNS.utf8String
            sqlite3_bind_text(insertStatement, 12, userIDText, -1, nil)
        
          if sqlite3_step(insertStatement) == SQLITE_DONE{
               successClosure()
          }else{
            print("unable to add")
          }
        }else{
            print("unable to prepare query!!!")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func userFriend(userId : String)->[Friend]?{
        var friends = [Friend]()
        var readStatement : OpaquePointer?
        let query = "SELECT * FROM Friend WHERE userId = '\(userId)'"
        if sqlite3_prepare_v2(db, query, -1, &readStatement, nil) == SQLITE_OK{
            while sqlite3_step(readStatement) == SQLITE_ROW{
                guard let name_CStr = sqlite3_column_text(readStatement, 0) else {
                    print("error while getting name from db!!")
                    continue
                }
                let name = String(cString: name_CStr)
                
               
                guard  let address_CStr = sqlite3_column_text(readStatement, 1)else{
                    print("error while getting address from db!")
                    continue
                }
                let address = String(cString: address_CStr)
               
                guard  let gender_CStr = sqlite3_column_text(readStatement, 2)else{
                    print("error while getting gender from db!")
                    continue
                }
                let gender = String(cString: gender_CStr)
                
                guard  let contact_CStr = sqlite3_column_text(readStatement, 3)else{
                    print("error while getting contact from db!")
                    continue
                }
                let contact = String(cString: contact_CStr)
                
                guard  let email_CStr = sqlite3_column_text(readStatement, 4)else{
                    print("error while getting email from db!")
                    continue
                }
                let email = String(cString: email_CStr)
                
                guard  let birthDate_CStr = sqlite3_column_text(readStatement, 5)else{
                    print("error while getting birthDate from db!")
                    continue
                }
                let birthDate = String(cString: birthDate_CStr)
                
                guard  let type_CStr = sqlite3_column_text(readStatement, 6)else{
                    print("error while getting type from db!")
                    continue
                }
                let type = String(cString: type_CStr)
                
                guard  let favDish_CStr = sqlite3_column_text(readStatement, 7)else{
                    print("error while getting favDish from db!")
                    continue
                }
                let favDish = String(cString: favDish_CStr)
                
                guard  let favGame_CStr = sqlite3_column_text(readStatement, 8)else{
                    print("error while getting favGame from db!")
                    continue
                }
                let favGame = String(cString: favGame_CStr)
                
                guard  let dream_CStr = sqlite3_column_text(readStatement, 9)else{
                    print("error while getting dream from db!")
                    continue
                }
                let dream = String(cString: dream_CStr)
                
                guard  let firstMeet_CStr = sqlite3_column_text(readStatement, 10)else{
                    print("error while getting firstMeet from db!")
                    continue
                }
                let firstMeet = String(cString: firstMeet_CStr)
                
                guard  let userId_CStr = sqlite3_column_text(readStatement, 11)else{
                    print("error while getting userId from db!")
                    continue
                }
                let userId = String(cString: userId_CStr)
                let friend = Friend(name: name, address: address, gender: gender, contact: contact, email: email, birthDate: birthDate, type: type, favDish: favDish, favGame: favGame, dream: dream, firstMeet: firstMeet, userId: userId )
                friends.append(friend)
            }
            sqlite3_finalize(readStatement)
            return friends
        }
        return nil
    }
    func displayUsers() -> [User]? {
        var selectStatement : OpaquePointer?
        let selectQuery = "SELECT * FROM User"
        var users = [User]()
        if sqlite3_prepare_v2(db, selectQuery, -1, &selectStatement, nil) == SQLITE_OK{
            while sqlite3_step(selectStatement) == SQLITE_ROW {
                
                guard let name_CStr = sqlite3_column_text(selectStatement, 0) else {
                    print("error while getting name from db!!")
                    continue
                }
                let name = String(cString: name_CStr)
                
                guard  let gender_CStr = sqlite3_column_text(selectStatement, 1)else{
                    print("error while getting gender from db!")
                    continue
                }
                let gender = String(cString: gender_CStr)
                
                guard  let address_CStr = sqlite3_column_text(selectStatement, 2)else{
                    print("error while getting address from db!")
                    continue
                }
                let address = String(cString: address_CStr)
                
                guard  let email_CStr = sqlite3_column_text(selectStatement, 3)else{
                    print("error while getting gender from db!")
                    continue
                }
                let email = String(cString: email_CStr)
                
                guard  let userId_CStr = sqlite3_column_text(selectStatement, 4)else{
                    print("error while getting userId from db!")
                    continue
                }
                let userId = String(cString: userId_CStr)
                
                guard  let password_CStr = sqlite3_column_text(selectStatement, 5)else{
                    print("error while getting password from db!")
                    continue
                }
                let password = String(cString: password_CStr)
                let user = User(name: name, gender: gender, address: address, email: email, userId: userId, password: password)
                users.append(user)
            }
            sqlite3_finalize(selectStatement)
            return users
        }else{
            print("unable to prepare statement")
        }
        return nil
    }
    
    func updateUserProfile(userId : String,user:User){
        var updateStatement : OpaquePointer?
        //(name,gender,address,email,userId,password)
        let query = "UPDATE User SET name = ?, gender = ?, address = ?,email = ?,userId = ?, password = ? WHERE userId = '\(userId)'"
        if sqlite3_prepare_v2(db, query, -1, &updateStatement, nil) == SQLITE_OK{
            let nameNS  = user.name as NSString
            let nameText = nameNS.utf8String
            sqlite3_bind_text(updateStatement, 1, nameText, -1, nil)
            
            let genderNS  = user.gender as NSString
            let genderText = genderNS.utf8String
            sqlite3_bind_text(updateStatement, 2, genderText, -1, nil)
            
            let addressNs  = user.address as NSString
            let addressText = addressNs.utf8String
            sqlite3_bind_text(updateStatement, 3, addressText, -1, nil)
            
            let emailNS  = user.email as NSString
            let emailText = emailNS.utf8String
            sqlite3_bind_text(updateStatement, 4, emailText, -1, nil)
       
            let useridNS  = user.userId as NSString
            let useridText = useridNS.utf8String
            sqlite3_bind_text(updateStatement, 5, useridText, -1, nil)
        
            let passwordNS  = user.password as NSString
            let passwordText = passwordNS.utf8String
            sqlite3_bind_text(updateStatement, 6, passwordText, -1, nil)
        
            if sqlite3_step(updateStatement) == SQLITE_DONE{
                sqlite3_finalize(updateStatement)
                  print("user updated succ.......")
            }else{
              print("unable to update")
            }
            
        }
    }
    
    func displayFriend() -> [Friend]? {
        var selectStatement : OpaquePointer?
        let selectQuery = "SELECT * FROM Friend"
        var friends = [Friend]()
        
        if sqlite3_prepare_v2(db, selectQuery, -1, &selectStatement, nil) == SQLITE_OK{
            while sqlite3_step(selectStatement) == SQLITE_ROW {
                
                guard let name_CStr = sqlite3_column_text(selectStatement, 0) else {
                    print("error while getting name from db!!")
                    continue
                }
                let name = String(cString: name_CStr)
                guard  let address_CStr = sqlite3_column_text(selectStatement, 1)else{
                    print("error while getting address from db!")
                    continue
                }
                let address = String(cString: address_CStr)
               
                guard  let gender_CStr = sqlite3_column_text(selectStatement, 2)else{
                    print("error while getting gender from db!")
                    continue
                }
                let gender = String(cString: gender_CStr)
                
                guard  let contact_CStr = sqlite3_column_text(selectStatement, 3)else{
                    print("error while getting contact from db!")
                    continue
                }
                let contact = String(cString: contact_CStr)
                
                guard  let email_CStr = sqlite3_column_text(selectStatement, 4)else{
                    print("error while getting email from db!")
                    continue
                }
                let email = String(cString: email_CStr)
                
                guard  let birthDate_CStr = sqlite3_column_text(selectStatement, 5)else{
                    print("error while getting birthDate from db!")
                    continue
                }
                let birthDate = String(cString: birthDate_CStr)
                
                guard  let type_CStr = sqlite3_column_text(selectStatement, 6)else{
                    print("error while getting type from db!")
                    continue
                }
                let type = String(cString: type_CStr)
                
                guard  let favDish_CStr = sqlite3_column_text(selectStatement, 7)else{
                    print("error while getting favDish from db!")
                    continue
                }
                let favDish = String(cString: favDish_CStr)
                guard  let favGame_CStr = sqlite3_column_text(selectStatement, 8)else{
                    print("error while getting favGame from db!")
                    continue
                }
                let favGame = String(cString: favGame_CStr)
                guard  let dream_CStr = sqlite3_column_text(selectStatement, 9)else{
                    print("error while getting dream from db!")
                    continue
                }
                let dream = String(cString: dream_CStr)
                guard  let firstMeet_CStr = sqlite3_column_text(selectStatement, 10)else{
                    print("error while getting firstMeet from db!")
                    continue
                }
                let firstMeet = String(cString: firstMeet_CStr)
                
                guard  let userId_CStr = sqlite3_column_text(selectStatement, 11)else{
                    print("error while getting userId from db!")
                    continue
                }
                let userId = String(cString: userId_CStr)
                let friend = Friend(name: name, address: address, gender: gender, contact: contact, email: email, birthDate: birthDate, type: type, favDish: favDish, favGame: favGame, dream: dream, firstMeet: firstMeet, userId: userId )
                friends.append(friend)
            }
            sqlite3_finalize(selectStatement)
            return friends
        }else{
            print("unable to prepare statement")
        }
        return nil
    }
    
    func searchFriend(searchedText:String, userId: String) -> [Friend]? {
        var searchStatement: OpaquePointer?
        var friends = [Friend]()
        let query = "SELECT * FROM Friend WHERE userId = '\(userId)' AND name LIKE '\(searchedText)%'"
        
        if sqlite3_prepare_v2(db, query, -1, &searchStatement, nil) == SQLITE_OK{
            while sqlite3_step(searchStatement) == SQLITE_ROW {
                
                guard let name_CStr = sqlite3_column_text(searchStatement, 0) else {
                    print("error while getting name from db!!")
                    continue
                }
                let name = String(cString: name_CStr)
                guard  let address_CStr = sqlite3_column_text(searchStatement, 1)else{
                    print("error while getting address from db!")
                    continue
                }
                let address = String(cString: address_CStr)
               
                guard  let gender_CStr = sqlite3_column_text(searchStatement, 2)else{
                    print("error while getting gender from db!")
                    continue
                }
                let gender = String(cString: gender_CStr)
                
                guard  let contact_CStr = sqlite3_column_text(searchStatement, 3)else{
                    print("error while getting contact from db!")
                    continue
                }
                let contact = String(cString: contact_CStr)
                
                guard  let email_CStr = sqlite3_column_text(searchStatement, 4)else{
                    print("error while getting email from db!")
                    continue
                }
                let email = String(cString: email_CStr)
                
                guard  let birthDate_CStr = sqlite3_column_text(searchStatement, 5)else{
                    print("error while getting birthDate from db!")
                    continue
                }
                let birthDate = String(cString: birthDate_CStr)
                
                guard  let type_CStr = sqlite3_column_text(searchStatement, 6)else{
                    print("error while getting type from db!")
                    continue
                }
                let type = String(cString: type_CStr)
                
                guard  let favDish_CStr = sqlite3_column_text(searchStatement, 7)else{
                    print("error while getting favDish from db!")
                    continue
                }
                let favDish = String(cString: favDish_CStr)
                guard  let favGame_CStr = sqlite3_column_text(searchStatement, 8)else{
                    print("error while getting favGame from db!")
                    continue
                }
                let favGame = String(cString: favGame_CStr)
                guard  let dream_CStr = sqlite3_column_text(searchStatement, 9)else{
                    print("error while getting dream from db!")
                    continue
                }
                let dream = String(cString: dream_CStr)
                guard  let firstMeet_CStr = sqlite3_column_text(searchStatement, 10)else{
                    print("error while getting firstMeet from db!")
                    continue
                }
                let firstMeet = String(cString: firstMeet_CStr)
                
                guard  let userId_CStr = sqlite3_column_text(searchStatement, 11)else{
                    print("error while getting userId from db!")
                    continue
                }
                let userId = String(cString: userId_CStr)
                let friend = Friend(name: name, address: address, gender: gender, contact: contact, email: email, birthDate: birthDate, type: type, favDish: favDish, favGame: favGame, dream: dream, firstMeet: firstMeet, userId: userId )
                friends.append(friend)
            }
            sqlite3_finalize(searchStatement)
            return friends
        }else{
            print("unable to prepare statement")
        }
        return nil
    }
}
