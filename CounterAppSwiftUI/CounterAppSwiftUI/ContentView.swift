//
//  ContentView.swift
//  CounterAppSwiftUI
//
//  Created by Superior Warden on 20.01.2025.
//

import SwiftUI

struct ContentView: View {
    
    @State private var counter = 0
    @State private var currentAction: CounterOption = .clear {
        didSet {
            withAnimation {
                self.calculate()
                self.rulesCheck()
            }
        }
    }
    
    @State private var history = "История операций"
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Text("\(counter)")
                .font(.system(size: 72, weight: .bold, design: .rounded))
                .frame(width: .infinity, alignment: .center)
                .contentTransition(.numericText())
            
            Spacer()
            
            VStack {
                HStack {
                    
                    Button( action: {
                        currentAction = .subtract
                        
                    }) {
                        Text("-")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                    }
                    .buttonStyle(CounterButtonStyle( color: .blue ))

                    Button( action: {
                        currentAction = .add
                        
                    }) {
                        Text("+")
                            .font(.system(size: 40, weight: .bold, design: .default))
                    }
                    .buttonStyle(CounterButtonStyle( color: .red ))
                    
                }
                
                Button( action: {
                    currentAction = .clear
                    
                }) {
                    Text("Reset")
                        .font(.system(size: 26, weight: .bold, design: .default))
                        .padding(.horizontal)
                }
                .buttonStyle(CounterButtonStyle( color: .gray ))
                
            }
            
        }
        .padding()
        .background(alignment: .top) {
            ScrollView(.vertical) {
                Text(history)
                    .multilineTextAlignment(.center)
                    .font(.system(.subheadline, design: .rounded))
                    .lineLimit(nil)
            }
            .frame(height: UIScreen.main.bounds.height * 0.2, alignment: .top)
            .defaultScrollAnchor(.bottom, for: .sizeChanges)
        }
    }
    
    private func pushHistory() {
        if history == "История операций" {
            history = "\(currentAction.logText)"
        } else {
            history += "\n\(currentAction.logText)"
        }
    }
    
    private func calculate() {
        switch currentAction {
            
            case .belowZero:    fallthrough
            case .clear:        counter = 0
            case .add:          counter += 1
            case .subtract:     counter -= 1
            
        }
        
        pushHistory()
    }
    
    private func rulesCheck() {
        self.belowZeroCheck()
    }
    
    private func belowZeroCheck() {
        if currentAction == .subtract && counter < 0 {
            (currentAction, counter) = ( .belowZero, 0 )
        }
    }

}

#Preview {
    ContentView()
}




struct CounterButtonStyle: ButtonStyle {
    
    var color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(color, in: RoundedRectangle(cornerRadius: 15))
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
    
}
