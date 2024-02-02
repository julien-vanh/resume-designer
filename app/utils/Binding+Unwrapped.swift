//
//  Binding+Unwrapped.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 27/09/2022.
//

import SwiftUI


extension Binding {
     func toUnwrapped<T>(defaultValue: T) -> Binding<T> where Value == Optional<T>  {
        Binding<T>(get: { self.wrappedValue ?? defaultValue }, set: { self.wrappedValue = $0 })
    }
}
