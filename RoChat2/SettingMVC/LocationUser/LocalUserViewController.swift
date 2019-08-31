//
//  LocalUserViewController.swift
//  RoChat2
//
//  Created by rolodestar on 2019/8/23.
//  Copyright © 2019 Rolodestar Studio. All rights reserved.
//

import UIKit

class LocalUserViewController: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    
    let picker = UIImagePickerController()
    @IBOutlet weak var cUserName: UITextField!
    @IBOutlet weak var cUserPhoto: UIImageView!
    @IBOutlet weak var cUserUUID: UILabel!
    
    @IBOutlet weak var cIpAddress: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        cUserPhoto.contentMode = .scaleAspectFit
        cUserName.text = appDelegate.setting.userInfo.name
        cUserUUID.text = "用户Mac地址:" + appDelegate.setting.userInfo.macAddress
        cIpAddress.text = "本机IP地址：" + appDelegate.setting.userInfo.ipAddress
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = .photoLibrary
        if appDelegate.setting.userInfo.photo.isEmpty{
            cUserPhoto.image = UIImage(named: "1")
        } else{
            cUserPhoto.image = UIImage(data: appDelegate.setting.userInfo.photo)
        }
    }
    
    @IBAction func onClickedModifyUserPhoto(_ sender: UIButton) {
        present(picker, animated: true, completion: nil)
        
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let newPhoto = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        appDelegate.setting.userInfo.photo = newPhoto.pngData() ?? Data()
        cUserPhoto.image = newPhoto
        picker.dismiss(animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    @IBAction func onClickedSave(_ sender: Any) {
        appDelegate.setting.userInfo.name = cUserName.text ?? "no set name"
        appDelegate.setting.userInfo.photo = cUserPhoto.image?.pngData() ?? Data()
        let view = self.navigationController?.viewControllers[0] as! SettingViewController
        view.cSettingTable.reloadData()
        self.navigationController?.popToRootViewController(animated: true)
   
        //self.naviglationController?.popToRootViewController(animated: true)
        
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
