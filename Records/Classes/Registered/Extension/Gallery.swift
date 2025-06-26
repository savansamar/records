import UIKit

extension RegisteredUserVC : UICollectionViewDelegate ,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didselect")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.userGalleryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCell.indetifier, for: indexPath) as! GalleryCell
//        cell.configure(with: UIImage(named:"Dummy")!)
//        return cell
        
        let data = viewModel.userGalleryArray[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCell.indetifier, for: indexPath) as! GalleryCell
//            cell.configure(with: data)
            cell.configure(with: UIImage(named:"Dummy")!)
         
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemsPerRow: CGFloat = 3
            let spacing: CGFloat = 8 // Match with your inter-item spacing and section insets
            let totalSpacing = (itemsPerRow - 1) * spacing
            let availableWidth = collectionView.bounds.width - totalSpacing
            let itemWidth = floor(availableWidth / itemsPerRow)

            return CGSize(width: itemWidth, height: itemWidth)
    }
}
