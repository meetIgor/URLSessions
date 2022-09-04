//
//  DrinksTableViewController.swift
//  urlSession-1
//
//  Created by igor s on 02.09.2022.
//

import UIKit

class DrinksTableViewController: UITableViewController {
    
    private var drinks = Drink(drinks: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 100
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinks.drinks.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "drinkCell", for: indexPath)
        
        let drink = drinks.drinks[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = drink.name
        content.secondaryText = drink.id
        
//        guard let imageURL = URL(string: drink.imageURL ?? "") else { return cell }
//
//        DispatchQueue.global().async {
//            guard let imageData = try? Data(contentsOf: imageURL) else { return }
//            DispatchQueue.main.async {
//                content.image = UIImage(data: imageData)
//                cell.contentConfiguration = content
//            }
//        }
        
        NetworkManager.shared.fetchImage(from: drink.imageURL) { result in
            switch result {
            case .success(let imageData):
                content.image = UIImage(data: imageData)
                cell.contentConfiguration = content
            case .failure(let error):
                print(error)
            }
        }
        
        content.imageProperties.cornerRadius = 15 //tableView.rowHeight / 2
        
        
        return cell
    }
    
}

// MARK: - Fetch Drinks

extension DrinksTableViewController {
    
    func fetchDrinks() {
//        guard let url = URL(string: Link.margaritaURL.rawValue) else { return }
//
//        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
//            guard let data = data else {
//                print(error?.localizedDescription ?? "No error description")
//                return
//            }
//            do {
//                self?.drinks = try JSONDecoder().decode(Drink.self, from: data)
//                DispatchQueue.main.async {
//                    self?.tableView.reloadData()
//                }
//            } catch let error {
//                print(error.localizedDescription)
//            }
//        }.resume()
        
//        NetworkManager.shared.fetchDrinks(from: Link.margaritaURL.rawValue) { [weak self] result in
//            switch result {
//            case .success(let drinks):
//                self?.drinks = drinks
//                self?.tableView.reloadData()
//            case .failure(let error):
//                print(error)
//            }
//        }
        
        NetworkManager.shared.fetch(Drink.self, from: Link.margaritaURL.rawValue) { [weak self] result in
            switch result {
            case .success(let drinks):
                self?.drinks = drinks
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}
