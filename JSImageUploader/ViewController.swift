//
//  ViewController.swift
//  JSImageUploader
//
//  Created by LJS on 2017/10/12.
//  Copyright © 2017年 Ljs. All rights reserved.
//

import UIKit

public let ScreenWidth: CGFloat = UIScreen.main.bounds.size.width
public let ScreenHeight: CGFloat = UIScreen.main.bounds.size.height


class ViewController: UIViewController {
    
    var collectionView : UICollectionView?
    
    var arrayData : [JSPhotoModel] = [JSPhotoModel]()
    
    var imagePickerController : UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView = UICollectionView(frame: self.view.bounds , collectionViewLayout: UICollectionViewFlowLayout())
        view.addSubview(collectionView!)

        self.collectionView?.delegate = self
        self.collectionView?.dataSource   = self
        self.collectionView?.backgroundColor = UIColor.red
        self.collectionView?.register(HCellPhotoUpload.self, forCellWithReuseIdentifier: "CellID.photoUpload")
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func uploadAction(_ sender: Any) {
        
        initImagePickerController()
        
    }
    
}

extension ViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    
    // 定义每个Item 的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return  CGSize(width: ScreenWidth/4-10, height: ScreenWidth/4-10)
    }
    
    // 定义每个UICollectionView 的 margin
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 5, 5,5)
    }
    
    // 定义每个UICollectionView 纵向的间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"CellID.photoUpload", for: indexPath) as! HCellPhotoUpload
        
        let model = arrayData[indexPath.row]
        cell.setModel(model)
        cell.uploadFinish = { [weak self] in
            //上传完毕
           // self?.validateModel()
        }
        
        return cell
    }
    
}

extension ViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    func initImagePickerController()
    {
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        // 设置是否可以管理已经存在的图片或者视频
        imagePickerController.allowsEditing = true
        
        imagePickerController.sourceType = .photoLibrary
        //判断是否支持相册
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            present(imagePickerController, animated: true, completion:nil)
        }
    }

    //MARK:- UIImagePickerControllerDelegate
    func imagePickerController(_ picker:UIImagePickerController, didFinishPickingMediaWithInfo info: [String :Any]){
        
        let type:String = (info[UIImagePickerControllerMediaType]as!String)
        //当选择的类型是图片
        if type == "public.image"
        {
            let img = info[UIImagePickerControllerOriginalImage] as? UIImage
            let photo =  JSPhotoModel()
            photo.imageInfo = img
            photo.imageKey = "123\(Date.timeIntervalSinceReferenceDate)"
            photo.uploadImage()
            arrayData.append(photo)
            self.collectionView?.reloadData()
            picker.dismiss(animated:true, completion:nil)
        }
    }
    func imagePickerControllerDidCancel(_ picker:UIImagePickerController){
        picker.dismiss(animated:true, completion:nil)
    }
    
}
