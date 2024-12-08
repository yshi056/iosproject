//
//  BillDetailsViewController.swift
//  project
//
//  Created by Yang Shi on 12/1/24.
//

import Foundation
import UIKit

class BillDetailsViewController: UIViewController {
    
    var billName: String = ""
    var billAmount: Double = 0.0
    var postedBy: String = ""
    var groupMembers: [String] = []
    var noofMembers: Int = 0
    var imageUrl: String = ""
    
    var imageView: UIImageView!
    var detailsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.title = "Bill Details"
        
        setupImageView()
        setupDetailsLabel()
        fetchImage()
    }
    
    func setupImageView() {
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func setupDetailsLabel() {
        detailsLabel = UILabel()
        detailsLabel.numberOfLines = 0
        detailsLabel.textAlignment = .left
        detailsLabel.font = UIFont.systemFont(ofSize: 16)
        detailsLabel.textColor = .darkGray
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(detailsLabel)
        
        let groupMembersString = groupMembers.joined(separator: ", ")
        detailsLabel.text = """
        Event: \(billName)
        Amount: $\(String(format: "%.2f", billAmount))
        Posted By: \(postedBy)
        Group Members Included: \(groupMembersString)
        """
        
        NSLayoutConstraint.activate([
            detailsLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            detailsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            detailsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func fetchImage() {
        guard let url = URL(string: imageUrl) else {
            print("Invalid image URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }
            if let error = error {
                print("Failed to fetch image: \(error)")
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                print("Failed to decode image data")
                return
            }
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }.resume()
    }
}
