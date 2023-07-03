//
//  ContentView.swift
//  CoffeeRest
//
//  Created by André Porto on 03/07/23.
//
import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAMount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.white, Color.blue, Color.indigo, Color.purple]),
                               startPoint: .topLeading,
                               endPoint: .bottom)
                    .ignoresSafeArea()
                
                Form {
                    Section {
                        Text("Quando você deseja acordar?")
                            .font(.headline)
                        
                        DatePicker("Insira um horário", selection: $wakeUp, displayedComponents:
                                .hourAndMinute)
                        .labelsHidden()
                    }
                    
                    Section {
                        Text("Quantidade de sono")
                            .font(.headline)
                        
                        Stepper("\(sleepAmount.formatted()) horas", value: $sleepAmount, in: 4...12, step: 0.25)
                    }
                    
                    Section {
                        Text("Quantidade diária de Café")
                            .font(.headline)
                        
                        Stepper(coffeeAMount == 1 ? "1 copo" : "\(coffeeAMount) copos", value: $coffeeAMount, in: 1...20)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("BedTimeCoffee")
            .toolbar {
                Button("Calcular", action: calculateBedTime)
                    .foregroundColor(.black)
                    .fontWeight(.semibold)
            }
            
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    func calculateBedTime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAMount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            alertTitle = "Seu horário ideal de dormir é..."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
            
        } catch {
            alertTitle = "Error"
            alertMessage = "Desculpe, houve um problema ao cacular seu horário de dormir."
            
        }
        
        showingAlert = true
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
