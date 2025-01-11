//
//  Recipe.swift
//  Di-Eat
//
//  Created by wjdyukyung on 12/31/24.
//

import Foundation


struct Recipe: Codable, Hashable {
    let recipeNumber: Int
    let title: String
    let ingredientName: String
    let registerId: Int
    let registerName: String
    let inquiryCount: Int
    let recommendCount: Int
    let shareCount: Int
    let cookingMethodName: String
    let categoryName: String
    let ingredientCategoryName: String
    let foodTypeCategory: String
    let description: String
    let materialDescription: String
    let servingSize: String
    let difficultyLevel: String
    let cookingTime: String
    let firstRegistrationDate: String
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case recipeNumber = "RCP_SNO"
        case title = "RCP_TTL"
        case ingredientName = "CKG_NM"
        case registerId = "RGTR_ID"
        case registerName = "RGTR_NM"
        case inquiryCount = "INQ_CNT"
        case recommendCount = "RCMM_CNT"
        case shareCount = "SRAP_CNT"
        case cookingMethodName = "CKG_MTH_ACTO_NM"
        case categoryName = "CKG_STA_ACTO_NM"
        case ingredientCategoryName = "CKG_MTRL_ACTO_NM"
        case foodTypeCategory = "CKG_KND_ACTO_NM"
        case description = "CKG_IPDC"
        case materialDescription = "CKG_MTRL_CN"
        case servingSize = "CKG_INBUN_NM"
        case difficultyLevel = "CKG_DODF_NM"
        case cookingTime = "CKG_TIME_NM"
        case firstRegistrationDate = "FIRST_REG_DT"
        case imageUrl = "RCP_IMG_URL"
    }
}
