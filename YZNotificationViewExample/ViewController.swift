//
//  ViewController.swift
//  YZNotificationViewExample
//
//  Created by admin on 29.03.2019.
//  Copyright © 2019 Yaroslav Zavyalov. All rights reserved.
//

import UIKit
import YZNotificationView

// MARK: - ViewController
class ViewController: UIViewController {
    
    //This is manager for showing notification view's
    private let notificationManager = YZNotificationManager.sharedInstance

    //Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TestController"
        self.view.backgroundColor = .lightGray

        self.addTabBar()
        self.addButtons()
        
        //Subscirbe to delegate for receive delegate's methods of showing/hiding notification view's
        self.notificationManager.delegate = self
    }
    
    private func addTabBar() {
        let tabBar = UITabBar()
        self.view.addSubview(tabBar)
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: tabBar, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tabBar, attribute: .left,   relatedBy: .equal, toItem: self.view, attribute: .left,   multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tabBar, attribute: .right,  relatedBy: .equal, toItem: self.view, attribute: .right,  multiplier: 1, constant: 0).isActive = true
    }
    
    private func addButtons() {
        let showTopButton = UIButton(type: .custom)
        showTopButton.setTitle("ShowTopNotificationView", for: .normal)
        showTopButton.addTarget(self, action: #selector(showTopNotificationView), for: .touchUpInside)
        
        self.view.addSubview(showTopButton)
        showTopButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: showTopButton, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 150).isActive = true
        NSLayoutConstraint(item: showTopButton, attribute: .centerX,   relatedBy: .equal, toItem: self.view, attribute: .centerX,   multiplier: 1, constant: 0).isActive = true
        
        let showBottomButton = UIButton(type: .custom)
        showBottomButton.setTitle("ShowBottomNotificationView", for: .normal)
        showBottomButton.addTarget(self, action: #selector(showBottomNotificationView), for: .touchUpInside)
        
        self.view.addSubview(showBottomButton)
        showBottomButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: showBottomButton, attribute: .top, relatedBy: .equal, toItem: showTopButton, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: showBottomButton, attribute: .centerX,   relatedBy: .equal, toItem: self.view, attribute: .centerX,   multiplier: 1, constant: 0).isActive = true
    }
}

// MARK: - Actions
extension ViewController {
    
    @objc private func showTopNotificationView() {
        let notificationView = YZNotificationView(text: "Two line \ntext", image: nil, position: .topPosition)
        self.notificationManager.showNotifiationView(notificationView)
    }
    
    @objc private func showBottomNotificationView() {
        let notificationView = YZNotificationView(text: "Two line \ntext", image: nil, position: .bottomPosition)
        self.notificationManager.showNotifiationView(notificationView)
    }
}

// MARK: - YZNotificationViewDelegate
extension ViewController: YZNotificationViewDelegate {
    
    func startShowing(_ notificationView: YZNotificationView) {
        if let id = notificationView.id {
            print("Start showing notification: \(id)")
        }
    }
    
    func completeShowing(_ notificationView: YZNotificationView) {
        if let id = notificationView.id {
            print("Complete shwoing notification: \(id)")
        }
    }
    
    func startHiding(_ notificationView: YZNotificationView) {
        if let id = notificationView.id {
            print("Start hiding notification: \(id)")
        }
    }
    
    func completeHiding(_ notificationView: YZNotificationView) {
        if let id = notificationView.id {
            print("Complete hiding notification: \(id)")
        }
    }
    
    func didTapNotificationView(_ notificationView: YZNotificationView) {
        if let id = notificationView.id {
            print("Did tap notification: \(id)")
        }
    }
}

