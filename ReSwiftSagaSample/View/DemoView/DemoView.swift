//
//  DemoView.swift
//  ReSwiftSagaSample
//
//  Created by Mitsuharu Emoto on 2023/06/17.
//

import SwiftUI

struct DemoView: View {
    var body: some View {
        VStack{
            CounterView()
            UserView()
        }
    }
}

struct DemoView_Previews: PreviewProvider {
    static var previews: some View {
        DemoView()
    }
}
