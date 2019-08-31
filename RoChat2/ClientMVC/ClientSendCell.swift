//
//  ChatMessageViewCellForSend.swift
//  RoChat
//
//  Created by rolodestar on 2019/8/2.
//  Copyright © 2019 Rolodestar Studio. All rights reserved.
//

import UIKit

class ClientSendCell: UITableViewCell {

    @IBOutlet weak var cUserPhoto: UIImageView!
    @IBOutlet weak var cMessageString: UILabel!
    @IBOutlet weak var cMessageImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func viewMsg(msg :ClientModel.messageDatabaseType){
        if cMessageString != nil{
            //cUserPhoto.image = msg.photo
            cMessageString.lineBreakMode = .byWordWrapping
            cMessageString.numberOfLines = 0
            //cMessageString.backgroundColor = UIColor.blue
            //cUserPhoto.backgroundColor = UIColor.red
            switch(msg.type){
            case .message,.command,.link:
                let msgStr = (msg.content as? String) ?? ""
                //cMessageString.frame = CGRect(x: 50, y: 80, width: 60, height: 150)
                //cMessageString.sizeToFit()
                //cMessageString.numberOfLines = 0
                cMessageString.text = msgStr
                //let user = msg.
                let img = msg.photo ?? UIImage()
                cUserPhoto.image = img
                
                //                cMessageString.font = UIFont.systemFont(ofSize: 15)
                //                cMessageString.textColor = UIColor.red
                //                cMessageString.textAlignment = msg.isSender ? .right : .left
                //                cMessageString.numberOfLines = 0
                //                cMessageString.lineBreakMode = NSLineBreakMode.byWordWrapping
                //                let boundingRect = cMessageString.text!.boundingRect(with: CGSize(width: 200, height: 0), options: .usesLineFragmentOrigin, attributes:[NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)], context: nil)
                //                cMessageString.frame = CGRect(x: 10, y: 200, width: self.bounds.width - 20, height: boundingRect.height)
                
            //cMessageImage.isHidden = true
            case .image:
              //  cMessageImage.image = UIImage(data: msg.content as! Data) ?? UIImage()
            // cMessageString.isHidden = true
                break
            default:
                break
            }
        }
    }
    

}
