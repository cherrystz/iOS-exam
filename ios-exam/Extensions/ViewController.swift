//
//  ViewController.swift
//  ios-exam
//
//  Created by pharuthapol on 19/7/2567 BE.
//

import UIKit

extension UIViewController {
    @IBAction func toggleAppearance(sender: UIButton) {
        guard let window = view.window else { return }
        
        let newStyle: UIUserInterfaceStyle = window.overrideUserInterfaceStyle == .dark ? .light : .dark
        
        // Use a transition animation
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.overrideUserInterfaceStyle = newStyle
        }, completion: nil)
    }
}
