//
//  MainCollectionViewController.swift
//  urlSession-1
//
//  Created by igor s on 02.09.2022.
//

import UIKit
import Alamofire

//private let reuseIdentifier = "Cell"

class MainCollectionViewController: UICollectionViewController {
    
    private let actions = Action.allCases
    private var apods: [APOD] = []
    private var apod2: APOD2!
    
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
        case .postRequest:
            postRequestWithDict()
        case .postRequestWithModel:
            postRequestWithModel()
        case .fetchAPOD:
            fetchAPOD()
        case .fetchAPODWithParam:
            fetchAPODWithParam()
        case .afAPODFetch:
            fetchAFNasa()
            print(apods)
        case .afPostRequest:
            afPostRequest()
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
//        guard let url = URL(string: Link.margaritaURL.rawValue) else { return }
//
//        URLSession.shared.dataTask(with: url) { [unowned self] data, _, error in
//            guard let data = data else {
//                print(error?.localizedDescription ?? "No error description")
//                return
//            }
//
//            do {
//                let drinks = try JSONDecoder().decode(Drink.self, from: data)
//                print(drinks)
//                self.successAlert()
//            } catch let error {
//                print(error)
//                self.failedAlert()
//            }
//        }.resume()
    
//        NetworkManager.shared.fetchDrinks(from: Link.margaritaURL.rawValue) { [weak self] result in
//            switch result {
//            case .success(let drinks):
//                print(drinks)
//                self?.successAlert()
//            case .failure(let error):
//                print(error)
//                self?.failedAlert()
//            }
//        }
        
        NetworkManager.shared.fetch(Drink.self, from: Link.margaritaURL.rawValue) { [weak self] result in
            switch result {
            case .success(let drinks):
                print(drinks)
                self?.successAlert()
            case .failure(let error):
                print(error)
                self?.failedAlert()
            }
        }
    }
    
    private func postRequestWithDict() {
        let drink = [
            "id": "001",
            "name": "Negroni",
            "category": "alcoholic"
        ]
        
        NetworkManager.shared.postRequest(with: drink, to: Link.postRequest.rawValue) { [weak self] result in
            switch result {
            case .success(let json):
                print(json)
                self?.successAlert()
            case .failure(let error):
                print(error)
                self?.failedAlert()
            }
        }
    }
    
    private func postRequestWithModel() {
        let negroni = Cocktail(id: "007", name: "Negroni", drinkAlternate: "NO", tags: "alc, tasty", video: nil, category: "alcoholic", iba: nil, alcoholic: "YES", glass: "glass#2", instructions: "to do to do to do to do", imageURL: "https://www.thecocktaildb.com/images/media/drink/5noda61589575158.jpg", ingredient1: "compary", ingredient2: "orange juice", ingredient3: "ice", ingredient4: nil, ingredient5: nil, ingredient6: nil, ingredient7: nil, ingredient8: nil, ingredient9: nil, ingredient10: nil, ingredient11: nil, ingredient12: nil, ingredient13: nil, ingredient14: nil, ingredient15: nil, measure1: "1/2", measure2: "2 tsp", measure3: "3", measure4: nil, measure5: nil, measure6: nil, measure7: nil, measure8: nil, measure9: nil, measure10: nil, measure11: nil, measure12: nil, measure13: nil, measure14: nil, measure15: nil)
        let drink = Drink(drinks: [negroni])
        
        NetworkManager.shared.postRequestWithModel(with: drink, to: Link.postRequest.rawValue) { [weak self] result in
            switch result {
            case .success(let drink):
                print(drink)
                self?.successAlert()
            case .failure(let error):
                print(error)
                self?.failedAlert()
            }
        }
    }
    
    func fetchAPOD() {
        NetworkManager.shared.fetchAPOD([APOD].self, from: nasaLink.apodURL.rawValue) { [weak self] result in
            switch result {
            case .success(let apod):
                print(apod)
                self?.successAlert()
            case .failure(let error):
                print(error)
                self?.failedAlert()
            }
        }
        
    }
    
    func fetchAPODWithParam() {
        AFNetworkManager.shared.fetchApodWithParams(from: nasaLink.apodURLMain.rawValue) { [weak self] result in
            switch result {
            case .success(let apod):
                print(apod)
                self?.successAlert()
            case .failure(let error):
                print(error)
                self?.failedAlert()
            }
        }
    }
    
    func fetchAFNasa() {
//        AF.request(nasaLink.apodURL.rawValue)
//            .validate()
//            .responseJSON { [weak self] dataResponse in
//                switch dataResponse.result {
//                case .success(let value):
//                    self?.apods = APOD.getApods(from: value)
//                case .failure(let error):
//                    print(error)
//                }
//            }
        AFNetworkManager.shared.fetchAPOD(from: nasaLink.apodURL.rawValue) { [weak self] result in
            switch result {
            case .success(let apodData):
                self?.apods = apodData
                print(self?.apods)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func afPostRequest() {
        let apod = APOD(apodData: [
            "date" : "2022-09-04",
            "explanation" : "very step caused the sand to light up blue. That glow was bioluminescence -- a blue radiance that also lights the surf in this surreal scene captured in mid-2018 at Meyer's Creek Beach in Oregon, USA. Volcanic stacks dot the foreground sea, while a thin fog layer scatters light on the horizon. The rays of light spreading from the left horizon were created by car headlights on the Oregon Coast Highway (US 101), while the orange light on the right horizon emanates from a fishing boat.  Visible far in the distance is the band of our Milky Way Galaxy, appearing to rise from a dark rocky outcrop.  Sixteen images were added together to bring up the background Milky Way and to reduce noise.    Your Sky Surprise: What picture did APOD feature on your birthday? (post 1995)",
            "mediaType" : "image",
            "serviceVersion" : "v1",
            "title" : "Sea and Sky Glows over the Oregon Coast",
            "url" : "https://apod.nasa.gov/apod/image/2209/MilkyWayOregon_Montoya_960.jpg",
            "hdurl" : "https://apod.nasa.gov/apod/image/2209/MilkyWayOregon_Montoya_1500.jpg"
        ]
        )
        
        AFNetworkManager.shared.afPostRequest(to: Link.postRequest.rawValue, with: apod) { [weak self] result in
            switch result {
            case .success(let apodData):
                print(apodData)
                self?.successAlert()
            case .failure(let error):
                print(error)
                self?.failedAlert()
            }
        }
    }
}

// MARK: - Buttons Action
enum Action: String, CaseIterable {
    case showImage = "Show Image"
    case fetchDrinks = "Fetch Drinks"
    case fetchDrinksToTable = "Fetch Margarita"
    case postRequest = "POST Request"
    case postRequestWithModel = "POST Req (Model)"
    case fetchAPOD = "fetch NASA"
    case fetchAPODWithParam = "fetch NASA with Param"
    case afAPODFetch = " AF Fetch Nasa"
    case afPostRequest = "AF POST"
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
