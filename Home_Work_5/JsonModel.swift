//
//  JsonModel.swift
//  Home_Work_5
//
//  Created by Mykhailo Romanovskyi on 28.06.2020.
//  Copyright © 2020 Mykhailo Romanovskyi. All rights reserved.
//
/// Модель для получения JSON данных с ГитХаба
struct JsonModel: Decodable {
    let total_count: Int
    let items: [Items]
    
    struct Items: Decodable {
        let name: String
        let description: String
        let html_url: String
        let owner: Owner
    }
    struct Owner: Decodable {
        let login: String
        let avatar_url: String
    }
}
