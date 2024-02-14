import Dependencies

enum Registration {
    struct Provider {
        var provide: () -> String
    }
}

// Unique key to identify the dependency in the graph
private enum RegistrationProviderDependencyKey: DependencyKey {
    static let liveValue: Registration.Provider = Registration.Provider { "live value" }
}

// Adds the keyPath to the dependency values
extension DependencyValues {
    var registrationProvider: Registration.Provider {
        get { self[RegistrationProviderDependencyKey.self] }
        set { self[RegistrationProviderDependencyKey.self] = newValue }
    }
}


// Different implementations need their own keys and key paths:
private enum OtherRegistrationProviderDependencyKey: DependencyKey {
    static let liveValue: Registration.Provider = Registration.Provider { "other value" }
}
extension DependencyValues {
    var otherRegistrationProvider: Registration.Provider {
        get { self[OtherRegistrationProviderDependencyKey.self] }
        set { self[OtherRegistrationProviderDependencyKey.self] = newValue }
    }
}
