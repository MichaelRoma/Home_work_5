//
//  Keychain.swift
//  Home_Work_5
//
//  Created by Mykhailo Romanovskyi on 06.07.2020.
//  Copyright © 2020 Mykhailo Romanovskyi. All rights reserved.
//

import Foundation
class KeyChainModel {
    
  private  func keychainQuery(account: String? = nil) -> [String : AnyObject] {
        let service = "GitHub"
        var query = [String : AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlocked
        query[kSecAttrService as String] = service as AnyObject
        
        if let account = account {
            query[kSecAttrAccount as String] = account as AnyObject
        }
        return query
    }
    
    func readPassword(account: String?) -> String? {
        var query = keychainQuery(account: account)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        
        var queryResult: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer(&queryResult))
        
        if status != noErr {
            return nil
        }
        
        guard let item = queryResult as? [String : AnyObject],
            let passwordData = item[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: .utf8) else { return nil }
        
        return password
    }
    
    func savePassword(password: String, account: String?) -> Bool {
        let passwordData = password.data(using: .utf8)
        
        if readPassword(account: account) != nil {
            var attributesToUpdate = [String : AnyObject]()
            attributesToUpdate[kSecValueData as String] = passwordData as AnyObject
            let query = keychainQuery(account: account)
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            return status == noErr
        }
        var item = keychainQuery(account: account)
        item[kSecValueData as String] = passwordData as AnyObject
        let status = SecItemAdd(item as CFDictionary, nil)
        return status == noErr
    }
}
