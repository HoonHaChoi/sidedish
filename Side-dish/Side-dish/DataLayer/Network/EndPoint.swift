//
//  EndPoint.swift
//  Side-dish
//
//  Created by HOONHA CHOI on 2021/04/19.
//

import Foundation

enum Endpoint {
    private static let scheme = "https"
    private static let host = "h3rb9c0ugl.execute-api.ap-northeast-2.amazonaws.com"
    private static let basicPath = "/develop/baminchan/"
    private static let detailPath = "detail/"
    
    private static let postHost = "hooks.slack.com"
    private static let servicePath = "/services/"
    private static let key = "T74H5245A/B7A8M1W3F/r9FPsaPQ1rV3dy0PYNKVt6EC"
    
    static func url<T>(path : T) -> URL? {
        var components = URLComponents()
        components.scheme = Endpoint.scheme
        components.host = Endpoint.host
        components.path = T.self == Menu.self ?
            basicPath + "\(path)" :
            basicPath + detailPath + "\(path)"
        return components.url
    }

    static func postURL() -> URL? {
        var components = URLComponents()
        components.scheme = Endpoint.scheme
        components.host = Endpoint.postHost
        components.path = servicePath + key
        return components.url
    }
    
    static let headers : [String:String] = ["Content-Type":"application/json"]
}

extension URL {
    func addQueryItem(key: String, value: String) -> URL?{
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
             return nil
        }
        components.queryItems = [
            URLQueryItem(name: key, value: value)
        ]
        return components.url
    }
}


enum Menu: CaseIterable {
    case main
    case soup
    case side
    
    var title : String {
        switch self {
        case .main:
            return "한그릇 뚝딱 메인요리"
        case .soup:
            return "김이 모락모락 국,찌깨"
        case .side:
            return "언제 먹어도 든든한 밑반찬"
        }
    }
}
