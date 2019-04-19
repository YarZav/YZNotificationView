//
//  YZNotificationManager.swift
//  YZNotificationView
//
//  Created by Yaroslav Zavyalov on 30/03/2019.
//  Copyright © 2019 Yaroslav Zavyalov. All rights reserved.
//

import UIKit

// MARK: - YZNotificationManager
public class YZNotificationManager {
    
    //Properties public
    public static let sharedInstance = YZNotificationManager()              //Singleton for manager
    public var delayDuration: TimeInterval = TimeInterval(0.25)             //Delay time between showing notification view
    public weak var delegate: YZNotificationViewDelegate?                   //Delegate for showing/hiding notification view
    
    //Propeirtes privates
    private var queue = [YZNotificationView]()
    private var isShowing: Bool = false
    
    //Init
    private init() { }
}

// MARK: - Publics
extension YZNotificationManager {
    
    //Show notification view
    public func showNotifiationView(_ notificationView: YZNotificationView) {
        self.queue.append(notificationView)
        
        if !self.isShowing {
            self.isShowing = true
            notificationView.delegate = self
            notificationView.show(true)
        }
    }
}

// MARK: - YZNotificationViewDelegate
extension YZNotificationManager: YZNotificationViewDelegate {
    
    public func startShowing(_ notificationView: YZNotificationView) {
        self.delegate?.startShowing(notificationView)
    }
    
    public func completeShowing(_ notificationView: YZNotificationView) {
        self.delegate?.completeShowing(notificationView)
    }
    
    public func startHiding(_ notificationView: YZNotificationView) {
        self.delegate?.startHiding(notificationView)
    }
    
    public func completeHiding(_ notificationView: YZNotificationView) {
        self.delegate?.completeHiding(notificationView)
        self.queue.removeAll { $0.id == notificationView.id }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + self.delayDuration) {
            self.isShowing = false
            
            if let notificationView = self.queue.first {
                self.showNotifiationView(notificationView)
            }
        }
    }
    
    public func didTapNotificationView(_ notificationView: YZNotificationView) {
        self.delegate?.didTapNotificationView(notificationView)
    }
}
