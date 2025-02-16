
enum AlertKind {
    case report
    case error
    
    var header: String {
        switch self {
        case .report:
            return "Этот раунд окончен!"
        case .error:
            return "Ошибка"
        }
    }
    
    func body(report: String = "Что-то пошло не так :_(\n Пожалуйста, повторите попытку позже") -> String {
        return report
    }
    
    var buttonText: String {
        switch self {
        case .report:
            return "Сыграть еще раз"
        case .error:
            return "Попробовать еще раз"
        }
    }
}
