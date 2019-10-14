//
//  PhotoStreamViewController.swift
//  PhotoStream
//
//  Created by HDimes on 10/8/19.
//  Copyright © 2019 MindValley. All rights reserved.
//

import UIKit

class PhotoStreamViewController: UIViewController {
    
    var photos: [Photo] = []
    @IBOutlet internal weak var collectionView: UICollectionView!
    
    let repository: PhotoStreamRepository
    
    init() {
        let remoteApi: RemoteAPI
        #if TEST
        remoteApi = FakeRemoteApi()
        #else
        remoteApi = CloudRemoteApi()
        #endif
        repository = PhotoStreamRepository(remoteAPI: remoteApi)
        super.init(nibName: "PhotoStreamViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let patternImage = UIImage(named: "pattern") {
          view.backgroundColor = UIColor(patternImage: patternImage)
        }
        
        if let layout = collectionView?.collectionViewLayout as? StreamCollectionLayout {
          layout.delegate = self
        }
          
        setupCollectionView()
        loadPhotos(nil)
        
    }
    
    func setupCollectionView() {
        collectionView.register(UINib(nibName: "AnnotatedPhotoCell", bundle: nil), forCellWithReuseIdentifier: "AnnotatedPhotoCell")
        collectionView?.contentInset = UIEdgeInsets(top: 23, left: 16, bottom: 10, right: 16)
        collectionView.backgroundColor = .clear
        let refreshControl = UIRefreshControl()
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(loadPhotos(_:)), for: .valueChanged)
    }
    
    @objc
    func loadPhotos(_ sender: Any?) {
        // not enough time to implement paging feature to be honest
        let date: Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let latest = sender is UIRefreshControl || sender == nil
        if latest {
            date = Date.init(timeIntervalSinceNow: 0)
        } else if let oldestPhoto = photos.last, let oldestDate = dateFormatter.date(from:oldestPhoto.createdAt) {
            date = oldestDate
        } else {
            date = Date.init(timeIntervalSinceNow: 0)
        }
        repository.fetchPhotos(lastActivity: date,{[weak self] photos, error in
            if let photos = photos, let strongSelf = self {
                strongSelf.collectionView.refreshControl?.endRefreshing()
                strongSelf.photos = latest ? photos : strongSelf.photos + photos
                strongSelf.collectionView.reloadData()
            }
        })
    }
}

extension PhotoStreamViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnnotatedPhotoCell", for: indexPath as IndexPath) as! AnnotatedPhotoCell
        cell.setUpCell(withPhoto: photos[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)
    }
}

extension PhotoStreamViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else {return}
        let frame = view.convert(cell.frame, from:collectionView)
        
        let photoDetailView = PhotoDetailsView(frame: frame, fullScreen: true)
        photoDetailView.photo = photos[indexPath.item]
        view.addSubview(photoDetailView)
        
        photoDetailView.translatesAutoresizingMaskIntoConstraints = false
        let photoDetailsTopConstraint = photoDetailView
            .topAnchor.constraint(equalTo: view.topAnchor, constant: frame.origin.y)
        let photoDetailsHeightConstraint = photoDetailView
            .heightAnchor.constraint(equalToConstant: frame.height)
        let photoDetailsLeadingConstraint = photoDetailView
            .leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: frame.origin.x)
        let photoDetailsWidthConstraint = photoDetailView
            .widthAnchor.constraint(equalToConstant: frame.width)
        NSLayoutConstraint.activate([photoDetailsTopConstraint,
                                     photoDetailsHeightConstraint,
                                     photoDetailsLeadingConstraint,
                                     photoDetailsWidthConstraint])
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5) {
            if #available(iOS 11.0, *) {
                photoDetailsTopConstraint.constant = self.view.safeAreaInsets.top
                photoDetailsHeightConstraint.constant = self.view.frame.height - self.view.safeAreaInsets.top
            } else {
                photoDetailsTopConstraint.constant = 0
                photoDetailsHeightConstraint.constant = self.view.frame.height
            }
            photoDetailsLeadingConstraint.constant = 0
            photoDetailsWidthConstraint.constant = self.view.frame.width
            self.view.layoutIfNeeded()
        }
        let dismissClosure = { [weak self] (initialFrame: CGRect, sender: PhotoDetailsView) in
            UIView.animate(withDuration: 0.5, animations: {
                photoDetailsTopConstraint.constant = initialFrame.origin.y
                photoDetailsLeadingConstraint.constant = initialFrame.origin.x
                photoDetailsHeightConstraint.constant = initialFrame.height
                photoDetailsWidthConstraint.constant = initialFrame.width
                self?.view.layoutIfNeeded()
            }) { (bool) in
                sender.removeFromSuperview()
            }
        }
        photoDetailView.dismissClosure = dismissClosure
    }
}

extension PhotoStreamViewController: StreamCollectionLayoutDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        sizeForPhotoAtIndexPath indexPath:IndexPath) -> CGSize {
        return CGSize(width: photos[indexPath.item].width, height: photos[indexPath.item].height)
    }
}
