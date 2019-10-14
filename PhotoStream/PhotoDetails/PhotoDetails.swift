
//
//  PhotoDetails.swift
//  PhotoStream
//
//  Created by HDimes on 10/10/19.
//  Copyright © 2019 MindValley. All rights reserved.
//

import UIKit
import MVNetworking

class PhotoDetails: UIView {

    static let kCONTENT_XIB_NAME = "PhotoDetails"
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var backgroundHeader: UIView!
    @IBOutlet private weak var likeView: UIView!
    @IBOutlet private weak var contentView: UIView!

    var ripple = Ripples()
    
    var photoRequest: DataRequest?
    var profilePhotoRequest: DataRequest?
    
    var fullScreen = false
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        Bundle.main.loadNibNamed(PhotoDetails.kCONTENT_XIB_NAME, owner: self, options: nil)
        setupContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContentView() {
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = contentView.leadingAnchor.constraint(equalTo: leadingAnchor)
        let trailing = contentView.trailingAnchor.constraint(equalTo: trailingAnchor)
        let top = contentView.topAnchor.constraint(equalTo: topAnchor)
        let bottom = contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleLike(sender:)))
        likeView.addGestureRecognizer(tapGesture)
        profileImageView.layer.masksToBounds = true
        profileImageView.addObserver(self, forKeyPath: "center", options: .new, context: nil)

    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        profileImageView.layer.cornerRadius = (profileImageView.frame.height / 2)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        ripple.position = CGPoint(x: bounds.size.width / 2.0, y: bounds.size.height / 2.0)
        likeView.layer.cornerRadius = likeView.frame.height / 2.0
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        profileImageView.layer.masksToBounds = true
        likeView.layer.cornerRadius = likeView.frame.height / 2.0
    }
    
    var photo: Photo! {
        didSet {
            if let photo = photo {
                let color = UIColor(hexString: photo.colorHex)
                imageView.image = UIImage(named: "placeholder_icon")
                imageView.contentMode = .center
                stopLoader()
                
                photoRequest?.cancelRequest()
                if let url = URL(string: fullScreen ? photo.urls.regular : photo.urls.small) {
                    startLoader(color: color)
                    photoRequest = DataRequest.getImage(atUrl: url, withCompletionHandler: { (image, error) in
                        if let image = image {
                            self.imageView.contentMode = .scaleAspectFill
                            self.imageView.image = image
                        }
                        self.stopLoader()
                    })
                }
                
                
                nameLabel.text = photo.owner.name
                backgroundHeader.backgroundColor = color
                
                profilePhotoRequest?.cancelRequest()
                if let url = URL(string: fullScreen ? photo.owner.profileImage.large : photo.owner.profileImage.small) {
                    profilePhotoRequest = DataRequest.getImage(atUrl: url, withCompletionHandler: { (image, error) in
                        if let image = image {
                            self.profileImageView.image = image
                        }
                    })
                }
                
                let cgColor = color.cgColor
                let rbgCGColor = cgColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil)
                
                guard let components = rbgCGColor?.components else {
                    return
                }
                guard components.count >= 3 else {
                    return
                }
                let brightness = Float(((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000)
                nameLabel.textColor = brightness > 0.5 ? .black : .white
                
                guard let likeImageView = likeView.viewWithTag(5) as? UIImageView else {return}
                likeImageView.image = photo.likedBy ? UIImage(named: "liked") : UIImage(named:"unliked")
                likeView.tag = photo.likedBy ? 3 : 2
            }
        }
    }
    
    func startLoader(color: UIColor) {
        ripple.removeFromSuperlayer()
        ripple = Ripples()
        ripple.rippleCount = 5
        ripple.backgroundColor = color.cgColor
        layer.addSublayer(ripple)
        ripple.start()
    }
    
    func stopLoader() {
        ripple.stop()
        ripple.removeFromSuperlayer()
    }
    
    @objc
    func toggleLike(sender: UITapGestureRecognizer) {
        guard let likeImageView = likeView.viewWithTag(5) as? UIImageView else {return}
        likeImageView.image = likeView.tag == 2 ? UIImage(named: "liked") : UIImage(named:"unliked")
        likeView.tag = likeView.tag == 2 ? 3 : 2
        shake(view: likeImageView, duration: 0.8)
    }
    
    func shake(view: UIView, duration: CFTimeInterval) {
        let translation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        translation.timingFunction = CAMediaTimingFunction(name: .linear)
        translation.values = [-5, 5, -5, 5, -3, 3, -2, 2, 0]
        let rotation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotation.values = [-5, 5, -5, 5, -3, 3, -2, 2, 0].map {
            ( degrees: Double) -> Double in
            let radians: Double = (.pi * degrees) / 180.0
            return radians
        }
        let shakeGroup: CAAnimationGroup = CAAnimationGroup()
        shakeGroup.animations = [translation, rotation]
        shakeGroup.duration = duration
            
        view.layer.add(shakeGroup, forKey: "shakeIt")
    }
    
    deinit {
        profileImageView.removeObserver(self, forKeyPath: "center")
    }
}
