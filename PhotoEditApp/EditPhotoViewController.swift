//
//  EditPhotoViewController.swift
//  PhotoEditApp
//
//  Created by 黃昌齊 on 2021/4/17.
//

import UIKit
import CoreImage.CIFilterBuiltins

class EditPhotoViewController: UIViewController {
    
    @IBOutlet weak var editPhotoImageView: UIImageView!
    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var photoSizeRatio: UISegmentedControl!
    @IBOutlet weak var filterScrollView: UIScrollView!
    @IBOutlet weak var sizeStackView: UIStackView!
    @IBOutlet var filterButtons: [UIButton]!
    @IBOutlet weak var lightControlStackView: UIStackView!
    @IBOutlet weak var lightControlSlider: UISlider!
    @IBOutlet var lightControlButton: [UIButton]!
    
    var selectPhoto: EditPhoto!
    let aDegree = CGFloat.pi / 180
    var leftTimes = 1
    var mirrorTimes = -1
    var filterMode = kCIInputBrightnessKey
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var ratio: CGFloat = 0.0
        
        if let image = selectPhoto.editPhoto {
            ratio = image.size.width / image.size.height
            
            editPhotoImageView.translatesAutoresizingMaskIntoConstraints = false
            editPhotoImageView.image = image
            editPhotoImageView.contentMode = .scaleAspectFill
            
            NSLayoutConstraint.activate([
                editPhotoImageView.centerXAnchor.constraint(equalTo: photoView.centerXAnchor),
                editPhotoImageView.centerYAnchor.constraint(equalTo: photoView.centerYAnchor),
                editPhotoImageView.leadingAnchor.constraint(greaterThanOrEqualTo: photoView.leadingAnchor),
                editPhotoImageView.trailingAnchor.constraint(lessThanOrEqualTo: photoView.trailingAnchor),
                editPhotoImageView.heightAnchor.constraint(equalTo: editPhotoImageView.widthAnchor, multiplier: 1 / ratio),
                photoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                photoView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
            ])
        }
        photoSizeRatio.isHidden = true
        filterScrollView.isHidden = true
        lightControlStackView.isHidden = true
        lightControlSlider.isHidden = true
    }
    //圖片左轉
    @IBAction func rotateLeftButton(_ sender: Any) {
        photoView.transform = photoView.transform.concatenating(CGAffineTransform.identity.rotated(by: aDegree * -90))
        photoSizeRatio.isHidden = true
        filterScrollView.isHidden = true
        lightControlStackView.isHidden = true
        lightControlSlider.isHidden = true
    }
    //圖片鏡像
    @IBAction func mirrorButton(_ sender: Any) {
        photoView.transform = photoView.transform.concatenating(CGAffineTransform.identity.scaledBy(x: -1, y: 1))
        photoSizeRatio.isHidden = true
        filterScrollView.isHidden = true
        lightControlStackView.isHidden = true
        lightControlSlider.isHidden = true
    }
    //圖片比例調整
    @IBAction func photoSizeRatioButton(_ sender: Any) {
        photoSizeRatio.isHidden = false
        filterScrollView.isHidden = true
        lightControlStackView.isHidden = true
        lightControlSlider.isHidden = true
    }
    //尺寸相關設定鍵
    @IBAction func sizeSettingButton(_ sender: Any) {
        sizeStackView.isHidden = false
        photoSizeRatio.isHidden = true
        filterScrollView.isHidden = true
        lightControlStackView.isHidden = true
        lightControlSlider.isHidden = true
    }
    //濾鏡設定鍵
    @IBAction func filterSettingButton(_ sender: Any) {
        sizeStackView.isHidden = true
        photoSizeRatio.isHidden = true
        filterScrollView.isHidden = false
        lightControlStackView.isHidden = true
        lightControlSlider.isHidden = true
    }
    //濾鏡選擇（全部濾鏡Button連到以下action）
    @IBAction func filterChoose(_ sender: UIButton) {
        let index = filterButtons.firstIndex(of: sender)
        print(index) //確認點擊的濾鏡button有連結到
        
        switch index {
        case 0:
            editPhotoImageView.image = selectPhoto.editPhoto
        case 1:
            filterChange(filterName: .CIPhotoEffectInstant)
        case 2:
            filterChange(filterName: .CISepiaTone)
        case 3:
            filterChange(filterName: .CIPhotoEffectMono)
        case 4:
            filterChange(filterName: .CIPhotoEffectProcess)
        case 5:
            filterChange(filterName: .CISRGBToneCurveToLinear)
        default:
            break
        }
    }
    //光亮設定鍵
    @IBAction func lightSettingButton(_ sender: Any) {
        sizeStackView.isHidden = true
        photoSizeRatio.isHidden = true
        filterScrollView.isHidden = true
        lightControlStackView.isHidden = false
        lightControlSlider.isHidden = false
    }
    //光亮參數設定
    @IBAction func valueChanged(_ sender: UISlider) {
        let ciImage = CIImage(image: selectPhoto.editPhoto!)
        let filter = CIFilter(name: "CIColorControls")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(sender.value, forKey: filterMode)
        
        if let output = filter?.outputImage {
            let filterImage = UIImage(ciImage: output)
            editPhotoImageView.image = filterImage
        }
    }
    //光亮對比設定鍵
    @IBAction func lightSetting(_ sender: UIButton) {
        let index = lightControlButton.firstIndex(of: sender)
        print(index)
        
        switch index {
        case 0:
            lightControlSlider.maximumValue = 1
            lightControlSlider.value = 0
            lightControlSlider.minimumValue = -1
            filterMode = kCIInputBrightnessKey
        case 1:
            lightControlSlider.maximumValue = 2
            lightControlSlider.value = 1
            lightControlSlider.minimumValue = 0
            filterMode = kCIInputContrastKey
        case 2:
            lightControlSlider.maximumValue = 1
            lightControlSlider.value = 1
            lightControlSlider.minimumValue = 0
            filterMode = kCIInputSaturationKey
        default:
            break
        }
    }
    
    //改變照片比例
    @IBAction func changePhotoRatio(_ sender: Any) {
        
        var width: CGFloat = 375
        var height: CGFloat = 280
        
        switch photoSizeRatio.selectedSegmentIndex {
        case 0:
            editPhotoImageView.image = selectPhoto.editPhoto
        case 1:
            //width = height * 16 / 9
            height = width * 9 / 16
        case 2:
            height = width
        default:
            break
        }
        editPhotoImageView.bounds.size = CGSize(width: width, height: height)
        photoView.bounds.size = CGSize(width: editPhotoImageView.bounds.width, height: editPhotoImageView.bounds.height)
    }
    //將修改完的圖片儲存
    @IBAction func share(_ sender: Any) {
        let renderer = UIGraphicsImageRenderer(size: photoView.bounds.size)
        let image = renderer.image(actions: { (context) in
            photoView.drawHierarchy(in: photoView.bounds, afterScreenUpdates: true)
        })
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        present(activityViewController, animated: true, completion: nil)
        photoArray.append(image)
        navigationController?.popToRootViewController(animated: true)
    }
    
    //濾鏡func
    func filterChange(filterName: filterEffect) {
        let ciImage = CIImage(image: selectPhoto.editPhoto!)
        let filter = CIFilter(name: filterName.rawValue)
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        if filterName == .CISepiaTone {
            filter?.setValue(1, forKey: kCIInputIntensityKey)
        }
        
        if let output = filter?.outputImage {
            let filterImage = UIImage(ciImage: output)
            editPhotoImageView.image = filterImage
        }
    }
    
}
