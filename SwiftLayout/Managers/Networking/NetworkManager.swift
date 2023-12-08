//
//  NetworkManager.swift
//  SwiftLayout
//

import Foundation

/*
 Simulates a network layer by sleeping the caller's thread for a few seconds before returning the requested data
 */


class NetworkManager {
    private static let MaxWaitingSec: UInt32 = 5
    private static let OnboardingFilename = "questions"

    static func getOnboarding() -> Data? {
        return getData(filename: OnboardingFilename)
    }

    /*
     Retrieves the given JSON file after blocking the current thread
     for 1-5 seconds, simulating a network delay.
     */
    private static func getData(filename: String) -> Data? {
        addLatency()

        if let path = Bundle.main.url(forResource: filename, withExtension: "json"),
            let data = try? Data.init(contentsOf: path) {
            return data
        } else {
            return nil
        }
    }

    private static func addLatency() {
        sleep(arc4random_uniform(MaxWaitingSec) + 1)
    }
}
