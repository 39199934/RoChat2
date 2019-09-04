//
//  MessageCatch.swift
//  RoChat2
//
//  Created by rolodestar on 2019/9/3.
//  Copyright © 2019 Rolodestar Studio. All rights reserved.
//

import Foundation

protocol MessageModelCatchDelegate {
    func messageModelCatchDidStartReading(modelCatch: MessageModelCatch)
    func messageModelCatchDidReadHead(modelCatch: MessageModelCatch)
    func messageModelCatchDidReadBody(modelCatch: MessageModelCatch)
    func messageModelCatchDidFinish(modelCatch: MessageModelCatch,messageModel: MessageModel)
}
class MessageModelCatch {
    enum CatchStatus {
        case empty
        case readingHead
        case readingBody
        case finishedReadBody
        case finishedCheck
        
    }
    var delegate: MessageModelCatchDelegate?
    var catchStatus: CatchStatus = .empty
    var isEmpty: Bool{
        get{
            if catchStatus == .finishedCheck{
                return true
            }else{
                return false
            }
        }
    }
    var messageModel = MessageModel.MessageModelEmpty
    private var catchData = Data()
    public func append(data: Data){
        switch catchStatus {
        
        case .empty,.finishedCheck:
            delegate?.messageModelCatchDidStartReading(modelCatch: self)
            do{
                let decoding = JSONDecoder()
                let rt = try decoding.decode(MessageHeadStruct.self, from: data)
                
                messageModel.head = rt
                catchStatus = .readingBody
                delegate?.messageModelCatchDidReadHead(modelCatch: self)
                
            }catch{
                let errorBody = MessageBodyModel(byNoFormatted: data)
                messageModel = MessageModel(byBody: errorBody)
                catchStatus = .finishedCheck
                catchData = Data()
                delegate?.messageModelCatchDidFinish(modelCatch: self, messageModel: messageModel)
            }
        case .readingHead:
            break
        case .readingBody:
            catchData.append(data)
            if(UInt16(catchData.count) >= messageModel.head!.size){
                delegate?.messageModelCatchDidReadBody(modelCatch: self)
                let body = MessageBodyModel.MakeMessageModel(byData: catchData)
                messageModel.body = body
                
                catchStatus = .finishedCheck
                catchData = Data()
                delegate?.messageModelCatchDidFinish(modelCatch: self, messageModel: messageModel)
            }
        case .finishedReadBody:
            break
        
       
        }
        
        
    }
}
