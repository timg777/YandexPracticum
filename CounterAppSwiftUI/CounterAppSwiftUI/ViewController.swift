//
//  ViewController.swift
//  YPCounter
//
//  Created by Superior Warden on 12.01.2025.
//

import UIKit


// MARK: - я использовал дополнитульную переменную counterLabelText, потому что property observer не реагирует на изменения counterLabel, так как изменение свойства/поля объекта не приводит к изменению самого объекта. Можно было бы, конечно, наблюдателя повесить на поле text у counterLabel, но я думаю, что излишняя логика из более продвинутового уровня в данном тренироваочном приложении не нужна.



class ViewController: UIViewController {
    
    
    @IBOutlet weak var historyTextView: UITextView!
    
    @IBOutlet weak var counterLabel: UILabel!
    @CounterRule private var currentCounterAction
    
    @IBOutlet weak var counterPlusButton: UIButton!
    @IBOutlet weak var counterMinusButton: UIButton!
    @IBOutlet weak var counterResetButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}




// MARK: - Buttons handlers
private extension ViewController {
    
    @IBAction func counterResetButtonDidTapped() {
        self.currentCounterAction.option = .clear
        self.counterValueChangedHandler()
    }

    @IBAction func counterPlusButtonDidTapped() {
        self.currentCounterAction.option = .add
        self.counterValueChangedHandler()
    }

    @IBAction func counterMinusButtonDidTapped() {
        self.currentCounterAction.option = .subtract
        self.counterValueChangedHandler()
    }
    
}




// MARK: - Other handlers
private extension ViewController {
    
    private func updateHistorLog( _ counterOption: CounterOption ) {
        UIView.animate(withDuration: 0.5) {
            if self.historyTextView.text != "История изменений" {
                self.historyTextView.text?.append( "\n\(counterOption.logText)" )
            } else {
                self.historyTextView.text = counterOption.logText
            }
            
            // MARK: - moving history log down when content overflows
            let range = NSRange(location: self.historyTextView.text.count - 1, length: 1)
            self.historyTextView.scrollRangeToVisible(range)
        }
    }
    
    func counterValueChangedHandler() {
        self.updateHistorLog( self.currentCounterAction.option )
        self.counterLabel.text = "\( self.currentCounterAction.value )"
    }
}
