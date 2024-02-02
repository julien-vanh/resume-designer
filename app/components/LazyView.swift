//
//  LazyView.swift
//  TripList
//
//  Created by Julien Vanheule on 05/02/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI

struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
