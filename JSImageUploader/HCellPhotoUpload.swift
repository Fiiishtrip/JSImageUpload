//
//  HCellPhotoUpload.swift
//  Hunter
//
//  Created by LJS on 2017/4/27.
//  Copyright © 2017年 fishtrip. All rights reserved.
//

import UIKit

class HCellPhotoUpload: UICollectionViewCell {
    
    var uploadFinish : (()-> Void)?
    
    lazy var photoImage:UIImageView = {
        var photoImage = UIImageView()
        return photoImage
    }()
    
    
    var processView : HViewProgress?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(photoImage)
    }
    
    func configureProgress() {
        
        if let _ = processView {
            return
        }
        
        let view = HViewProgress()
        addSubview(view)
        processView = view
        processView?.isHidden = true
        processView?.frame = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModel(_ model : JSPhotoUploadProtocol) {
        var photoModel = model
        freshImage(model)
        setProgressStatue(model)
        photoModel.updateUI = { [weak self] (process) in
            
            DispatchQueue.main.async {
                 self?.processView?.progress = CGFloat(process)
            }

        }
        
        photoModel.statueChange = { [weak self] in
            
            DispatchQueue.main.async {
                self?.setProgressStatue(photoModel)
                self?.finishUpload(photoModel)
            }
        }        
    }
    
    
    func setProgressStatue(_ model : JSPhotoUploadProtocol) {
        configureProgress()
        processView?.isHidden = false
        switch model.downStatus {
        case .wait:
            processView?.viewType = .wait
        case .uploading:
            processView?.viewType = .loading
        case .pause:
            processView?.viewType = .pause
        case .faild:
            processView?.viewType = .error
        case .finish:
            processView?.isHidden = true
        }
    }
    
    func finishUpload(_ model : JSPhotoUploadProtocol)  {
        switch model.downStatus {
            case .finish:
                if let block = uploadFinish {
                    block()
                }
            default :
             break
        }
    }
    
    func freshImage(_ model : JSPhotoUploadProtocol) {
        photoImage.image = model.imageInfo
        photoImage.frame = self.bounds
        
    }
    

    
}
