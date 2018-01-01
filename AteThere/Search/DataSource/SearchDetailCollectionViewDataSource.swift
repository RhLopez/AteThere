//
//  SearchDetailCollectionViewDataSource.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/13/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation
import UIKit

class SearchDetailCollectionViewDataSource: NSObject {
    private var venue: SearchVenue
    private var client: FoursquareAPIClient
    
    init(venue: SearchVenue, client: FoursquareAPIClient) {
        self.venue = venue
        self.client = client
    }
}

// MARK: - UICollectionViewDataSource
extension SearchDetailCollectionViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return venue.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchDetailCollectionViewCell.identifier, for: indexPath) as? SearchDetailCollectionViewCell {
            cell.venueImageView.image = #imageLiteral(resourceName: "PlaceHolder")
            let imageState = venue.photos[indexPath.row].imageState
            
            switch imageState {
            case .downloaded(let indexedImage):
                if indexPath == indexedImage.indexPath {
                    cell.updateCell(withImage: indexedImage.image)
                }
            case .placeholder:
                downloadImage(for: cell, at: indexPath)
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

// MARK: - Helper
extension SearchDetailCollectionViewDataSource {
    func update(withPhotos photos: [SearchVenuePhoto]) {
        self.venue.photos = photos
    }
    
    func downloadImage(for cell: SearchDetailCollectionViewCell, at indexPath: IndexPath) {
        client.getPhoto(forVenue: venue, atIndexPath: indexPath, completion: { [weak cell] (result) in
            switch result {
            case .success(let indexedImage):
                let imageIndex = indexedImage.indexPath
                if indexPath == imageIndex {
                    cell?.updateCell(withImage: indexedImage.image)
                }
            case .failure(_):
                return
            }
        })
    }
}
