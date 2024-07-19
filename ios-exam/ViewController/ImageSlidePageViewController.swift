//
//  ImageSlidePageViewController.swift
//  ios-exam
//
//  Created by pharuthapol on 19/7/2567 BE.
//

import UIKit

class ImageSlidePageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var imageUrls: [String] = [] {
        didSet {
            DispatchQueue.main.async {
                self.pageControl.numberOfPages = self.imageUrls.count // Update page control when imageUrls changes
                if let currentViewController = self.viewControllers?.first as? ImageViewController {
                    let currentIndex = self.indexOfViewController(viewController: currentViewController)
                    if let newViewController = self.viewControllerAtIndex(index: currentIndex) {
                        self.setViewControllers([newViewController], direction: .forward, animated: false, completion: nil)
                    }
                } else if !self.imageUrls.isEmpty {
                    if let initialViewController = self.viewControllerAtIndex(index: 0) {
                        self.setViewControllers([initialViewController], direction: .forward, animated: true, completion: nil)
                    }
                }
            }
        }
    }

    private var pageControl: UIPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self

        setupPageControl()
        loadImageUrls()

        NotificationCenter.default.addObserver(self, selector: #selector(handleDataFetched), name: .dataFetched, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupPageControlConstraints()
    }
    
    private func setupPageControl() {
        pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor(red: 1.0, green: 0.01, blue: 0.01, alpha: 1.0) // #FF0200
        pageControl.pageIndicatorTintColor = UIColor.white // #FFFFFF
        pageControl.numberOfPages = imageUrls.count
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)
    }
    
    private func setupPageControlConstraints() {
        if let pageControl = pageControl {
            NSLayoutConstraint.activate([
                pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
                pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        }
    }
    
    @objc func handleDataFetched() {
        loadImageUrls()
    }
    
    func loadImageUrls() {
        guard let bannerJson = AppData.bannersJson.first else {
            return
        }

        if let items = bannerJson["items"] as? [JSONObject] {
            imageUrls = items.compactMap { json in
                guard let url = json["coverUrl"] as? String else {
                    return nil
                }
                return url
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .dataFetched, object: nil)
    }

    func viewControllerAtIndex(index: Int) -> ImageViewController? {
        if index >= 0 && index < imageUrls.count {
            let imageViewController = ImageViewController()
            imageViewController.imageURL = imageUrls[index]
            return imageViewController
        }
        return nil
    }

    func indexOfViewController(viewController: ImageViewController) -> Int {
        if let imageUrl = viewController.imageURL {
            return imageUrls.firstIndex(of: imageUrl) ?? NSNotFound
        }
        return NSNotFound
    }

    // MARK: - UIPageViewControllerDataSource

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? ImageViewController,
           indexOfViewController(viewController: viewController) > 0 {
            return self.viewControllerAtIndex(index: indexOfViewController(viewController: viewController) - 1)
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? ImageViewController,
           indexOfViewController(viewController: viewController) < imageUrls.count - 1 {
            return self.viewControllerAtIndex(index: indexOfViewController(viewController: viewController) + 1)
        }
        return nil
    }
    
    // MARK: - UIPageViewControllerDelegate

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let currentViewController = viewControllers?.first as? ImageViewController {
                let currentIndex = indexOfViewController(viewController: currentViewController)
                pageControl.currentPage = currentIndex
            }
        }
    }
}
