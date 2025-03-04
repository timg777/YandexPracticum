enum AlertKind: Equatable {
    case report, error(String)
    
    var header: String {
        switch self {
        case .report:
            "Этот раунд окончен!"
        case .error:
            "Ой"
        }
    }
    
    func body(report: String = "") -> String {
        switch self {
        case .report:
            report
        case .error(let localizedDescription):
            "Что-то пошло не так :_(\n\(localizedDescription)\nПожалуйста, повторите попытку позже"
        }
    }
    
    var buttonText: String {
        switch self {
        case .report:
            "Сыграть еще раз"
        case .error:
            "Повторить"
        }
    }
}
