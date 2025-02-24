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
            calculate()
            rulesCheck()
        }
    }
    @State private var isButtonsAvailable = true

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
                        switchButtonsAvailableState()
                    }) {
                        Text("-")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                    }
                    .buttonStyle(CounterButtonStyle( color: .blue ))
                    .allowsHitTesting(isButtonsAvailable)
                    
                    Button( action: {
                        currentAction = .add
                        switchButtonsAvailableState()
                        
                    }) {
                        Text("+")
                            .font(.system(size: 40, weight: .bold, design: .default))
                    }
                    .buttonStyle(CounterButtonStyle( color: .red ))
                    .allowsHitTesting(isButtonsAvailable)
                    
                }
                
                Button( action: {
                    currentAction = .clear
                    switchButtonsAvailableState()
                }) {
                    Text("Reset")
                        .font(.system(size: 26, weight: .bold, design: .default))
                        .padding(.horizontal)
                }
                .buttonStyle(CounterButtonStyle( color: .gray ))
                .allowsHitTesting(isButtonsAvailable)
                
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
        withAnimation {
            switch currentAction {
            case .belowZero:    fallthrough
            case .clear:        counter = 0
            case .add:          counter += 1
            case .subtract:     counter -= 1
            }
        }
        
        pushHistory()
    }
    
    private func rulesCheck() {
        belowZeroCheck()
    }
    
    private func belowZeroCheck() {
        if currentAction == .subtract && counter < 0 {
            (currentAction, counter) = ( .belowZero, 0 )
        }
    }
    
    private func switchButtonsAvailableState() {
        isButtonsAvailable.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isButtonsAvailable.toggle()
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
