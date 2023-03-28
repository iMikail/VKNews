//
//  UserResponse.swift
//  VKNews
//
//  Created by Misha Volkov on 28.03.23.
//

import Foundation

struct UserResponseWrapped: Decodable {
    let response: [UserResponse]
}

struct UserResponse: Decodable {
    let photo100: String?
}
