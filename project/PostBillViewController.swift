//
//  PostBillViewController.swift
//  project
//
//  Created by Yang Shi on 12/1/24.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class PostBillViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
        
        var headerLabel: UILabel!
        var eventDescriptionTextField: UITextField!
        var amountTextField: UITextField!
        var selectImageButton: UIButton!
        var imageView: UIImageView!
        var membersTextField: UITextField!
    var noofmembersTextField: UITextField!
        var uploadButton: UIButton!
        var resultLabel: UILabel!
    var selectedImage: UIImage?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.backgroundColor = .white
            
            setupHeaderLabel()
            setupEventDescriptionTextField()
            setupAmountTextField()
            setupSelectImageButton()
            setupImageView()
            setupMembersTextField()
            setupNoOfMembersTextField()
            setupUploadButton()
            setupResultLabel()
            
            initConstraints()
        }
    
    func setupHeaderLabel() {
        headerLabel = UILabel()
        headerLabel.text = "Post a New Bill"
        headerLabel.font = UIFont.boldSystemFont(ofSize: 24)
        headerLabel.textAlignment = .center
        headerLabel.textColor = .black
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerLabel)
    }
    
    func setupEventDescriptionTextField() {
        eventDescriptionTextField = UITextField()
        eventDescriptionTextField.placeholder = "Enter event description"
        eventDescriptionTextField.borderStyle = .roundedRect
        eventDescriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(eventDescriptionTextField)
    }
    
        func setupAmountTextField() {
            amountTextField = UITextField()
            amountTextField.placeholder = "Enter bill amount"
            amountTextField.borderStyle = .roundedRect
            amountTextField.keyboardType = .decimalPad
            amountTextField.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(amountTextField)
        }
        
        func setupSelectImageButton() {
            selectImageButton = UIButton(type: .system)
            selectImageButton.setTitle("Select Image", for: .normal)
            selectImageButton.translatesAutoresizingMaskIntoConstraints = false
            selectImageButton.addTarget(self, action: #selector(selectImageTapped), for: .touchUpInside)
            view.addSubview(selectImageButton)
        }
        
        func setupImageView() {
            imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.layer.borderWidth = 1
            imageView.layer.borderColor = UIColor.lightGray.cgColor
            imageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(imageView)
        }
        
        func setupMembersTextField() {
            membersTextField = UITextField()
            membersTextField.placeholder = "Enter group members (comma-separated)"
            membersTextField.borderStyle = .roundedRect
            membersTextField.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(membersTextField)
        }
        
    func setupNoOfMembersTextField() {
        noofmembersTextField = UITextField()
        noofmembersTextField.placeholder = "Enter the number of group members to split"
        noofmembersTextField.borderStyle = .roundedRect
        noofmembersTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noofmembersTextField)
    }
        
        func setupUploadButton() {
            uploadButton = UIButton(type: .system)
            uploadButton.setTitle("Upload Bill", for: .normal)
            uploadButton.backgroundColor = .systemBlue
            uploadButton.setTitleColor(.white, for: .normal)
            uploadButton.layer.cornerRadius = 8
            uploadButton.translatesAutoresizingMaskIntoConstraints = false
            uploadButton.addTarget(self, action: #selector(uploadBillTapped), for: .touchUpInside)
            view.addSubview(uploadButton)
        }
        
        func setupResultLabel() {
            resultLabel = UILabel()
            resultLabel.text = "Result will appear here"
            resultLabel.textAlignment = .center
            resultLabel.numberOfLines = 0
            resultLabel.textColor = .darkGray
            resultLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(resultLabel)
        }
        
    func initConstraints() {
            NSLayoutConstraint.activate([
                headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                headerLabel.heightAnchor.constraint(equalToConstant: 40),
                
                eventDescriptionTextField.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20),
                        eventDescriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                        eventDescriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                        eventDescriptionTextField.heightAnchor.constraint(equalToConstant: 40),
                
                amountTextField.topAnchor.constraint(equalTo: eventDescriptionTextField.bottomAnchor, constant: 20),
                amountTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                amountTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                amountTextField.heightAnchor.constraint(equalToConstant: 40),
                
                selectImageButton.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 20),
                selectImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                selectImageButton.heightAnchor.constraint(equalToConstant: 40),
                
                imageView.topAnchor.constraint(equalTo: selectImageButton.bottomAnchor, constant: 20),
                imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                imageView.heightAnchor.constraint(equalToConstant: 200),
  
                membersTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
                membersTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                membersTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                membersTextField.heightAnchor.constraint(equalToConstant: 40),
                
                noofmembersTextField.topAnchor.constraint(equalTo: membersTextField.bottomAnchor, constant: 20),
                noofmembersTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                noofmembersTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

                uploadButton.topAnchor.constraint(equalTo: noofmembersTextField.bottomAnchor, constant: 20),
                uploadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                uploadButton.widthAnchor.constraint(equalToConstant: 200),
                uploadButton.heightAnchor.constraint(equalToConstant: 50),
                
                resultLabel.topAnchor.constraint(equalTo: uploadButton.bottomAnchor, constant: 20),
                resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            ])
        }
        
        @objc func selectImageTapped() {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
            imageView.image = image
        } else {
            print("Failed to retrieve selected image.")
        }
        picker.dismiss(animated: true, completion: nil)
    }
        
    @objc func uploadBillTapped() {
        guard let amountText = amountTextField.text, let amount = Double(amountText),
              let eventDescription = eventDescriptionTextField.text, !eventDescription.isEmpty,
              let membersText = membersTextField.text, !membersText.isEmpty,
              let image = selectedImage else {
            resultLabel.text = "Please fill in all fields and select an image."
            return
        }

        let groupMembers = membersText.components(separatedBy: ",")
        let billId = UUID().uuidString

        resultLabel.text = "Uploading bill, please wait..."
        
        let imageRef = storage.child("bills/\(billId).jpg")
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            resultLabel.text = "Failed to process image."
            return
        }

        imageRef.putData(imageData, metadata: nil) { [weak self] _, error in
            if let error = error {
                self?.resultLabel.text = "Image upload failed: \(error.localizedDescription)"
                return
            }

            imageRef.downloadURL { [weak self] url, error in
                guard let self = self, let imageUrl = url?.absoluteString else {
                    self?.resultLabel.text = "Failed to get image URL."
                    return
                }

                self.saveBillToFirestore(
                    billId: billId,
                    amount: amount,
                    eventDescription: eventDescription,
                    imageUrl: imageUrl,
                    groupMembers: groupMembers
                )
                    let billListVC = ViewController()
                    self.navigationController?.pushViewController(billListVC, animated: true)
                
            }
        }
    }

    private func saveBillToFirestore(billId: String, amount: Double, eventDescription: String, imageUrl: String, groupMembers: [String]) {
        let splitAmount = amount / Double(groupMembers.count)
        let currentUser = Auth.auth().currentUser?.displayName ?? "Unknown User"
        let billData: [String: Any] = [
            "id": billId,
            "amount": amount,
            "eventDescription": eventDescription,
            "imageUrl": imageUrl,
            "groupMembers": groupMembers,
            "postedBy": currentUser,
            "splitAmount": splitAmount,
            "timestamp": Timestamp(date: Date())
        ]
        
        db.collection("bills").document(billId).setData(billData) { error in
            if let error = error {
                print("Failed to save bill: \(error.localizedDescription)")
            } else {
                self.clearFields()
                self.resultLabel.text = "Bill uploaded successfully!"
            }
        }
    }
        
        private func clearFields() {
            eventDescriptionTextField.text = ""
            amountTextField.text = ""
            membersTextField.text = ""
            imageView.image = nil
            selectedImage = nil
        }
    }
    
