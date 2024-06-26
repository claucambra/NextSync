//
//  AccountModel.swift
//  NextSync
//
//  Created by Claudio Cambra on 19/4/24.
//

import Foundation
import SwiftData

@Model
public final class AccountModel {
    public var serverUrl: URL
    public var displayname: String
    public var username: String
    @Attribute(.allowsCloudEncryption) public var password: String
    public var domainIdentifier: String?

    @Transient public var description: String {
        """
        AccountModel
        serverUrl: \(serverUrl),
        displayname: \(displayname),
        username: \(username),
        domainIdentifier: \(domainIdentifier ?? "NONE"),
        password: \(password.isEmpty ? "EMPTY" : "NON-EMPTY")
        """
    }

    public init(
        serverUrl: URL,
        displayname: String = "",
        username: String,
        password: String,
        domainIdentifier: String? = nil
    ) {
        self.serverUrl = serverUrl
        self.displayname = displayname
        self.username = username
        self.password = password
        self.domainIdentifier = domainIdentifier
    }
}
