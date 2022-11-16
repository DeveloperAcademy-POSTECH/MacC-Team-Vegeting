//
//  ViewModelType.swift
//  Vegeting
//
//  Created by yudonlee on 2022/11/13.
//

import Combine
import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never>
    
}
