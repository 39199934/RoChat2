//
//  CommandModel.swift
//  RoChat
//
//  Created by rolodestar on 2019/8/8.
//  Copyright © 2019 Rolodestar Studio. All rights reserved.
//
/*
 命令格式
        命令  命令类别    命令细节（自定义结构）
 e.g.   request  clients
        answer   clients [client info](n)
        request  updateSelfInfo [client info](1)
        answer  updateSelfInfo [client info](1)
 json
 type: request/answer 命令大类别，请求或回答
 detailType: user/
 
 
 
 */
import UIKit
enum CommandModelCommand: String,Codable{
    case request = "request"
    case answer = "answer"
    case error = "error"
}
enum CommandModelCommandType: String ,Codable{
    //user 类命令
    case clients = "clients"  //服务器上所有客户端信息
    case updateSelfInfo = "updateSelfInfo" //更新客户端信息
}
/*struct CommandModelClientInfo: Codable{
    var name: String
    var ipAddress: String
    var type: UserModelType = .normal
    var password: String = "123456"
    var macAddress :String = "55555"
}*/
struct CommandModel: Codable{
    var  command: CommandModelCommand
    var commandType: CommandModelCommandType
    var commandDetail: Data //json 格式化文本
    
    func encoder() -> Data{
        let encoder = JSONEncoder()
        do{
            let data  = try encoder.encode(self)
            //let rtS = String(data: data, encoding: MESSAGE_ENCODING) ?? ""
            return data
        }catch{
        
            return Data()
        }
    }
    mutating func decoder(commandContent: Data) {
        let decoder = JSONDecoder()
        do{
            //let data = commandString.data(using: MESSAGE_ENCODING) ?? Data()
            let stru  = try decoder.decode(CommandModel.self, from: commandContent)
            self.command = stru.command
            self.commandType = stru.commandType
            self.commandDetail = stru.commandDetail
        }catch{
            self.command = .error
            self.commandType = .clients
            self.commandDetail = Data()
        }
    }
    static  func MakeCommandModel(commandContent: Data) -> CommandModel? {
        let decoder = JSONDecoder()
        //var cm : CommandModel? = nil
        do{
            //let data = commandString.data(using: MESSAGE_ENCODING) ?? Data()
            let stru  = try decoder.decode(CommandModel.self, from: commandContent)

            return stru
        }catch{
            //cm = nil
            return nil
        }
    }
    //生成请求刷新客户端命令
    init(){
        self.command = .error
        self.commandType = .clients
        self.commandDetail = Data()
    }
    static func MakeRequestClientsCommand() -> CommandModel{
        var c = CommandModel()
        c.command = .request
        c.commandType = .clients
        c.commandDetail = Data()
        return c
    }
    static func MakeRequestUpdateSelfInfoCommand() -> CommandModel{
        var c = CommandModel()
        c.command = .request
        c.commandType = .updateSelfInfo
        do{
            let info = appDelegate.setting.userInfo.getSendUserStruct();
            var infos = [UserModelSendStruct]()
            infos.append(info)
            let encoding = JSONEncoder()
            c.commandDetail = try encoding.encode(infos) 
            
        }catch{
            c.command = .error
             c.commandDetail = Data()
        }
                
       
        return c
    }
        
    
}
/*
class CommandModel: NSObject {
    var clients: ClientsModel!
    var client: ClientModel!
    var message: SendMessageStruct
   
    static func MakeCommandStruct(byCommand newCommand:CommandModelCommand,byCommandType commandType:CommandModelCommandType,byDetail commandDetail: String) -> CommandModelStruct{
        let command = CommandModelStruct(command: newCommand, commandType: commandType, commandDetail: commandDetail);
        return command
    }
    
    static func SendRequestCommand(byType type:CommandModelCommandType,byDetail detail: String = ""){
        let command = MakeCommandStruct(byCommand: .request, byCommandType: type, byDetail: detail)
        print(command)
        appDelegate.socket.writeCommand(by: command.encoder(), to: UserModel.MakeServerUser())
    }
    static func SendRequestCommand(byType type:CommandModelCommandType,byDetail detail: Data ){
        let str = String(data: detail, encoding: MESSAGE_ENCODING) ?? ""
        let command = MakeCommandStruct(byCommand: .request, byCommandType: type, byDetail: str)
        appDelegate.socket.writeCommand(by: command.encoder(), to: UserModel.MakeServerUser())
    }
    func runCommand(){
        var commandStruct: CommandStruct!
        if message.type != .command{
            return
        }else{
            let decoder = JSONDecoder()
            
            if let data = message.messageContent.data(using: MESSAGE_ENCODING){
                do{
                    commandStruct = try decoder.decode(CommandStruct.self, from: data)
                    
                }catch{
                    print(error.localizedDescription)
                    return
                }
            }
            let type = CommandModelType(rawValue: commandStruct.type) ?? CommandModelType.UserAnswerList
            switch(type){
           
            
            case .UserRequestList:
                break
            case .UserAnswerList:
                var clis = [ClientModel]()
                for cli in commandStruct.detail{
                    var remoteUser = UserModel(name: cli.commandFirst, type: .normal, photo: UIImage(named: "1")!, password: "")
                    remoteUser.ipAddress = cli.commandSecond
                    remoteUser.macAddress = cli.commandThird //UUID(uuidString: cli.commandThird) ?? UUID()
                    let cm = ClientModel(remoteUser: remoteUser)
                    clis.append(cm)
                }
                clients.refreshAllClients(clients: clis)
            case .UserRequestUpdateMySelf:
                break;
           
            }
            
        }
        
    }
    init(message: SendMessageStruct,clients: ClientsModel,client: ClientModel){
        
        self.message = message
        self.client = client
        self.clients = clients
        super.init()
        self.runCommand()
        
    }
    class func makeCommand(commandType: CommandModelType) -> String{
        let encoder = JSONEncoder()
        var commandInfo : CommandStruct!
        var commandDetail: CommandDetailStruct!
        switch commandType {
       
        case .UserRequestList:
            commandDetail = CommandDetailStruct(commandFirst: "", commandSecond: "", commandThird: "")
            commandInfo = CommandStruct(type: commandType.rawValue, detail: [commandDetail])
            do{
                let data = try encoder.encode(commandInfo)
                return String(data: data, encoding: MESSAGE_ENCODING) ?? "encoding wrong"
            }catch{
                print(error.localizedDescription)
            }
        
        case .UserAnswerList:
            break
        case .UserRequestUpdateMySelf:
            break
        
        }
        return String()
    }

}*/
