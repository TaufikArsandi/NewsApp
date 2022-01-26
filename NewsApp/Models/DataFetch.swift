//
//  DataFetch.swift
//  NewsApp
//
//  Created by Taufik Arsandi on 26/01/22.
//

import Foundation

enum DataFetch<T> {
    
    case empty
    case success(T)
    case fetchingNextPage(T)
    case failure(Error)
    
    var value: T? {
        if case .success(let value) = self {
            return value
        } else if case .fetchingNextPage(let value) = self {
            return value
        }
        return nil
    }
    
}
