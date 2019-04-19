//
//  YZNotificationView.swift
//  YZNotificationView
//
//  Created by Yaroslav Zavyalov on 25/03/2019.
//  Copyright © 2019 Yaroslav Zavyalov. All rights reserved.
//

import UIKit

// MARK: - YZNotificationViewDelegate
public protocol YZNotificationViewDelegate: class {
    func startShowing(_ notificationView: YZNotificationView)             // when start animation to show notificaiton view
    func completeShowing(_ notificationView: YZNotificationView)          // when completed animation to show notification view
    func startHiding(_ notificationView: YZNotificationView)              // when start to hide notification view
    func completeHiding(_ notificationView: YZNotificationView)           // when completed to hide notification view
    func didTapNotificationView(_ notificationView: YZNotificationView)   // when tap OR swipe on notification view (then start to hide notification view)
}

// MARK: - YZNotificationViewType
public enum YZNotificationViewType {
    case topPosition        // top position of notificaiton view
    case bottomPosition     // bottom position os notification view
}

// MARK: - YZNotificationViewConfig
public struct YZNotificationViewConfig {
    public var imageViewBackgroundColor: UIColor = .white                   // imageView background color
    public var textColor: UIColor = .white                                  // text color
    public var textAlignment: NSTextAlignment = .left                       // text alignment
    public var textFont: UIFont = UIFont.systemFont(ofSize: 15)             // text font
    public var isAutoClose: Bool = true                                     // is auto close
    public var animationDuration: TimeInterval = TimeInterval(0.25)         // duration for animateion to show or hide notification view
    public var displayDuration: TimeInterval = TimeInterval(2.0)            // duration fow showing notification view
    public var defaultOffset: CGFloat = 6                                   // offset from top, botom, left and right
    
    public init() { }
}

// MARK: - YZNotificationView
public class YZNotificationView: UIView {
    
    public var id: String?  //Unique ID for notification view
    
    //Public propertis
    public var text:   String?                                      //Text for notification view, optional
    public var image:  UIImage?                                     //Image for notification view (on the left side), optional
    public var position: YZNotificationViewType = .topPosition      //Position of notification view (top or bottom side)
    public var config: YZNotificationViewConfig!                    //Configuration for notification view: text color, text size etc.
    public weak var delegate: YZNotificationViewDelegate?           //Delegate for showing/hiding notification view
    
    //Private properties
    private var tap:         UITapGestureRecognizer?
    private var swipeToUp:   UISwipeGestureRecognizer?
    private var swipeToDown: UISwipeGestureRecognizer?
    
    private var label:     UILabel!
    private var imageView: UIImageView!
    
    private var timer: Timer?

    //Init
    public init(text: String?, image: UIImage?, position: YZNotificationViewType, configuration: YZNotificationViewConfig = YZNotificationViewConfig()) {
        super.init(frame: .zero)
        
        self.id = UUID().uuidString
        self.text = text
        self.image = image
        self.position = position
        self.config = configuration
        
        self.createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Publics
extension YZNotificationView {
    
    //Show notification view
    public func show(_ animation: Bool) {
        self.addToWindow()
        self.startAnimateion(animation, isShowing: true)
    }
    
    //Hide notification view
    public func hide(_ animation: Bool) {
        self.startAnimateion(animation, isShowing: false)
    }
}

// MARK: - Animation
extension YZNotificationView {
    
    //Start animateion to show OR hide
    private func startAnimateion(_ animation: Bool, isShowing: Bool) {
        if isShowing {
            self.delegate?.startShowing(self)
        } else {
            self.delegate?.startHiding(self)
        }

        let statusBarHeight = self.position == .topPosition ? UIApplication.shared.statusBarFrame.size.height : 0
        let navigationBarHeight = statusBarHeight + UINavigationController().navigationBar.frame.size.height
        let tabBarHeight = UITabBarController().tabBar.frame.size.height
        
        UIView.animate(withDuration: (animation ? self.config.animationDuration : 0), animations: {
            if isShowing {
                if self.position == .topPosition {
                    self.frame.origin.y += navigationBarHeight
                } else {
                    self.frame.origin.y -= tabBarHeight
                }
            } else {
                if self.position == .topPosition {
                    self.frame.origin.y -= navigationBarHeight
                } else {
                    self.frame.origin.y += tabBarHeight
                }
            }
        }) { (completion) in
            if completion {
                self.completeAnimation(isShowing: isShowing)
            }
        }
    }
    
    //Completed animateion to show OR hide
    private func completeAnimation(isShowing: Bool) {
        if isShowing {
            if self.config.isAutoClose {
                self.startTimer()
            }
            
            self.delegate?.completeShowing(self)
        } else {
            self.stopTimer()
            self.removeFromWindow()
            
            self.delegate?.completeHiding(self)
        }
    }
}

// MARK: - Privates
extension YZNotificationView {
    
    //Create UI
    private func createUI() {
        self.createSubViews()
        self.makeConstraints()
        self.addGestureRecognizer()
    }
    
    //Create view
    private func createSubViews() {
        self.backgroundColor = .darkGray
        
        self.label = UILabel()
        self.label.numberOfLines = 0
        self.label.textColor = self.config.textColor
        self.label.textAlignment = self.config.textAlignment
        self.label.font = self.config.textFont
        self.label.text = self.text
        
        self.imageView = UIImageView(image: self.image)
        self.imageView.backgroundColor = self.config.imageViewBackgroundColor
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.cornerRadius = (UINavigationController().navigationBar.frame.size.height - self.config.defaultOffset) / 2.0
        
        self.tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        
        if self.position == .topPosition {
            self.swipeToUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeToUpAction))
            self.swipeToUp?.direction = .up
        }
        
        if self.position == .bottomPosition {
            self.swipeToDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeToDownAction))
            self.swipeToDown?.direction = .down
        }
    }
    
    //Create constraints
    private func makeConstraints() {        
        self.addSubview(self.label)
        if self.image != nil {
            self.addSubview(self.imageView)
        }
        
        let leftView = self.image == nil ? self : self.imageView
        
        if self.image != nil {
            self.imageView.translatesAutoresizingMaskIntoConstraints = false
            self.createConstraint(view: self.imageView, atribute: .top,    toView: self,           toAtribute: .top,    constant: self.getStatusBarHeight()).isActive = true
            self.createConstraint(view: self.imageView, atribute: .bottom, toView: self,           toAtribute: .bottom, constant: -self.config.defaultOffset).isActive = true
            self.createConstraint(view: self.imageView, atribute: .left,   toView: self,           toAtribute: .left,   constant: self.config.defaultOffset).isActive = true
            self.createConstraint(view: self.imageView, atribute: .width,  toView: self.imageView, toAtribute: .height).isActive = true
        }
        
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.createConstraint(view: self.label, atribute: .bottom, toView: self,      toAtribute: .bottom).isActive = true
        self.createConstraint(view: self.label, atribute: .top,    toView: self,      toAtribute: .top,   constant: self.getStatusBarHeight()).isActive = true
        self.createConstraint(view: self.label, atribute: .right,  toView: self,      toAtribute: .right, constant: -self.config.defaultOffset).isActive = true
        self.createConstraint(view: self.label, atribute: .left,    toView: leftView, toAtribute: .left,  constant: self.config.defaultOffset).isActive = true
    }
    
    //Get status bar height
    private func getStatusBarHeight() -> CGFloat {
        let statusBarHeight = self.position == .topPosition ? UIApplication.shared.statusBarFrame.size.height : 0
        return statusBarHeight
    }
    
    //Get nevigation bar height
    private func getNavigationBarHeight() -> CGFloat {
        let navigationBarHeight = self.getStatusBarHeight() + UINavigationController().navigationBar.frame.size.height
        return navigationBarHeight
    }
    
    //Get tab bar height
    private func getTabBarHeight() -> CGFloat {
        let tabBarHeight = UITabBarController().tabBar.frame.size.height
        return tabBarHeight
    }
    
    //Add self view to window
    private func addToWindow() {
        guard let window = UIApplication.shared.delegate?.window else {
            return
        }
        
        let selfHeight = self.position == .topPosition ? self.getNavigationBarHeight() : self.getTabBarHeight()
        let selfPosition: NSLayoutConstraint.Attribute = self.position == .topPosition ? .top : .bottom
        
        window?.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.createConstraint(view: self, atribute: selfPosition, toView: window, toAtribute: selfPosition).isActive = true
        self.createConstraint(view: self, atribute: .left,   toView: window, toAtribute: .left).isActive = true
        self.createConstraint(view: self, atribute: .right,  toView: window, toAtribute: .right).isActive = true
        self.createConstraint(view: self, atribute: .height, constant: selfHeight).isActive = true
    }
    
    //Remove self view from superview
    private func removeFromWindow() {
        self.label.removeFromSuperview()
        self.imageView.removeFromSuperview()
        self.removeFromSuperview()
    }
    
    //Add gesture recognizer
    private func addGestureRecognizer() {
        if let tap = self.tap {
            self.addGestureRecognizer(tap)
        }
        
        if let swipeToUp = self.swipeToUp {
            self.addGestureRecognizer(swipeToUp)
        }
        
        if let swipeToDown = self.swipeToDown {
            self.addGestureRecognizer(swipeToDown)
        }
    }
    
    //Make constraint
    private func createConstraint(view: UIView, atribute: NSLayoutConstraint.Attribute, related: NSLayoutConstraint.Relation = .equal, toView: UIView? = nil, toAtribute: NSLayoutConstraint.Attribute = .notAnAttribute, multiplier: CGFloat = 1, constant: CGFloat = 0) ->  NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: view, attribute: atribute, relatedBy: related, toItem: toView, attribute: toAtribute, multiplier: multiplier, constant: constant)
        return constraint
    }
}

extension YZNotificationView {
    
    //Start timer to hide notification view
    private func startTimer() {
        let timeInterval = self.config.displayDuration + self.config.animationDuration
        self.timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(timerTickAction), userInfo: nil, repeats: false)
    }
    
    //Stop timer
    private func stopTimer() {
        if let timer = self.timer {
            timer.invalidate()
            self.timer = nil
        }
    }
    
    //When timer finished to hide notification view
    @objc private func timerTickAction() {
        self.hide(true)
    }
}

// MARK: - Actions
extension YZNotificationView {
    
    //tap to notification view
    @objc private func tapAction() {
        self.delegate?.didTapNotificationView(self)
        
        if self.tap != nil {
            self.tap = nil
        }
        
        self.hide(true)
    }
    
    //Swipe up on notification view
    @objc private func swipeToUpAction() {
        self.delegate?.didTapNotificationView(self)

        if self.position == .topPosition {
            self.hide(true)
        }
    }
    
    //Swipe dwon on notification view
    @objc private func swipeToDownAction() {
        self.delegate?.didTapNotificationView(self)

        if self.position == .bottomPosition {
            self.hide(true)
        }
    }
}
