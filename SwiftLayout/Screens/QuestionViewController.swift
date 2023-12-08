import UIKit

class QuestionViewController: UIViewController {
    
    private let questionLabel = UILabel()
    private let textField = UITextField()
    private let nextButton = SLButton(backgroundColor: .systemBlue, title: "Next >")
    private let backButton = SLButton(backgroundColor: .systemBlue, title: "< Back")
    
    private var questionID: Int
    private var question: Question?
    private var loadDidFinish: Bool {
        return !QAManager.shared.isLoading
    }

    init(questionID: Int) {
        self.questionID = questionID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        QAManager.shared.delegate = self
        setupAutoLayout()
        configure()
        // MARK: if loading is not finished, wait for the completion to call getquestion
        // Otherwise, directly call getQuestion()
        if loadDidFinish {
            getQuestion()
        }
    }
    
    private func setupAutoLayout() {
        [questionLabel, textField, nextButton, backButton].forEach { item in
            view.addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
        }
        questionLabel.numberOfLines = 2
        
        NSLayoutConstraint.activate([
            questionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            questionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150),
            questionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant:  -40),
            
            textField.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 10),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.heightAnchor.constraint(equalToConstant: 50),
            textField.widthAnchor.constraint(equalTo: view.widthAnchor, constant:  -40),
        
            nextButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 30),
            nextButton.centerXAnchor.constraint(equalTo: questionLabel.centerXAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            nextButton.widthAnchor.constraint(equalToConstant: 300),
            
            backButton.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 30),
            backButton.centerXAnchor.constraint(equalTo: questionLabel.centerXAnchor),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            backButton.widthAnchor.constraint(equalToConstant: 300)
        ]);
    }
    
    func configure() {
        
        textField.text = QAManager.shared.getAnswer(index: questionID)
        textField.borderStyle = .roundedRect
        
        questionLabel.text = "Loading question..."
        questionLabel.font = UIFont.systemFont(ofSize: 24)
        
        // MARK: Do Not allow User to move forward and backward if the data is still loading
        [nextButton,backButton].forEach { button in
            button.backgroundColor = loadDidFinish ?  .systemBlue : .gray
            button.isEnabled = loadDidFinish
        }
        
        nextButton.addTarget(self, action: #selector(nextButtonOnTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonOnTapped), for: .touchUpInside)
    }
    
    // Safely call this apis since the load is already finished
    func getQuestion() {
        let question = QAManager.shared.getQuestion(index: questionID)
        questionLabel.text = question.text
        self.textField.keyboardType = question.type == "integer" ? .numberPad : .default
    }
    
    @objc func backButtonOnTapped() {
        if loadDidFinish {
            QAManager.shared.updateAnswer(index: questionID, newValue: textField.text ?? "")
        }
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nextButtonOnTapped() {
        if !loadDidFinish { return }
        QAManager.shared.updateAnswer(index: questionID, newValue: textField.text ?? "")
            
        if QAManager.shared.checkIsLastQuestion(questionID) {
            self.navigationController?.pushViewController(ReviewController(), animated: true)
        }else {
            self.navigationController?.pushViewController(QuestionViewController(questionID: questionID + 1), animated: true)
        }
    }
    
}

extension QuestionViewController: QAManagerDelegate {
    
   func didLoadData() {
       DispatchQueue.main.async {[weak self] in
           guard let self = self else {return}
           // Enable the buttons
           self.nextButton.isEnabled = true
           self.nextButton.backgroundColor = .systemBlue
           
           self.backButton.isEnabled = true
           self.backButton.backgroundColor = .systemBlue
           
           // Get current question
           self.getQuestion()
       }
    }
}

