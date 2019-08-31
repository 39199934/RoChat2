//
//  ChatMessageViewCell.swift
//  RoChat
//
//  Created by rolodestar on 2019/7/28.
//  Copyright © 2019 Rolodestar Studio. All rights reserved.
//

import UIKit

class ChatMessageViewCell: UITableViewCell {

    @IBOutlet weak var cMessageString: UILabel!
    @IBOutlet weak var cMessageImage: UIImageView!
    @IBOutlet weak var cUserPhoto: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        cUserPhoto.contentMode = .scaleAspectFit
        cMessageImage.contentMode = .scaleAspectFit
        cMessageString.numberOfLines = 0
        cMessageString.lineBreakMode = .byWordWrapping
        cMessageString.backgroundColor = UIColor.gray
        cUserPhoto.backgroundColor = UIColor.blue
        let heigh = frame.height
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func viewMsg(msg :ClientModel.messageDatabaseType){
        if cUserPhoto != nil{
            cUserPhoto.image = msg.photo
            switch(msg.type){
            case .message,.command,.link:
                let msgStr = String(data: msg.content as! Data, encoding: MESSAGE_ENCODING) ?? ""
                //cMessageString.frame = CGRect(x: 50, y: 80, width: 60, height: 150)
                //cMessageString.sizeToFit()
                //cMessageString.numberOfLines = 0
                cMessageString.text = msgStr
//                cMessageString.font = UIFont.systemFont(ofSize: 15)
//                cMessageString.textColor = UIColor.red
//                cMessageString.textAlignment = msg.isSender ? .right : .left
//                cMessageString.numberOfLines = 0
//                cMessageString.lineBreakMode = NSLineBreakMode.byWordWrapping
//                let boundingRect = cMessageString.text!.boundingRect(with: CGSize(width: 200, height: 0), options: .usesLineFragmentOrigin, attributes:[NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)], context: nil)
//                cMessageString.frame = CGRect(x: 10, y: 200, width: self.bounds.width - 20, height: boundingRect.height)
                
                //cMessageImage.isHidden = true
            case .image:
                cMessageImage.image = UIImage(data: msg.content as! Data) ?? UIImage()
               // cMessageString.isHidden = true
            default:
                break
            }
        }
    }
    

}
