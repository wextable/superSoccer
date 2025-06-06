//
//  ResultBuilder.swift
//  SuperSoccer
//
//  Created by Wesley on 6/6/25.
//

import Foundation

/// Generic protocol for building Result models from persistence layer models
protocol ResultBuilder {
    associatedtype Input
    associatedtype Output
    
    func build(from input: Input) -> Output
}

/// Generic protocol for building Result models from multiple inputs
protocol AggregateResultBuilder {
    associatedtype Output
    
    func build(from inputs: [Any]) -> Output
}
