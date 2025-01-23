import SwiftUI

 
@propertyWrapper
final class CounterRule: DynamicProperty {
    
    @State private var value: (option: CounterOption, value: Int) = (.clear, 0)
    
    var wrappedValue: (option: CounterOption, value: Int) {
        get { value }
        set {
            value = newValue
            self.calculate()
            self.rulesCheck()
        }
    }
    
    private func calculate() {
        switch value.option {
            
            case .belowZero:    fallthrough
            case .clear:        self.value.value = 0
            case .add:          self.value.value += 1
            case .subtract:     self.value.value -= 1
            
        }
    }
    
    private func rulesCheck() {
        self.belowZeroCheck()
    }
    
}




// MARK: - concrete rules
extension CounterRule {
    
    private func belowZeroCheck() {
        if value.option == .subtract && value.value < 0 {
            self.value = ( .belowZero, 0 )
        }
    }
}
