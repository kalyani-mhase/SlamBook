//
//  LoginViewController.swift
//  SlamBook
//
//  Created by Mac on 16/10/21.
//
import UIKit
class LoginViewController: UIViewController {

    @IBOutlet weak var userIdTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userIdTF.layer.borderWidth = 3.0
        userIdTF.layer.borderColor = UIColor.blue.cgColor
        passwordTF.layer.borderWidth = 3.0
        passwordTF.layer.borderColor = UIColor.blue.cgColor
    }
    
    func showAlert(title : String, message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func validateUser()-> User?{
        guard let userId = userIdTF.text else {
            return nil
        }
        guard let password = passwordTF.text else {
            return nil
        }
        let dbhelperObj = DBHelper()
        guard let users = dbhelperObj.displayUsers()else{
            return nil
        }
        var userIdNotFound = false
        var passNotFound  = false
        for user in users{
            if user.userId == userId {
                if user.password == password{
                    userIdNotFound = false
                    passNotFound = false
                    return user
                }else{
                    passNotFound = true
                
                }
            } else {
               userIdNotFound = true
            }
            
        }
        if userIdNotFound{
            showAlert(title: "warning", message: "Invalid UserUd")
        }
        if passNotFound{
            showAlert(title: "warning", message: "Invalid Password")
        }
        return nil
        
    }
    
    @IBAction func loginBtnAction(_ sender: Any) {
        if let homeViewControllerObj = storyboard?.instantiateViewController(identifier: "HomeViewController")as? HomeViewController{
            if let user = validateUser(){
                homeViewControllerObj.user = user
                navigationController?.pushViewController(homeViewControllerObj, animated: true)
            }else{
                print("nill value obtain from valiadte user")
            }
        }
    }
    
    @IBAction func signUpBtnAction(_ sender: Any) {
        if let signUpViewControllerObj = storyboard?.instantiateViewController(identifier: "SignUpViewController")as? SignUpViewController{
            navigationController?.pushViewController(signUpViewControllerObj, animated: true)
        }
    }
}
