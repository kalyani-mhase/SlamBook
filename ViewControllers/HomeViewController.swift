//
//  HomeViewController.swift
//  SlamBook
//
//  Created by Mac on 16/10/21.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    var user: User?
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.layer.borderWidth = 2.0
        nameLabel.layer.borderColor = UIColor.blue.cgColor
        addressLabel.layer.borderWidth = 2.0
        addressLabel.layer.borderColor = UIColor.blue.cgColor
        genderLabel.layer.borderWidth = 2.0
        genderLabel.layer.borderColor = UIColor.blue.cgColor
        navigationController?.isNavigationBarHidden = true
        displayProfile()
    }
//MARK:displayProfile
    func displayProfile(){
        nameLabel.text = user?.name
        addressLabel.text = user?.address
        genderLabel.text = user?.gender
    }
    @IBAction func editProfileBtnAction(_ sender: Any) {
        if let signUpViewControllerObj = storyboard?.instantiateViewController(identifier: "SignUpViewController")as? SignUpViewController{
            signUpViewControllerObj.isFromEditProfile = true
            signUpViewControllerObj.userFromHome = user?.userId
        navigationController?.pushViewController(signUpViewControllerObj, animated: true)
        }
    }
    
    @IBAction func addFriendBtnAction(_ sender: Any) {
        if let addFriendViewControllerObj = storyboard?.instantiateViewController(identifier: "AddFriendViewController")as? AddFriendViewController{
            addFriendViewControllerObj.userId = user?.userId
            navigationController?.pushViewController(addFriendViewControllerObj, animated: true)
        }
    }
    
    @IBAction func friendListBtnAction(_ sender: Any) {
        if let friendListViewControllerObj = storyboard?.instantiateViewController(identifier: "FriendListViewController") as? FriendListViewController{
            let dbhelperObj = DBHelper()
            guard let user = user else {
                return
            }
            if let friends = dbhelperObj.userFriend(userId: user.userId){
                friendListViewControllerObj.userId = user.userId
                friendListViewControllerObj.friends = friends
                navigationController?.pushViewController(friendListViewControllerObj, animated: true)
            }
        }
    }
    @IBAction func logoutBtnAction(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}
