//
//  CounterRule.swift
//  YPCounter
//
//  Created by Superior Warden on 15.01.2025.
//


@propertyWrapper
struct CounterRule {
    
    private var value: (option: CounterOption, value: Int) = (.clear, 0)
    
    var wrappedValue: (option: CounterOption, value: Int) {
        get { value }
        set {
            value = newValue
            self.calculate()
            self.rulesCheck()
        }
    }
    
    private mutating func calculate() {
        switch value.option {
            
            case .belowZero:    fallthrough
            case .clear:        self.value.value = 0
            case .add:          self.value.value += 1
            case .subtract:     self.value.value -= 1
            
        }
    }
    
    private mutating func rulesCheck() {
        self.belowZeroCheck()
    }
    
}




// MARK: - concrete rules
extension CounterRule {
    
    private mutating func belowZeroCheck() {
        if value.option == .subtract && value.value < 0 {
            self.value = ( .belowZero, 0 )
        }
    }
}
