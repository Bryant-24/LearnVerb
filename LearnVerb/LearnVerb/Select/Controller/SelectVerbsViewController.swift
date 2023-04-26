//
//  SelectVerbsViewController.swift
//  LearnVerb
//
//  Created by Ruslan Galiev on 4/21/23.
//

import UIKit

final class SelectVerbsViewController: UITableViewController {
    
    // MARK: - Properties
    private var dataSource = IrregularVerbs.shared
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Select Verbs"
        
        view.backgroundColor = .white
        tableView.register(SelectVerbTableViewCell.self, forCellReuseIdentifier: "SelectVerbsTableViewCell")
        dataSource.selectedVerbs = dataSource.verbs.map { $0 }
    }
    
    // MARK: - Private methods
    private func isSelectedVerb(verb: Verb) -> Bool {
        dataSource.selectedVerbs.contains(where: { $0.infinitive == verb.infinitive })
    }
}

// MARK: - UITableViewDataSource
extension SelectVerbsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.verbs.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectVerbsTableViewCell", for: indexPath) as? SelectVerbTableViewCell else { return UITableViewCell() }
        
        let verb = dataSource.verbs[indexPath.row]
        cell.configure(with: verb, isSelected: isSelectedVerb(verb: verb))
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SelectVerbsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let verb = dataSource.verbs[indexPath.row]
        
        if isSelectedVerb(verb: verb) {
            dataSource.selectedVerbs.removeAll(where: { $0.infinitive == verb.infinitive })
        } else {
            dataSource.selectedVerbs.append(verb)
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
