//
//  SubscriptionToNewMessage.swift
//  Runner
//
//  Created by Mehdi SLIMANI on 05/07/2018.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

import Foundation
import AWSCore
import AWSAppSync

/*
 * Task for execute the subscription SubscribeToNewMessage in GraphQL file
 * subscription SubscribeToNewMessage {
 *  subscribeToNewMessage {
 *      id
 *      content
 *      sender
 *  }
 * }
 */
class SubscriptionToNewMessage {
    
    private let client: AWSAppSyncClient
    static var channel: FlutterMethodChannel?
    static var subscriptionWatcher: Cancellable?

    init(client: AWSAppSyncClient, channel: FlutterMethodChannel) {
        self.client = client
        SubscriptionToNewMessage.channel = channel
    }
    
    
    public func exec(flutterMethodCall: FlutterMethodCall, flutterResult: @escaping FlutterResult) {
        
        guard SubscriptionToNewMessage.subscriptionWatcher == nil else { return }

        do {
            let subscription = SubscribeToNewMessageSubscription()
            SubscriptionToNewMessage.subscriptionWatcher = try self.client.subscribe(subscription: subscription) { [weak self] result, transaction, error in

                if let result = result {
                    if let subscribeToNewMessage = result.data?.subscribeToNewMessage {
                        let values:[String:Any] = [
                            "id" : subscribeToNewMessage.id,
                            "content" : subscribeToNewMessage.content,
                            "sender" : subscribeToNewMessage.sender
                        ]
                        
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: values, options: .prettyPrinted)
                            let convertedString = String(data: jsonData, encoding: String.Encoding.utf8)
                            print("from ios: \(convertedString ?? "")")
                            SubscriptionToNewMessage.channel?.invokeMethod(AppSyncPlugin.SUBSCRIBE_NEW_MESSAGE_RESULT, arguments: convertedString)
                        } catch {
                            flutterResult(FlutterError(code: "1", message: error.localizedDescription, details: nil))
                        }
                    }
                    
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
            print (SubscriptionToNewMessage.subscriptionWatcher ?? "no watcher")
        } catch {
            print("Error starting subscription.")
        }
    }
}

