//
//  SignUpViewController.swift
//  SlamBook
//
//  Created by Mac on 16/10/21.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var genderTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
   
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var userIdTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmpassTF: UITextField!
    
    @IBOutlet weak var labelOutlet: UILabel!
    @IBOutlet weak var signUpOutlet: UIButton!
    @IBOutlet weak var signInOutlet: UIButton!
    
    var genderPickerView = UIPickerView()
    var genderList = ["Male","Female","other"]
    var isFromEditProfile = false
    var userFromHome : String? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFromEditProfile {
            labelOutlet.isHidden = true
            signUpOutlet.setTitle("update", for: .normal)
            signInOutlet.isHidden = true
            genderTF.delegate = self
            navigationController?.isNavigationBarHidden = false
            navigationItem.hidesBackButton = true
            let newBackBtn = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backBtnAction))
            self.navigationItem.leftBarButtonItem = newBackBtn
        }
        genderTF.inputView = genderPickerView
        genderPickerView.tag = 1
        genderTF.delegate = self
        genderPickerView.dataSource = self
        genderPickerView.delegate = self
        nameTF.layer.borderWidth = 3.0
        nameTF.layer.borderColor = UIColor.blue.cgColor
        genderTF.layer.borderWidth = 3.0
        genderTF.layer.borderColor = UIColor.blue.cgColor
        emailTF.layer.borderWidth = 3.0
        emailTF.layer.borderColor = UIColor.blue.cgColor
        addressTF.layer.borderWidth = 3.0
        addressTF.layer.borderColor = UIColor.blue.cgColor
        userIdTF.layer.borderWidth = 3.0
        userIdTF.layer.borderColor = UIColor.blue.cgColor
        passwordTF.layer.borderWidth = 3.0
        passwordTF.layer.borderColor = UIColor.blue.cgColor
        confirmpassTF.layer.borderWidth = 3.0
        confirmpassTF.layer.borderColor = UIColor.blue.cgColor
    }
    
    @objc func backBtnAction(){
        navigationController?.isNavigationBarHidden = true
        navigationController?.popViewController(animated: true)
    }
    
    func showAlert(title : String, message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
//MARK:getData
    func getData()-> User?{
        guard let name = nameTF.text else {
            return nil
        }
        guard let gender = genderTF.text  else {
            return nil
        }
        guard let address = addressTF.text else {
            return nil
        }
        guard let email = emailTF.text else {
            return nil
        }
        guard let userId = userIdTF.text else {
            return nil
        }
        guard let password = passwordTF.text else {
            return nil
        }
        guard let confirmPassword = confirmpassTF.text else {
            return nil
        }
        if name.isEmpty==true||gender.isEmpty==true||address.isEmpty==true||email.isEmpty==true||userId.isEmpty==true||password.isEmpty==true {
            showAlert(title: "Warning", message: "Fill all fields!!!+")
            return nil
        }else{ 
            if password == confirmPassword{
                 let user = User(name: name, gender: gender, address: address, email: email, userId: userId, password: password)
                 return user
             }else{
                showAlert(title: "Warning", message: "Missmatch Password at both place")
                return nil
            }
        }
    }
    @IBAction func signInBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
            }
    
    @IBAction func signUpBtnAction(_ sender: Any) {
        if isFromEditProfile{
            if let homeViewControllerObj = storyboard?.instantiateViewController(identifier: "HomeViewController")as? HomeViewController{
                guard let userDta = getData() else{
                    return
                }
                if ((emailTF.text?.isValidEmail)!){
                    print("valid email")
                }else{
                   showAlert(title: "ok", message: "Enter Valid Email")
                }
                if let userFromHome = userFromHome{
                    let dbheplperObj = DBHelper()
                    homeViewControllerObj.user = userDta
                    dbheplperObj.updateUserProfile(userId: userFromHome, user: userDta)
                    navigationController?.pushViewController(homeViewControllerObj, animated: true)
                }else{
                    print("userId not found")
                }
            }
            
        }else{
            if let homeViewControllerObj = storyboard?.instantiateViewController(identifier: "HomeViewController")as? HomeViewController{
                guard let user = getData() else{
                    return
                }
                if ((emailTF.text?.isValidEmail)!){
                    print("valid email")
                }else{
                   showAlert(title: "ok", message: "Enter Valid Email")
                }
                homeViewControllerObj.user = user
                let dbheplperObj = DBHelper()
                dbheplperObj.createUserTable()
                dbheplperObj.insertValuesUser(user: user)
                navigationController?.pushViewController(homeViewControllerObj, animated: true)
            }
        }
    }
}
extension SignUpViewController: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return genderList.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return genderList[row]
        default:
            return "invalid data"
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            genderTF.text = genderList[row]
            genderTF.resignFirstResponder()
        default:
            return
        }
    }
}
extension SignUpViewController{

    var isValidEmail1: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{3}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}

