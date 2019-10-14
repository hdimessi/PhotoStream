//
//  PhotoDetailsView.swift
//  PhotoStream
//
//  Created by HDimes on 10/11/19.
//  Copyright © 2019 MindValley. All rights reserved.
//

import UIKit

class PhotoDetailsView: PhotoDetails {

    typealias DismissClosure = (_ frame: CGRect, _ sender: PhotoDetailsView) -> ()
    private let initialFrame: CGRect
    var dismissClosure: DismissClosure?

    init(frame: CGRect, fullScreen: Bool) {
        self.initialFrame = frame
        super.init(frame: .zero)
        
        self.fullScreen = fullScreen
        Bundle.main.loadNibNamed("PhotoDetailsView", owner: self, options: nil)
        setupContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func dismissPhotoDetails() {
        dismissClosure?(initialFrame, self)
    }
}
