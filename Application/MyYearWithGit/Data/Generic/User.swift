//
//  Emails.swift
//  MyYearWithGit
//
//  Created by Lakr Aream on 2021/12/4.
//

import Foundation

private let userDefaultKey = "wiki.qaq.mywg.emails"

class User {
    static let current = User()

    public var email: Set<String> = [] {
        didSet {
            if let data = try? JSONEncoder().encode(email) {
                UserDefaults.standard.set(data, forKey: userDefaultKey)
            }
        }
    }

    @UserDefaultsWrapper(key: "wiki.qaq.mywg.name", defaultValue: "")
    public var namespace: String

    private init() {
        if let data = UserDefaults.standard.value(forKey: userDefaultKey) as? Data,
           let build = try? JSONDecoder().decode([String].self, from: data)
        {
            email = Set<String>(build)
        }
        let command = AuxiliaryExecute.spawn(
            command: AuxiliaryExecute.git,
            args: ["config", "user.email"],
            timeout: 1
        ) { str in
            debugPrint(str)
        }
        let gitEmail = command
            .1
            .trimmingCharacters(in: .whitespacesAndNewlines)
        if gitEmail.count > 0 {
            debugPrint("found email: \(gitEmail)")
            email.insert(gitEmail)
        }
    }
}
