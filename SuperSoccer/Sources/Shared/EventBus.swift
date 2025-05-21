//
//  EventBus.swift
//  SuperSoccer
//
//  Created by Wesley on 5/15/25.
//

import Combine

typealias EventBus = PassthroughSubject<BusEvent, Never>

protocol BusEvent {}
