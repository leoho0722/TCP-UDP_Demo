//
//  UDPViewController.swift
//  TCP-UDP_Demo
//
//  Created by Leo Ho on 2021/7/2.
//

import UIKit
import CocoaAsyncSocket

class UDPViewController: UIViewController, GCDAsyncUdpSocketDelegate {

    @IBOutlet var portTF: UITextField!
    @IBOutlet var messengeTF: UITextField!
    @IBOutlet var bindingPortBtn: UIButton!
    @IBOutlet var messengeTextView: UITextView!
    
    var udpSocket: GCDAsyncUdpSocket!
    var IP = "255.255.255.255"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        udpSocket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.main)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func udpConnectBtn(_ sender: UIButton) {
        do {
            try udpSocket.bind(toPort: UInt16(portTF.text!)!)
            Alert.showMessage(messengeTextView, DateToString.dateString())
            Alert.showMessage(messengeTextView, "已經綁定端口：\(UInt16(portTF.text!)!)")
            Alert.showMessage(messengeTextView, "-----------------------------")
            bindingPortBtn.isSelected = !(bindingPortBtn.isSelected) // 設定按鈕選擇與取消選擇
            bindingPortBtn.setTitle("取消綁定 Port 號", for: .normal)
            // 選擇按鈕時變成灰色，取消選擇時變成預設藍色
            bindingPortBtn.isSelected ? (self.bindingPortBtn.tintColor = UIColor.gray) : (self.bindingPortBtn.tintColor = UIColor.systemBlue)
        } catch {
            Alert.showMessage(messengeTextView, "端口綁定失敗")
        }
        
        // 開啟廣播
        do {
            try udpSocket.enableBroadcast(true)
            print("開始廣播")
        } catch {
            print("無法進行廣播")
        }
        
        // 開始接收
        do {
            try udpSocket.beginReceiving()
            print("資料開始接收中")
        } catch {
            print("資料無法進行接收")
        }
        view.endEditing(true)
    }
    
    @IBAction func sendBtn(_ sender: UIButton) {
        let data = messengeTF.text?.data(using: .utf8)
        
        // 發送資料
        udpSocket.send(data!, toHost: IP, port: UInt16(portTF.text!)!, withTimeout: -1, tag: 0)
        view.endEditing(true)
    }
    
    @IBAction func clearBtn(_ sender: UIButton) {
        messengeTextView.text = ""
    }
}

// MARK: - Socket 資料處理
extension UDPViewController {
    // 接收 Host 端資料
    func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        print("已經接收到資料")
        var host: NSString?
        var port: UInt16 = 0
        
        GCDAsyncUdpSocket.getHost(&host, port: &port, fromAddress: address) // 取得 Host 端的相關資訊
        Alert.showMessage(messengeTextView, "From IP：\(host! as String)") // 顯示 Host 端 IP
        Alert.showMessage(messengeTextView, "\(String(describing: String(data: data, encoding: String.Encoding.utf8)))") // 顯示 Host 端資訊
        print("From Host：\(host!)")
        print("Incoming Message：\(String(describing: String(data: data, encoding: String.Encoding.utf8)))")
    }
    
    // UDP Socket 未連接成功
    func udpSocket(_ sock: GCDAsyncUdpSocket, didNotConnect error: Error?) {
        print("未連接成功：\(error!)")
    }
    
    // 斷開連接
    func udpSocketDidClose(_ sock: GCDAsyncUdpSocket, withError error: Error?) {
        print("斷開連接 Error：\(error!)")
    }
    
    // 訊息發送失敗
    func udpSocket(_ sock: GCDAsyncUdpSocket, didNotSendDataWithTag tag: Int, dueToError error: Error?) {
        print("didNotSendDataWithTag")
    }
    
    // 訊息發送成功
    func udpSocket(_ sock: GCDAsyncUdpSocket, didSendDataWithTag tag: Int) {
        print("didSendDataWithTag")
    }
}

/*
 參考資料：https://www.wpgdadatong.com/tw/blog/detail?BID=B0974
 */
