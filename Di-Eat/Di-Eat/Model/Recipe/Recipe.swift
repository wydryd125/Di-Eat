//
//  Recipe.swift
//  Di-Eat
//
//  Created by wjdyukyung on 12/31/24.
//

import Foundation

enum RecipeType {
    case new
    case best
}

enum LevelType: Int {
    case level1 = 0
    case level2
    case level3
}

struct Recipe: Codable, Hashable {
    let recipeNumber: Int // 레시피 ID
    let title: String  // 레시피 제목
    let ingredientName: String // 요리 이름
    let registerName: String // 작성자 ID
    let viewCount: Int // 조회수
    let recommendCount: Int // 추천 수
    let scrapCount: Int // 스크랩 수
    let cookingMethod: String // 조리 방법
    let categoryName: String // 요리 스타일
    let materialType: String // 재료 유형
    let foodType: String // 요리 종류
    let description: String // 요리 설명
    let materialDescription: String // 재료 상세
    let servingSize: String // 인분 정보
    let level: String // 난이도
    let cookingTime: String // 조리 시간
    let postDate: Int // 게시 일
    let imageUrl: String // 이미지

    enum CodingKeys: String, CodingKey {
        case recipeNumber = "RCP_SNO"
        case title = "RCP_TTL"
        case ingredientName = "CKG_NM"
        case registerName = "RGTR_NM"
        case viewCount = "INQ_CNT"
        case recommendCount = "RCMM_CNT"
        case scrapCount = "SRAP_CNT"
        case cookingMethod = "CKG_MTH_ACTO_NM"
        case categoryName = "CKG_STA_ACTO_NM"
        case materialType = "CKG_MTRL_ACTO_NM"
        case foodType = "CKG_KND_ACTO_NM"
        case description = "CKG_IPDC"
        case materialDescription = "CKG_MTRL_CN"
        case servingSize = "CKG_INBUN_NM"
        case level = "CKG_DODF_NM"
        case cookingTime = "CKG_TIME_NM"
        case postDate = "FIRST_REG_DT"
        case imageUrl = "RCP_IMG_URL"
    }
    
    var transformedLevel: String {
        switch level {
        case "아무나": 
            return "Level 1"
        case "초급":
            return "Level 2"
        case "중급":
            return "Level 3"
        default:
            return "Level 1"
        }
    }
    
    var formatDate: String {
        let dateString = String(postDate).prefix(8)
        
        let year = dateString.prefix(4).suffix(2)
        let month = dateString.dropFirst(4).prefix(2)
        let day = dateString.suffix(2)
        
        return "\(year).\(month).\(day)"
    }
}
