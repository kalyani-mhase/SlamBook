//
//  FriendListViewController.swift
//  SlamBook
//
//  Created by Mac on 16/10/21.
//

import UIKit

class FriendListViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var friendListTableView: UITableView!
    var friends = [Friend]()
    var userId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.friendListTableView.reloadData()
        navigationController?.isNavigationBarHidden = false
        navigationItem.hidesBackButton = true
        let newBackBtn = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backBtnAction))
        self.navigationItem.leftBarButtonItem = newBackBtn
        let nibFile = UINib(nibName: "FriendTableViewCell", bundle: nil)
        self.friendListTableView.register(nibFile, forCellReuseIdentifier: "FriendTableViewCell")
        searchBar.delegate = self
        searchBar.layer.borderWidth = 3.0
        searchBar.layer.borderColor = UIColor.blue.cgColor
    }
    @objc func backBtnAction(){
        navigationController?.isNavigationBarHidden = true
        navigationController?.popViewController(animated: true)
    }
}
//MARK:UITableViewDelegate,UITableViewDataSource
extension FriendListViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        friends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = friendListTableView.dequeueReusableCell(withIdentifier: "FriendTableViewCell")as? FriendTableViewCell{
            let friend = friends[indexPath.row]
            cell.nameLabel.text = friend.name
            cell.contactLabel.text = friend.contact
            cell.nameLabel.layer.borderWidth = 3.0
            cell.nameLabel.layer.borderColor = UIColor.blue.cgColor
            cell.contactLabel.layer.borderWidth = 3.0
            cell.contactLabel.layer.borderColor = UIColor.blue.cgColor
            
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friend = friends[indexPath.row]
        if let addFriendViewControllerobj = storyboard?.instantiateViewController(identifier: "AddFriendViewController")as? AddFriendViewController{
            addFriendViewControllerobj.friend = friend
            addFriendViewControllerobj.flag = true
            navigationController?.pushViewController(addFriendViewControllerobj, animated: true)
        }
    }
    
    @objc func dismissKeyboard(){
        searchBar.resignFirstResponder()
    }
    
    func searchedFriend(_ seachedText: String) {
        if let userId = userId {
            let dbObj = DBHelper()
            if let friends = dbObj.searchFriend(searchedText: seachedText, userId: userId){
                self.friends = friends
                self.friendListTableView.reloadData()
            }else{
                print("No matches found!!!")
            }
        }
    }
}
extension FriendListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        guard let searchText = searchBar.text else {
            return
        }
        searchedFriend(searchText)
    }
}
