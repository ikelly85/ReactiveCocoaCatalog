//
//  BingAPI.swift
//  ReactiveCocoaCatalog
//
//  Created by Yasuhiro Inami on 2015-09-16.
//  Copyright © 2015 Yasuhiro Inami. All rights reserved.
//

import Foundation
import ReactiveCocoa
import APIKit

public protocol BingRequest: Request {}

extension BingRequest
{
    public var baseURL: NSURL
    {
        return NSURL(string: "https://api.bing.com")!
    }
}

public struct BingSearchRequest: BingRequest
{
    internal let query: String
    
    public var method: HTTPMethod
    {
        return .GET
    }
    
    public var path: String
    {
        return "/osjson.aspx"
    }
    
    public var parameters: [String : AnyObject]
    {
        return ["query" : self.query]
    }
    
    public init(query: String)
    {
        self.query = query
    }
    
    public func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> BingSearchResponse?
    {
//        print("response object = \(object)")
        
        guard let arr = object as? [AnyObject] where arr.count == 2 else {
            return nil
        }
        
        let query = arr[0] as? String ?? ""
        let suggestions = arr[1] as? [String] ?? []
        
        return BingSearchResponse(query: query, suggestions: suggestions)
    }
}

public struct BingSearchResponse
{
    public let query: String
    public let suggestions: [String]
}

public final class BingAPI: API
{
    public static func searchProducer(query: String) -> SignalProducer<BingSearchResponse, APIError>
    {
        return SignalProducer { observer, disposable in
            let request = BingSearchRequest(query: query)
            
            API.sendRequest(request) { result in
                switch result {
                    case .Success(let response):
                        sendNext(observer, response)
                        sendCompleted(observer)
                    case .Failure(let error):
                        sendError(observer, error)
                }
            }
        }
    }
}