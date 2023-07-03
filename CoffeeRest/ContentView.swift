//
//  ContentView.swift
//  CoffeeRest
//
//  Created by André Porto on 03/07/23.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = Date.now
    
    var body: some View {
        DatePicker("Selecione uma data", selection: $wakeUp, in: Date.now...)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
