//
//  SettingStruct.swift
//  RoChat
//
//  Created by rolodestar on 2019/7/26.
//  Copyright © 2019 Rolodestar Studio. All rights reserved.
//

import Foundation
import UIKit
class SettingModel: Codable{
    
    var port: UInt// = 57239
    var serverAddress: String// = "m2k5909168.zicp.vip"
   
    
    var userInfo: UserModel
        //= UserInfoStruct(userName: "rolodestar", ipAddress: getIpAddress(), userType: .normal,userPhoto: (UIImage(named: "head")?.pngData()))
    init() {
       
        
        self.port = 8080
        self.serverAddress =   "192.168.31.192" //"m2k5909168.zicp.vip" //
       
        
        self.userInfo = UserModel.MakeLocalUser()
        
       
    }
    
    
    
   
}

