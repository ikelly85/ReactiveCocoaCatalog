//
//  GitHubAPI.swift
//  ReactiveCocoaCatalog
//
//  Created by Yasuhiro Inami on 2015-09-16.
//  Copyright © 2015 Yasuhiro Inami. All rights reserved.
//

import Foundation
import Curry
import ReactiveCocoa
import APIKit
import Argo

public protocol GitHubRequest: RequestType {}

extension GitHubRequest
{
    public var baseURL: NSURL
    {
        return NSURL(string: "https://api.github.com")!
    }
}

public struct GitHubUsersRequest: GitHubRequest
{
    internal let since: Int
    
    public var method: HTTPMethod
    {
        return .GET
    }
    
    public var path: String
    {
        return "/users"
    }
    
    public var parameters: [String : AnyObject]
    {
        return ["since" : self.since]
    }
    
    public init(since: Int)
    {
        self.since = since
    }
    
    public func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> [GitHubUser]?
    {
//        print("response object = \(object)")
        return decode(object)
    }
}

public struct GitHubUser: Decodable
{
    public let login: String
    public let avatarURL: NSURL

    public static func decode(j: JSON) -> Decoded<GitHubUser>
    {
        return curry(GitHubUser.init)
            <^> j <| "login"
            <*> (j <| "avatar_url").flatMap { .fromOptional(NSURL(string: $0)) }
    }
}

public struct GitHubAPI
{
    public static func usersProducer(since: Int = Int(arc4random_uniform(500))) -> SignalProducer<[GitHubUser], APIError>
    {
        return SignalProducer { observer, disposable in
            let request = GitHubUsersRequest(since: since)
            
            Session.sendRequest(request) { result in
                switch result {
                    case .Success(let response):
                        observer.sendNext(response)
                        observer.sendCompleted()
                    case .Failure(let error):
                        observer.sendFailed(error)
                }
            }
        }
    }
}