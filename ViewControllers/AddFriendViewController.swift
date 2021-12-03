//
//  AddFriendViewController.swift
//  SlamBook
//
//  Created by Mac on 16/10/21.
//

import UIKit

class AddFriendViewController: UIViewController {

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var genderTF: UITextField!
    @IBOutlet weak var contactTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var birthDateTF: UITextField!
    @IBOutlet weak var typeTF: UITextField!
    
    @IBOutlet weak var favDishTf: UITextField!
    @IBOutlet weak var favGameTF: UITextField!
    @IBOutlet weak var dreamTF: UITextField!
    @IBOutlet weak var firstMeetTF: UITextField!
    var friend : Friend?
    var flag : Bool = false
    var userId : String?
    //pickerView Declaration
    var friendPickerView = UIPickerView()
    var genderPickerView = UIPickerView()
    var friendType = ["Best-Friend","ChildHood-Friend","Friend","Temperary-Friend","College-Friend","School-Friend","Other"]
    var genderList = ["Male","Female","other"]
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        if flag == true{
            displayUserFriend()
            nameTF.delegate = self
            dreamTF.delegate = self
            emailTF.delegate = self
            contactTF.delegate = self
            addressTF.delegate = self
            favDishTf.delegate = self
            favGameTF.delegate = self
            genderTF.delegate = self
            typeTF.delegate = self
            firstMeetTF.delegate = self
            birthDateTF.delegate = self
            
        }else{
            displayUserFriend()
            typeTF.inputView = friendPickerView
            genderTF.inputView = genderPickerView
            
            friendPickerView.tag = 1
            genderPickerView.tag = 2
            
            genderTF.delegate = self
            typeTF.delegate = self
            genderPickerView.delegate = self
            genderPickerView.dataSource = self
            friendPickerView.delegate = self
            friendPickerView.dataSource = self
        }
        nameTF.layer.borderWidth = 3.0
        nameTF.layer.borderColor = UIColor.green.cgColor
        dreamTF.layer.borderWidth = 3.0
        dreamTF.layer.borderColor = UIColor.green.cgColor
        emailTF.layer.borderWidth = 3.0
        emailTF.layer.borderColor = UIColor.green.cgColor
        contactTF.layer.borderWidth = 3.0
        contactTF.layer.borderColor = UIColor.green.cgColor
        addressTF.layer.borderWidth = 3.0
        addressTF.layer.borderColor = UIColor.green.cgColor
        favDishTf.layer.borderWidth = 3.0
        favDishTf.layer.borderColor = UIColor.green.cgColor
        favGameTF.layer.borderWidth = 3.0
        favGameTF.layer.borderColor = UIColor.green.cgColor
        genderTF.layer.borderWidth = 3.0
        genderTF.layer.borderColor = UIColor.green.cgColor
        typeTF.layer.borderWidth = 3.0
        typeTF.layer.borderColor = UIColor.green.cgColor
        firstMeetTF.layer.borderWidth = 3.0
        firstMeetTF.layer.borderColor = UIColor.green.cgColor
        birthDateTF.layer.borderWidth = 3.0
        birthDateTF.layer.borderColor = UIColor.green.cgColor
          }
    
    func showAlert(title : String, message : String, navigate: Bool = false){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if navigate {
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (_) in
                self.navigationController?.popViewController(animated: true)
            }))
        }else {
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        }
        present(alert, animated: true, completion: nil)
    }
    
    func displayUserFriend(){
        nameTF.text = friend?.name
        addressTF.text = friend?.address
        genderTF.text = friend?.gender
        emailTF.text = friend?.email
        contactTF.text = friend?.contact
        typeTF.text = friend?.type
        birthDateTF.text = friend?.birthDate
        favDishTf.text = friend?.favDish
        favGameTF.text = friend?.favGame
        dreamTF.text = friend?.dream
        firstMeetTF.text = friend?.firstMeet
        
    }
    @IBAction func addFriendAction(_ sender: Any) {
        guard let friend = getData() else {
            return
        }
        let obj = DBHelper()
        obj.createFriendTable()
        if ((contactTF.text?.isPhonenumber))! {
            if ((emailTF.text?.isValidEmail)!){
                obj.insertValuesFriend(friend: friend) {
                    showAlert(title: "success", message: "Friend added successfully",navigate: true)
                }
            }else{
                self.showAlert(title: "ok", message: "Enter email in well format")
            }
            print("valid phoneNumber")
        }else{
            showAlert(title: "ok", message: "Enter numbers only")
        }
        
     }
    func getData()-> Friend?{
        guard let name = nameTF.text else{
            return nil
        }
        guard let address = addressTF.text else{
            return nil
        }
        guard let gender = genderTF.text else{
            return nil
        }
        guard let contact = contactTF.text else{
            return nil
        }
        guard let email = emailTF.text else{
            return nil
        }
        guard let birthDate = birthDateTF.text else{
            return nil
        }
        guard let type = typeTF.text else{
            return nil
        }
        guard let favDish = favDishTf.text else{
            return nil
        }
        guard let favGame = favGameTF.text else{
            return nil
        }
        guard let dream = dreamTF.text else{
            return nil
        }
        guard let firstMeet = firstMeetTF.text else{
            return nil
        }
        guard let userId = userId else {
            return nil
        }
        
        if name.isEmpty==true||gender.isEmpty==true||address.isEmpty==true||email.isEmpty==true||userId.isEmpty==true||contact.isEmpty==true||birthDate.isEmpty==true||type.isEmpty==true||favDish.isEmpty==true||favGame.isEmpty==true||dream.isEmpty==true||firstMeet.isEmpty==true {
            showAlert(title: "Warning", message: "Fill all fields!!!+")
            return nil
        }else{
            if let _ = Int(contact){
            let friend = Friend(name: name, address: address, gender: gender, contact: contact, email: email, birthDate: birthDate, type: type, favDish: favDish, favGame: favGame, dream: dream, firstMeet: firstMeet, userId:userId )
            return friend
            }else{
                showAlert(title: "Warning", message: "Contact must be numbers only")
                return nil
            }
        }
    }
}
extension AddFriendViewController: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return friendType.count
        case 2:
            return genderList.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return friendType[row]
        case 2:
            return genderList[row]
        default:
            return "invalid data"
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            typeTF.text = friendType[row]
            typeTF.resignFirstResponder()
        case 2:
            genderTF.text = genderList[row]
            genderTF.resignFirstResponder()
        default:
            return
        }
    }
}
extension String{
    var isPhonenumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count && self.count == 10
            }else{
                return false
            }
        }catch {
            return false
            }
    }
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{3}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}
extension AddFriendViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        false
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.openDatePicker()
    }
}
extension AddFriendViewController{
    func openDatePicker(){
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerHandler(datePicker:)), for: .valueChanged)
        birthDateTF.inputView = datePicker
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        let cancelBtn = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(cancelcBtnClick))
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donecBtnClick))
        let flexibleBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelBtn,flexibleBtn,doneBtn], animated: false)
        birthDateTF.inputAccessoryView = toolbar
    }
    @objc func cancelcBtnClick(){
        birthDateTF.resignFirstResponder()
    }
    @objc func donecBtnClick(){
        if let datePicker = birthDateTF.inputView as? UIDatePicker{
            let dateFormat = DateFormatter()
            dateFormat.dateStyle = .medium
            birthDateTF.text = dateFormat.string(from: datePicker.date)
            print(datePicker.date)
            
        }
        birthDateTF.resignFirstResponder()
    }
    @objc func datePickerHandler(datePicker : UIDatePicker){
        
    }
}

