//
//  ImageViewController.swift
//  ios-exam
//
//  Created by pharuthapol on 19/7/2567 BE.
//

import UIKit

class ImageViewController: UIViewController {
    var imageView: UIImageView!

    var imageURL: String? {
        didSet {
            loadImage()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView()
        loadImage()
    }

    private func setupImageView() {
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func loadImage() {
        guard let imageURL = imageURL else { return }
        ImageLoader.shared.loadImage(from: imageURL) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self?.imageView.image = image
                case .failure(let error):
                    print("Failed to load image: \(error)")
                    self?.imageView.image = UIImage(named: "placeholder") // Consider using a placeholder image
                }
            }
        }
    }
}

