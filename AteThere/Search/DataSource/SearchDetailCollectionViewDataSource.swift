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
            
            if venue.photos[indexPath.row].imageState == .placeholder {
                client.getPhoto(forVenue: venue, atIndexPath: indexPath, completion: { (result) in
                    switch result {
                    case .success(let venue):
                        cell.updateCell(withImage: venue.photos[indexPath.row].image!)
                    case .failure(_):
                        return
                    }
                })
            } else {
                cell.updateCell(withImage: venue.photos[indexPath.row].image!)
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
}
