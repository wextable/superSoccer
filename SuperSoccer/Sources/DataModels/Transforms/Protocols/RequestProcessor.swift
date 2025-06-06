//
//  RequestProcessor.swift
//  SuperSoccer
//
//  Created by Wesley on 6/6/25.
//

import Foundation

/// Generic protocol for processing Request models into persistence layer operations
protocol RequestProcessor {
    associatedtype Input
    associatedtype Output
    
    func process(_ request: Input) async throws -> Output
}

/// Generic protocol for processing complex requests that may involve multiple operations
protocol ComplexRequestProcessor {
    associatedtype Input
    associatedtype Output
    
    func process(_ request: Input) async throws -> Output
}
