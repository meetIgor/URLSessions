//
//  ImageViewController.swift
//  urlSession-1
//
//  Created by igor s on 02.09.2022.
//

import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        fetchImage()
    }
    
    private func fetchImage() {
        /*
        guard let url = URL(string: Link.imageURL.rawValue) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, let response = response else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            print(response)
            
            DispatchQueue.main.async {
                guard let image = UIImage(data: data) else { return }
                self?.imageView.image = image
                self?.activityIndicator.stopAnimating()
            }
        }.resume()
        */
        
        /*
        NetworkManager.shared.fetchImage(from: Link.imageURL.rawValue) { [weak self] imageData in
            self?.imageView.image = UIImage(data: imageData)
            self?.activityIndicator.stopAnimating()
        }
        */
        
        NetworkManager.shared.fetchImage(from: Link.imageURL.rawValue) { [weak self] result in
            switch result {
            case .success(let imageData):
                self?.imageView.image = UIImage(data: imageData)
                self?.activityIndicator.stopAnimating()
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
