//
//  QAManager.swift
//  SwiftLayout
//
//  Created by Shuai Zhang on 12/5/23.
//

import Foundation

protocol QAManagerDelegate: AnyObject {
    func didLoadData()
}

class QAManager {
    static let shared = QAManager()
    
    var isLoading: Bool = true
    weak var delegate: QAManagerDelegate?
    private var questions = [Question]()
    private var answers = [String]()
    
    private let cache = NSCache<NSNumber, NSArray>()
    
    private init() {
        fetchQuestions()
    }
    
    func fetchQuestions() {
        self.isLoading = true
        DispatchQueue.global(qos: .userInteractive).async {
            guard let data = NetworkManager.getOnboarding() else {return }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let dataEntity = try decoder.decode(DataEntity.self, from: data)
                DispatchQueue.main.async {[weak self] in
                    guard let self = self else {return}
                    self.questions = dataEntity.questions
                    self.answers = Array(repeating: "", count: self.questions.count)
                    
                    // Cache the questions as String arrays
                    for (index, question) in self.questions.enumerated() {
                        let questionData = [question.text, question.type]
                        self.cache.setObject(questionData as NSArray, forKey: NSNumber(value: index))
                    }
                    
                    self.isLoading = false
                    // Notify VC that data is loaded successfully
                    delegate?.didLoadData()
                }
            } catch {
                print("failed to decode")
            }
        }
    }
    
    func getQuestions() -> [Question] {
        
        return questions
    }
    
    func getAnswers() -> [String] {
        return answers
    }
    
    func getQuestion(index: Int) -> Question {
        let key = NSNumber(value: index)
        if let cachedData = cache.object(forKey: key) as? [String], cachedData.count >= 2 {
            // MARK: Prove read from cache works
            print("read from cache")
            return Question(text: cachedData[0], type: cachedData[1])
        } else {
            return questions[index]
        }
    }
    
    func getAnswer(index: Int) -> String {
        return answers.isEmpty ? "" : answers[index]
    }
    
    func updateAnswer(index: Int, newValue: String) {
        answers[index] = newValue
    }
    
    func checkIsLastQuestion(_ index: Int) -> Bool {
        return index == QAManager.shared.questions.count - 1
    }
    
}
