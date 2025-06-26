import UIKit
import PhotosUI

extension RegisteredUserVC: PHPickerViewControllerDelegate {
    
    func saveImageToDocuments(image: UIImage) -> (url: String, fileName: String)? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }

        let fileName = UUID().uuidString + ".jpg"
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileName)

        do {
            try data.write(to: fileURL)
            return (url: fileURL.absoluteString, fileName: fileName)
        } catch {
            print("❌ Failed to save image:", error)
            return nil
        }
    }
    
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        let itemProviders = results.map { $0.itemProvider }

        for provider in itemProviders {
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    guard let self = self,
                          let uiImage = image as? UIImage,
                          let savedURL = self.saveImageToDocuments(image: uiImage)
                    else {
                        return
                    }

                    let newItem = UserGallery(url: savedURL.url, showAdd: false, fileName: savedURL.fileName)

                    DispatchQueue.main.async {
                        self.viewModel.userGalleryArray.insert(newItem, at: 1)
                        self.galleryCollectionView.reloadData()
                    }
                }
            }
        }
    }
}



//extension RegisteredUserVC: GalleryCellDelegate {
//    func didTapClose(in cell: GalleryCellDelegate) {
//        if let indexPath = galleryCollectionView.indexPath(for: cell) {
//              print("❌ Remove image at index \(indexPath.item)")
//              viewModel.userGalleryArray.remove(at: indexPath.item)
//              galleryCollectionView.reloadData()
//          }
//      }
//}


extension RegisteredUserVC: GalleryCellDelegate {
    func didTapClose(in cell: GalleryCell) {
        guard let indexPath = galleryCollectionView.indexPath(for: cell) else { return }
        print("❌ Remove image at index \(indexPath.item)")
        viewModel.userGalleryArray.remove(at: indexPath.item)
        galleryCollectionView.deleteItems(at: [indexPath])
    }
}
