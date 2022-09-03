//
//  MainCollectionViewController.swift
//  urlSession-1
//
//  Created by igor s on 02.09.2022.
//

import UIKit

//private let reuseIdentifier = "Cell"

class MainCollectionViewController: UICollectionViewController {
    
    private let actions = Action.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDrinks" {
            guard let drinksVC = segue.destination as? DrinksTableViewController else { return }
            drinksVC.fetchDrinks()
        }
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actions.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "actionCell",
                for: indexPath
            ) as? ActionCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        cell.actionLabel.text = actions[indexPath.item].rawValue
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let action = actions[indexPath.item]
        
        switch action {
        case .showImage:
            performSegue(withIdentifier: "showImage", sender: nil)
        case .fetchDrinks:
            fetchDrinks()
        case .fetchDrinksToTable:
            performSegue(withIdentifier: "showDrinks", sender: nil)
        }
    }
}

// MARK: -Collection View Delegate Flow Layout

extension MainCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 48, height: 100)
    }
}

// MARK: - Fetch Methods

extension MainCollectionViewController {
    private func fetchImage() {
        
    }
    
    private func fetchDrinks() {
        guard let url = URL(string: Link.margaritaURL.rawValue) else { return }
        
        URLSession.shared.dataTask(with: url) { [unowned self] data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let drinks = try JSONDecoder().decode(Drink.self, from: data)
                print(drinks)
                self.successAlert()
            } catch let error {
                print(error)
                self.failedAlert()
            }
        }.resume()
        
    }
}

// MARK: - Buttons Action
enum Action: String, CaseIterable {
    case showImage = "Show Image"
    case fetchDrinks = "Fetch Drinks"
    case fetchDrinksToTable = "Fetch Margarita"
}

// MARK: - Alert Controller
extension MainCollectionViewController {
    
    private func successAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Success",
                message: "U can see results",
                preferredStyle: .alert
            )
            let okAction = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
    
    private func failedAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Failed",
                message: "Some error",
                preferredStyle: .alert
            )
            let okAction = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
}
