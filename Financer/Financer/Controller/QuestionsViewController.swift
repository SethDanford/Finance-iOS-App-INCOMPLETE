//
//  QuestionsViewController.swift
//  Financer
//
//  Created by AnoraxAlmanac on 8/2/21.
//

import UIKit

class QuestionsViewController: UIViewController {

    @IBOutlet var question: UILabel!
    @IBOutlet var answer: UITextField!
    @IBOutlet var doneAnswering: UIButton!
    var questionNumber = 1
    
    var questions = ["What company’s stock did you trade?", "When did you purchase the shares?", "At what price did you purchase the shares?", "When did you sell the shares?", "At what price did you sell the shares?", "How many shares of | did you buy?"]
    
    var placeHolders = ["Enter text", "Example: 24/02/2020", "Enter text", "Example: 24/02/2020", "Enter text", "Enter text"]
    
    /// Question answers go here.
    var answered = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
        
        doneAnswering.layer.cornerRadius = 8.0
        
        question.text = questions[0]
        answer.placeholder = placeHolders[0]
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    /// Sets the question and placeholder.
    func askingQuestions() {
        question.text = questions[questionNumber]
        answer.placeholder = placeHolders[questionNumber]
        // questionNumber += 1
    }
    
    @IBAction func donePressed(_ sender: Any) {
        if questionNumber >= 6 {
            
            let vc = ViewController(nibName: "ViewController", bundle: nil)
            vc.questionsAnswered(answered: answered)
            
            navigationController?.pushViewController(vc, animated: true)
            dismiss(animated: true, completion: nil)
            return
        }
        answered.append(answer.text ?? "unknown")
        answer.text = ""
        askingQuestions()
        questionNumber += 1
    }
}
