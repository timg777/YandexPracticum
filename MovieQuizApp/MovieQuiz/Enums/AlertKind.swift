enum AlertKind {
    case report, error
    
    var header: String {
        switch self {
        case .report:
            "Этот раунд окончен!"
        case .error:
            "Ой"
        }
    }
    
    func body(report: String = "Что-то пошло не так :_(\n Пожалуйста, повторите попытку позже") -> String {
        report
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
