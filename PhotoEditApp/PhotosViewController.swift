//
//  PhotosViewController.swift
//  PhotoEditApp
//
//  Created by 黃昌齊 on 2021/4/15.
//

import UIKit

var photoArray: Array<UIImage> = []

class PhotosViewController: UIViewController {
    
    var image: UIImage?
    
    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    //儲存圖片後更新cell裡面照片
    override func viewWillAppear(_ animated: Bool) {
        photosCollectionView.reloadData()
    }
    //選照片
    @IBAction func choosePhoto(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Photo", message: "Please choose the path.", preferredStyle: .actionSheet)
        
        let sources: [(name: String, type: UIImagePickerController.SourceType)] = [
            ("Album", .photoLibrary),
            ("Camera", .camera)
        ]
        
        for source in sources {
            let action = UIAlertAction(title: source.name, style: .default) { _ in
                self.selectPhoto()
            }
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    //用segue傳照片到第二頁
    @IBSegueAction func photoDetail(_ coder: NSCoder) -> EditPhotoViewController? {
        let pageTwoController = EditPhotoViewController(coder: coder)
        pageTwoController?.selectPhoto = EditPhoto(editPhoto: image)
        return pageTwoController
    }
    
}

extension PhotosViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func selectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        image = info[.originalImage] as? UIImage
        dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "ToNextPageSegue", sender: nil)
    }

}

extension PhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotosCollectionViewCell
        cell.cellImageView.image = photoArray[indexPath.row]
        return cell
    }
    
}


