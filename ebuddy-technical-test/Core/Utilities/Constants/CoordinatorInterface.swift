//
//  CoordinatorInterface.swift
//  ebuddy-technical-test
//
//  Created by danny santoso on 12/21/24.
//

import SwiftUI

protocol Coordinator {
    associatedtype Destination
    func navigate(to destination: Destination) -> AnyView
}
