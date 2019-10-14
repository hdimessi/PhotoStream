//
//  AnnotatedPhotoCell.swift
//  PhotoStream
//
//  Created by HDimes on 10/8/19.
//  Copyright © 2019 MindValley. All rights reserved.
//

import UIKit


class AnnotatedPhotoCell: UICollectionViewCell {
    
    private var contentDetailView: PhotoDetails!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 6
        contentView.layer.masksToBounds = true
        contentDetailView = PhotoDetails(frame: .zero)
        contentView.addSubview(contentDetailView)
        contentDetailView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = contentDetailView.topAnchor.constraint(equalTo: contentView.topAnchor)
        let leadingConstraint = contentDetailView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        let trailingContraint = contentDetailView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        let bottomConstraint = contentDetailView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        NSLayoutConstraint.activate([topConstraint, leadingConstraint, trailingContraint, bottomConstraint])
    }
    
    func setUpCell(withPhoto photo: Photo) {
        contentDetailView.photo = photo
    }
    
}
