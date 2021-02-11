//
//  ViewController.swift
//  Financer
//
//  Created by AnoraxAlmanac on 4/2/21.
//

import UIKit

class ViewController: UIViewController {
    
    var answers = [[String]]()
    
    /// To save/encode the users data.
    func save() {
        if let encoded = try? JSONEncoder().encode(answers) {
            UserDefaults.standard.set(encoded, forKey: "SavedData")
            print(answers)
        }
    }
    
    /// To read/decode the users data.
    func decode() {
        if let data = UserDefaults.standard.data(forKey: "SavedData") {
            if let decoded = try? JSONDecoder().decode([[String]].self, from: data) {
                    self.answers = decoded
                    print("DECODED")
                    return
                }
            }

        self.answers = [[]]
    }
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    var shares = [String]()
    
    var searchedShare = [String]()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "You Holdings"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(askQuestions))
        
        //Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
        
        print(tableView)
    }
    
    @objc func askQuestions() {
        performSegue(withIdentifier: "askQuestions", sender: self)
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    /**
     Is called in the QuestionsViewController so that the rows can be filled by the time the view transitions back.
     - Parameter answered: The answers the user gave to the questions asked in the QuestionsViewController.
     */
    func questionsAnswered(answered: [String]) {
        decode()
        answers = answers + [answered]
        save()
        
        /// Adding the share names to tableView.
        for a in answers {
            print(a[0])
            print(tableView)
        
            let indexPath = IndexPath(row: (shares.count), section: 0)
            shares.append(a[0])
            tableView?.insertRows(at: [indexPath], with: .automatic)
        }
        tableView?.reloadData()
        print("COMPLETED")
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedShare = shares.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchedShare.count
        } else {
            return shares.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if searching {
            cell?.textLabel?.text = searchedShare[indexPath.row]
        } else {
            cell?.textLabel?.text = shares[indexPath.row]
        }
        return cell!
    }
}
