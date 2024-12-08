//
//  UserDetailsViewController.swift
//  project
//
//  Created by Yang Shi on 12/1/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class UserDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let db = Firestore.firestore()
    
    var tableView: UITableView!
    
    var userDetails: [(member: String, owesMe: Double, iOwe: Double)] = []
    
    var currentUser: String = Auth.auth().currentUser?.displayName ?? "Unknown User"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.title = "My Details"
        
        setupTableView()
        fetchBillsAndCalculateDetails()
    }
    
    func setupTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UserDetailsCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func fetchBillsAndCalculateDetails() {
        db.collection("bills").getDocuments { [weak self] (snapshot, error) in
            guard let self = self, let documents = snapshot?.documents else {
                print("Error fetching bills: \(String(describing: error?.localizedDescription))")
                return
            }
            
            var owesMeDetails: [String: Double] = [:]
            var iOweDetails: [String: Double] = [:]
            
            for document in documents {
                let data = document.data()
                let groupMembers = data["groupMembers"] as? [String] ?? []
                let amount = data["amount"] as? Double ?? 0.0
                let postedBy = data["postedBy"] as? String ?? "Unknown"
                let splitAmount = data["splitAmount"] as? Double ?? 0.0
                
                if groupMembers.contains(self.currentUser) {
                    for member in groupMembers where member != self.currentUser {
                        owesMeDetails[member, default: 0.0] += splitAmount
                    }
                } else if postedBy == self.currentUser {
                    for member in groupMembers {
                        owesMeDetails[member, default: 0.0] += splitAmount
                    }
                } else {
                    iOweDetails[postedBy, default: 0.0] += splitAmount
                }
            }
            
            self.userDetails = owesMeDetails.map { (member, amount) in
                (member: member, owesMe: amount, iOwe: 0.0)
            } + iOweDetails.map { (member, amount) in
                (member: member, owesMe: 0.0, iOwe: amount)
            }
            
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserDetailsCell", for: indexPath)
        let detail = userDetails[indexPath.row]
        
        cell.textLabel?.text = detail.owesMe > 0
            ? "\(detail.member) owes you: $\(String(format: "%.2f", detail.owesMe))"
            : "You owe \(detail.member): $\(String(format: "%.2f", detail.iOwe))"
        
        return cell
    }
} 
