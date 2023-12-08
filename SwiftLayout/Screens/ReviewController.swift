//
//  ReviewController.swift
//  SwiftLayout
//
//  Created by Shuai Zhang on 12/5/23.
//

import Foundation
import UIKit

class ReviewController: UIViewController {
    
    private var stackView: UIStackView!
    private let confirmButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "Review"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupStackView()
        setupAnswers()
        setupConfirmButton()
    }
    private func setupStackView() {
        // Initialize the stack view
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        view.addSubview(stackView)
        
        // Set up the stack view constraints
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
    }
    
    private func setupAnswers () {
        // Retrieve answers and create labels
        let answers = QAManager.shared.getAnswers()
        let questions = ["Name:", "Job Title:", "Work Location:", "Years of Experience:", "Living Location:"]
        
        for (index, question) in questions.enumerated() {
            let questionLabel = UILabel()
            questionLabel.textColor = .black
            questionLabel.font = UIFont.boldSystemFont(ofSize: 16)
            questionLabel.text = question
            
            let answerLabel = UILabel()
            answerLabel.textColor = .darkGray
            answerLabel.text = answers[index]
            
            self.stackView.addArrangedSubview(questionLabel)
            self.stackView.addArrangedSubview(answerLabel)
        }
        
    }
    
    private func setupConfirmButton() {
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.setTitleColor(.white, for: .normal) 
        confirmButton.backgroundColor = .systemBlue
        confirmButton.layer.cornerRadius = 10
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)

        view.addSubview(confirmButton)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            confirmButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmButton.widthAnchor.constraint(equalToConstant: 200),
            confirmButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func confirmButtonTapped() {
        print("Success")
    }
}
