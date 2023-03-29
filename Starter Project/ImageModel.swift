//
//  ImageModel.swift
//  Starter Project
//
//  Created by Sameh on 28/03/2023.
//

import Foundation

struct Image:Codable{
    let id:String
    let created_at:String
    let urls: [String: String]
    
}
