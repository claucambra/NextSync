//
//  AppCommunicationService.swift
//  NextSyncKit
//
//  Created by Claudio Cambra on 21/4/24.
//

import FileProvider
import Foundation

public let AppCommunicationServiceName = NSFileProviderServiceName(
    Bundle.main.bundleIdentifier! + "AppCommunicationService"
)

@objc public protocol AppCommunicationService {
    func domainIdentifierString() async -> String
    func authenticate(serverUrl: URL, username: String, password: String)
}
