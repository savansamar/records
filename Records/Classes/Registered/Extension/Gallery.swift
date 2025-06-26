import UIKit

extension RegisteredUserVC : UICollectionViewDelegate ,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemsPerRow: CGFloat = 3
            let spacing: CGFloat = 8
            let sectionInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            
            let totalSpacing = sectionInsets.left + sectionInsets.right + (spacing * (itemsPerRow - 1))
            let itemWidth = (collectionView.bounds.width - totalSpacing) / itemsPerRow

            return CGSize(width: floor(itemWidth), height: floor(itemWidth)) // Square cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.userGalleryArray.count // or the number of items you want in each section
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let data = viewModel.userGalleryArray[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCell", for: indexPath) as! GalleryCell
            cell.configure(with: data)
            cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        let data = viewModel.userGalleryArray[indexPath.item]
        print("ssss \(data)")
          guard !(data.showAdd && data.url.isEmpty) else {
              print("ele")
              showImagePicker()
              return
          }
    }
}



