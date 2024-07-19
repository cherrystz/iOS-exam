//
//  HomeViewController.swift
//  ios-exam
//
//  Created by pharuthapol on 19/7/2567 BE.
//

import UIKit
import Lottie

class HomeViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var firstCarouselCollectionView: UICollectionView!
    @IBOutlet weak var eventSingleCardCollectionView: UICollectionView!
    @IBOutlet weak var secondCarouselCollectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    let refreshControl = UIRefreshControl()
    
    var firstCarousels: JSONObject = [:]
    var firstCarouselsCount: Int = 0
    var eventSingleCards: [JSONObject] = []
    var secondCarousels: JSONObject = [:]
    var secondCarouselsCount: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstCarouselCollectionView.delegate = self
        firstCarouselCollectionView.dataSource = self
        eventSingleCardCollectionView.delegate = self
        eventSingleCardCollectionView.dataSource = self
        secondCarouselCollectionView.delegate = self
        secondCarouselCollectionView.dataSource = self
        
        handleDataFetched()
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        scrollView.refreshControl = refreshControl
        
        // Register to listen for data fetched notification
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataFetched), name: .dataFetched, object: nil)
    }
    
    @objc private func refreshData() {
        // Reload your data here
        AppData.fetchData()
        
        // Simulate a network call or data processing
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // End refreshing
            self.refreshControl.endRefreshing()
        }
    }
    
    @objc func handleDataFetched() {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
        
        if let _ = AppData.error {
            showNoInternetConnection()
        } else {
            DispatchQueue.main.async {
                self.scrollView.isHidden = false
                self.noInternetConnectionView.isHidden = true
            }
            if let firstCarousels = AppData.carouselsJson.first,
               let firstCarouselsCount = (firstCarousels["items"] as? [JSONObject])?.count,
               let secondCarousels = AppData.carouselsJson.last,
               let secondCarouselsCount = (secondCarousels["items"] as? [JSONObject])?.count
            {
                self.firstCarousels = firstCarousels
                self.firstCarouselsCount = firstCarouselsCount
                self.eventSingleCards = AppData.eventSingleCardsJson
                self.secondCarousels = secondCarousels
                self.secondCarouselsCount = secondCarouselsCount
                
                DispatchQueue.main.async {
                    self.firstCarouselCollectionView.reloadData()
                    self.secondCarouselCollectionView.reloadData()
                    self.eventSingleCardCollectionView.reloadData()
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .dataFetched, object: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return firstCarouselsCount
        }
        if collectionView.tag == 1 {
            return eventSingleCards.count
        }
        if collectionView.tag == 2 {
            return secondCarouselsCount
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "firstCarousel", for: indexPath) as! CarouselCollectionViewCell
            
            let carousel = (firstCarousels["items"] as! [JSONObject])[indexPath.item]
            let imageUrl = carousel["coverUrl"] as! String
            
            ImageLoader.shared.loadImage(from: imageUrl) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let image):
                        cell.imageView.image = image
                    case .failure(let error):
                        print("Failed to load image: \(error)")
                        cell.imageView.image = UIImage(named: "placeholder") // Consider using a placeholder image
                    }
                }
            }
            
            return cell
        }
        if collectionView.tag == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventSingleCard", for: indexPath) as! EventSingleCardCollectionViewCell
            
            let event = eventSingleCards[indexPath.item]
            let imageUrl = event["coverUrl"] as! String
            
            ImageLoader.shared.loadImage(from: imageUrl) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let image):
                        cell.imageView.image = image
                    case .failure(let error):
                        print("Failed to load image: \(error)")
                        cell.imageView.image = UIImage(named: "placeholder") // Consider using a placeholder image
                    }
                }
            }
            cell.titleLabel.text = event["title"] as? String ?? ""
            cell.descriptionLabel.text = event["subTitle"] as? String ?? ""
            
            return cell
        }
        if collectionView.tag == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "secondCarousel", for: indexPath) as! CarouselCollectionViewCell
            
            let carousel = (secondCarousels["items"] as! [JSONObject])[indexPath.item]
            let imageUrl = carousel["coverUrl"] as! String
            
            ImageLoader.shared.loadImage(from: imageUrl) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let image):
                        cell.imageView.image = image
                    case .failure(let error):
                        print("Failed to load image: \(error)")
                        cell.imageView.image = UIImage(named: "placeholder") // Consider using a placeholder image
                    }
                }
            }
            
            return cell
        }
        else {
            return UICollectionViewCell()
        }
        
    }
    
    // Internet works
    
    // No Internet Connection
    @IBOutlet weak var noInternetConnectionView: UIView!
    @IBOutlet var noInternetConnectionAnimationView: LottieAnimationView!
    @IBOutlet weak var retryButton: UIButton!
    func showNoInternetConnection() {
        DispatchQueue.main.async {
            self.scrollView.isHidden = true
            self.noInternetConnectionView.isHidden = false
            self.noInternetConnectionAnimationView!.contentMode = .scaleAspectFit
            self.noInternetConnectionAnimationView!.loopMode = .loop
            self.noInternetConnectionAnimationView!.animationSpeed = 0.5
            self.noInternetConnectionAnimationView!.play()
            self.retryButton.titleLabel?.text = "No internet connection. Please try again"
            self.retryButton.isEnabled = true
        }
    }
    
    @IBAction func retryButton(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.noInternetConnectionAnimationView!.loopMode = .loop
            self.noInternetConnectionAnimationView!.animationSpeed = 0.5
            self.noInternetConnectionAnimationView!.play()
            self.retryButton.titleLabel?.text = "Refreshing"
            self.retryButton.isEnabled = false
        }
        self.refreshData()
    }
    
}
