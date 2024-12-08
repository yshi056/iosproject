//
//  BillListViewController.swift
//  project
//
//  Created by Yang Shi on 12/1/24.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
   let db = Firestore.firestore()
   var bills: [BillItem] = []
   var tableView: UITableView!
   var myDetailsButton: UIButton!
   
   override func viewDidLoad() {
       super.viewDidLoad()
       
       view.backgroundColor = .white
       self.title = "All Bills"
       
       let postBillButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(postNewBillTapped))
       self.navigationItem.rightBarButtonItem = postBillButton
       
       setupTableView()
       setupMyDetailsButton()
       fetchBills()
   }
   
   func setupTableView() {
       tableView = UITableView()
       tableView.delegate = self
       tableView.dataSource = self
       tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BillCell")
       tableView.translatesAutoresizingMaskIntoConstraints = false
       view.addSubview(tableView)
       
       NSLayoutConstraint.activate([
           tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
           tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
           tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
           tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
       ])
   }
   
   func setupMyDetailsButton() {
           myDetailsButton = UIButton(type: .system)
           myDetailsButton.setTitle("My Details", for: .normal)
           myDetailsButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
           myDetailsButton.backgroundColor = .systemBlue
           myDetailsButton.setTitleColor(.white, for: .normal)
           myDetailsButton.layer.cornerRadius = 8
           myDetailsButton.translatesAutoresizingMaskIntoConstraints = false
           myDetailsButton.addTarget(self, action: #selector(myDetailsTapped), for: .touchUpInside)
           view.addSubview(myDetailsButton)
           
           NSLayoutConstraint.activate([
               myDetailsButton.heightAnchor.constraint(equalToConstant: 50),
               myDetailsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
               myDetailsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
               myDetailsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
           ])
       }
       
   @objc func myDetailsTapped() {
       let userDetailsVC = UserDetailsViewController()
       userDetailsVC.userDetails = userDetails
       navigationController?.pushViewController(userDetailsVC, animated: true)
   }


   func fetchBills() {
       db.collection("bills").getDocuments { [weak self] (snapshot, error) in
           guard let self = self, let documents = snapshot?.documents else {
               print("Error fetching bills: \(String(describing: error?.localizedDescription))")
               return
           }
           
           self.bills = documents.map { doc in
               let data = doc.data()
               return BillItem(
                   id: doc.documentID,
                   amount: data["amount"] as? Double ?? 0.0,
                   name: data["eventDescription"] as? String ?? "No Name",
                   postedBy: data["postedBy"] as? String ?? "Unknown",
                   groupMembers: data["groupMembers"] as? [String] ?? [],
                   noofMembers: data["noofMembers"] as? Int ?? 0,
                   imageUrl: data["imageUrl"] as? String ?? ""
               )
           }
           
           print("Fetched Bills: \(self.bills)") // Debug Log
           self.tableView.reloadData()
       }
   }
   
   @objc func postNewBillTapped() {
       let postBillVC = PostBillViewController()
       navigationController?.pushViewController(postBillVC, animated: true)
   }

       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return bills.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "BillCell", for: indexPath)
           
           let bill = bills[indexPath.row]
           cell.textLabel?.text = "\(bill.name) - $\(String(format: "%.2f", bill.amount)) (Posted by: \(bill.postedBy))"
           return cell
       }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       tableView.deselectRow(at: indexPath, animated: true)
       
       let bill = bills[indexPath.row]
       let detailsVC = BillDetailsViewController()
       detailsVC.billName = bill.name
       detailsVC.billAmount = bill.amount
       detailsVC.postedBy = bill.postedBy
       detailsVC.groupMembers = bill.groupMembers
       detailsVC.imageUrl = bill.imageUrl
       
       navigationController?.pushViewController(detailsVC, animated: true)
   }
   }
