//
//  RootView.swift
//  ReSwiftSagaSample
//
//  Created by Mitsuharu Emoto on 2022/10/01.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        NavigationView {
            CounterView()
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
