//
//  AccountModel.swift
//  NextSync
//
//  Created by Claudio Cambra on 19/4/24.
//

import Foundation
import NextcloudFileProviderKit
import NextcloudKit
import SwiftData

@Model
public final class AccountModel {
    public enum SyncError: Error {
        case couldNotGetUserProfile(String)
    }

    public var serverUrl: URL
    public var displayname: String
    public var username: String
    public var userId: String = ""
    @Attribute(.allowsCloudEncryption) public var password: String
    public var domainIdentifier: String?

    @Transient public var ncKitAccount: String {
        Account.ncKitAccountString(from: username, serverUrl: serverUrl.absoluteString)
    }
    @Transient public var description: String {
        """
        AccountModel
        serverUrl: \(serverUrl),
        displayname: \(displayname),
        username: \(username),
        userId: \(userId),
        domainIdentifier: \(domainIdentifier ?? "NONE"),
        password: \(password.isEmpty ? "EMPTY" : "NON-EMPTY")
        """
    }

    public init(
        serverUrl: URL,
        displayname: String = "",
        username: String,
        userId: String,
        password: String,
        domainIdentifier: String? = nil
    ) {
        self.serverUrl = serverUrl
        self.displayname = displayname
        self.username = username
        self.userId = userId
        self.password = password
        self.domainIdentifier = domainIdentifier
    }

    public func toFileProviderKitAccount() -> Account {
        Account(user: username, id: userId, serverUrl: serverUrl.absoluteString, password: password)
    }

    public func addToNcKitSessions() {
        assert(!ncKitAccount.isEmpty)
        NextcloudKit.shared.appendSession(
            account: ncKitAccount,
            urlBase: serverUrl.absoluteString,
            user: username,
            userId: userId,
            password: password,
            userAgent: "NextSync",
            nextcloudVersion: 25,
            groupIdentifier: ""
        )
    }

    public func syncWithServer(
        options: NKRequestOptions = .init(),
        taskHandler: @escaping (_ task: URLSessionTask) -> Void = { _ in }
    ) async -> SyncError? {
        addToNcKitSessions()
        assert(NextcloudKit.shared.getSession(account: ncKitAccount) != nil)

        let (_, userProfile, _, error) = await NextcloudKit.shared.fetchUserProfile(
            account: toFileProviderKitAccount(), options: options, taskHandler: taskHandler
        )
        guard error == .success, let userProfile else {
            return .couldNotGetUserProfile(error.errorDescription)
        }
        displayname = userProfile.displayName
        userId = userProfile.userId

        return nil
    }
}
