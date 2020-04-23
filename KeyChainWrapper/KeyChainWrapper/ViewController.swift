//
//  ViewController.swift
//  KeyChainWrapper
//
//  Created by Khan, Tauqeer - Dell Team on 21/04/20.
//  Copyright © 2020 RSA. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    let kc = KeyChainManager(KeyChain())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.encryptAndPersist()
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
    func encryptAndPersist(){
        do {
            let sourceData = "AES256".data(using: .utf8)!
            let password = "password"
            let salt = AES256Crypter.randomSalt()
            let iv = AES256Crypter.randomIv()
            let key = try AES256Crypter.createKey(password: password.data(using: .utf8)!, salt: salt)
            let aes = try AES256Crypter(key: key, iv: iv)
            let encryptedData = try aes.encrypt(sourceData)
            let _ = try aes.decrypt(encryptedData)
            
            print("Encrypted hex string: \(encryptedData.hexString)")
            
            let saveResult = kc.save(key: "MyString", data: encryptedData)
            print("Save Result: \(saveResult)")
            
        } catch {
            print("Failed")
            print(error)
        }
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        do {
            let deleteResult = try kc.delete(key: "MyString")
            print("Delete Result: \(deleteResult)")
        } catch {
            print("Delete failed")
            print(error)
        }
    }
    
    @IBAction func fetchButtonTapped(_ sender: Any) {
        if let receivedData = kc.load(key: "MyString"){
            print("receivedData:", receivedData )
            print("Hex String: \(receivedData.hexString)")
            
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        do {
            let sourceData = "AES256".data(using: .utf8)!
            let password = "password"
            let salt = AES256Crypter.randomSalt()
            let iv = AES256Crypter.randomIv()
            let key = try AES256Crypter.createKey(password: password.data(using: .utf8)!, salt: salt)
            let aes = try AES256Crypter(key: key, iv: iv)
            let encryptedData = try aes.encrypt(sourceData)
            let _ = try aes.decrypt(encryptedData)
            
            print("Encrypted hex string: \(encryptedData.hexString)")
            
            let saveResult = kc.save(key: "MyString", data: encryptedData)
            print("Save Result: \(saveResult)")
            
        } catch {
            print("Failed")
            print(error)
        }
        
    }
    
}

