//
//  UIAlertController+Show.swift//  BreakingBad
//
//  Created by Thomas Woodfin on 1/12/21.
//  Copyright © 2021 Thomas Woodfin. All rights reserved.
//

import UIKit


extension UIAlertController {
    
    func show() {
        let mwindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        if let visibleViewController = mwindow?.visibleViewController() {
            DispatchQueue.main.async(execute: {
                visibleViewController.present(self, animated: true, completion: nil)
            })
        } else {
            print("Can not show AlertController As there is no visibleViewController")
        }
    }
    
}
