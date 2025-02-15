protocol Storable: Hashable, Codable {}

protocol StorageManagerProtocol {
    func store(key: UserDefaultsKey, value: any Storable)
    func get<T: Storable>(forKey: UserDefaultsKey) -> T?
}
