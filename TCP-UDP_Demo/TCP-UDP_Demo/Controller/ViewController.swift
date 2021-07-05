//
//  ViewController.swift
//  TCP-UDP_Demo
//
//  Created by Leo Ho on 2021/7/2.
//

import UIKit
import CocoaAsyncSocket

class ViewController: UIViewController, GCDAsyncSocketDelegate {
    
    @IBOutlet var ipAddressTF: UITextField!
    @IBOutlet var portTF: UITextField!
    @IBOutlet var messengeTF: UITextField!
    @IBOutlet var bindingPortBtn: UIButton!
    @IBOutlet var messengeTextView: UITextView!
    
    var socket: GCDAsyncSocket!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        socket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main) // 建立 TCP Socket
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func tcpConnectBtn(_ sender: UIButton) {
        bindingPortBtn.isSelected = !(bindingPortBtn.isSelected) // 設定按鈕選擇與取消選擇
        bindingPortBtn.isSelected ? connect() : stopConnect() // 選擇按鈕時進行連線，取消選擇時停止連線
        // 選擇按鈕時變成灰色，取消選擇時變成預設藍色
        bindingPortBtn.isSelected ? (self.bindingPortBtn.tintColor = UIColor.gray) : (self.bindingPortBtn.tintColor = UIColor.systemBlue)
    }
    
    @IBAction func sendBtn(_ sender: UIButton) {
        let data = messengeTF.text?.data(using: .utf8) // 將輸入的文字轉成 data 格式
        Alert.showMessage(messengeTextView, DateToString.dateString() + "\nClient:" + messengeTF.text! + "\n")
        socket.write(data!, withTimeout: -1, tag: 0)
        view.endEditing(true)
        messengeTF.text = ""
    }
    
    @IBAction func clearBtn(_ sender: UIButton) {
        messengeTextView.text = ""
    }
    
    // 進行連線
    func connect() {
        bindingPortBtn.setTitle("取消綁定 Port 號", for: .normal)
        do {
            try socket.connect(toHost: ipAddressTF.text!, onPort: UInt16(portTF.text!)!, withTimeout: -1)
        } catch {
            Alert.showMessage(messengeTextView, "連線狀態：連線失敗")
        }
        view.endEditing(true)
    }
    
    // 停止連線
    func stopConnect() {
        bindingPortBtn.setTitle("綁定 Port 號", for: .normal)
        socket.disconnect()
    }
    

}

// MARK: - Socket 資料處理
extension ViewController {
    // 連接成功後，在 TextView 上顯示連接成功的訊息以及 Server IP
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        Alert.showMessage(messengeTextView, DateToString.dateString())
        Alert.showMessage(messengeTextView, "連線狀態：連線成功")
        let address = "Server IP：" + "\(host)"
        Alert.showMessage(messengeTextView, address)
        Alert.showMessage(messengeTextView, "-----------------------------")
        socket.readData(withTimeout: -1, tag: 0)
    }
    
    // 接收 Server 端回傳的訊息
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        let text = String(data: data, encoding: .utf8)
        Alert.showMessage(messengeTextView, DateToString.dateString() + "\nServer：" + text! + "\n")
        socket.readData(withTimeout: -1, tag: 0)
    }
    
    // 斷開連接
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        Alert.showMessage(messengeTextView, "斷開連接")
        bindingPortBtn.setTitle("綁定 Port 號", for: .normal)
    }
}

/*
 參考資料：https://www.wpgdadatong.com/tw/blog/detail?BID=B0974
 */
