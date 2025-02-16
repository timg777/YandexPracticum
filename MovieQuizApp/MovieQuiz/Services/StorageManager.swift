import Foundation


final class StorageManager: StorageManagerProtocol {
    
    private let storage: UserDefaults = .standard

    func store(key: UserDefaultsKey, value: any Storable) {
        let data = encode(value, forKey: key)
        storage.set(data, forKey: key.rawValue)
    }
    
    func get<T: Storable>(forKey: UserDefaultsKey) -> T? {
        guard let data = storage.data(forKey: forKey.rawValue) else { return nil }
        return decode(T.self, data: data)
    }
    
}

private extension StorageManager {
    func encode<T: Encodable>(_ value: T, forKey key: UserDefaultsKey) -> Encodable {
        try? JSONEncoder().encode(value)
    }
    func decode<T: Decodable>(_ type: T.Type, data: Data) -> T? {
        try? JSONDecoder().decode(T.self, from: data)
    }
}
