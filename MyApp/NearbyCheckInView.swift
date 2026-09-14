import CoreLocation
import Foundation
import SwiftUI
import os

private let checkInLogger = Logger(
    subsystem: Bundle.main.bundleIdentifier ?? "MyApp",
    category: "CheckIn"
)

private let checkInAppGroupIdentifier = "group.devplaceholder.KAIBSX55.MyApp.shared"
private let lastCheckInDefaultsKey = "lastCheckIn"

struct CheckInRecord: Codable {
    var latitude: Double
    var longitude: Double
    var savedAt: Date
}

struct NearbyCheckInView: View {
    @State private var isCheckingIn = false
    @State private var lastCheckIn: CheckInRecord?
    @State private var statusMessage: String?

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                lastCheckInSection

                if let statusMessage {
                    Text(statusMessage)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .accessibilityIdentifier("checkInStatusText")
                }

                Spacer()

                Button(action: checkInTapped) {
                    if isCheckingIn {
                        ProgressView()
                    } else {
                        Text("Check In Here")
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(isCheckingIn)
                .accessibilityIdentifier("checkInButton")
            }
            .padding()
            .navigationTitle("Nearby Check-In")
        }
    }

    private var lastCheckInSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Last Check-In")
                .font(.headline)

            if let lastCheckIn {
                LabeledContent("Latitude") {
                    Text(lastCheckIn.latitude, format: .number.precision(.fractionLength(4)))
                }
                .accessibilityIdentifier("checkInLatitudeValue")

                LabeledContent("Longitude") {
                    Text(lastCheckIn.longitude, format: .number.precision(.fractionLength(4)))
                }
                .accessibilityIdentifier("checkInLongitudeValue")

                LabeledContent("Saved At") {
                    Text(lastCheckIn.savedAt, format: .dateTime)
                }
                .accessibilityIdentifier("checkInSavedAtValue")
            } else {
                Text("No check-in yet.")
                    .foregroundStyle(.secondary)
                    .accessibilityIdentifier("checkInEmptyStateText")
            }
        }
        .accessibilityIdentifier("lastCheckInSection")
    }

    private func checkInTapped() {
        Task { await performCheckIn() }
    }

    private func performCheckIn() async {
        isCheckingIn = true
        statusMessage = nil
        defer { isCheckingIn = false }

        let manager = CLLocationManager()
        var previousAuthorizationStatus = manager.authorizationStatus
        checkInLogger.info("Starting check-in with authorization status \(previousAuthorizationStatus.rawValue, privacy: .public)")

        do {
            for try await update in CLLocationUpdate.liveUpdates() {
                let currentAuthorizationStatus = manager.authorizationStatus
                if currentAuthorizationStatus != previousAuthorizationStatus {
                    checkInLogger.info("Authorization changed from \(previousAuthorizationStatus.rawValue, privacy: .public) to \(currentAuthorizationStatus.rawValue, privacy: .public)")
                    previousAuthorizationStatus = currentAuthorizationStatus
                }

                if let location = update.location {
                    checkInLogger.info("Received location fix: \(location.coordinate.latitude, privacy: .public), \(location.coordinate.longitude, privacy: .public)")
                    save(location: location)
                    break
                } else if update.authorizationDenied {
                    checkInLogger.notice("Location authorization denied by user")
                    statusMessage = String(localized: "Location access was denied. Enable it in Settings to check in here.")
                    break
                }
            }
        } catch {
            checkInLogger.error("Location update stream failed: \(error.localizedDescription, privacy: .public)")
            statusMessage = String(localized: "We couldn't get your location. Please try again.")
        }
    }

    private func save(location: CLLocation) {
        let record = CheckInRecord(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            savedAt: Date()
        )

        guard let defaults = UserDefaults(suiteName: checkInAppGroupIdentifier) else {
            checkInLogger.error("Failed to open App Group defaults for \(checkInAppGroupIdentifier, privacy: .public)")
            statusMessage = String(localized: "We couldn't save your check-in.")
            return
        }

        do {
            let data = try JSONEncoder().encode(record)
            defaults.set(data, forKey: lastCheckInDefaultsKey)
            lastCheckIn = record
            checkInLogger.info("Saved check-in to App Group storage")
            statusMessage = String(localized: "Check-in saved.")
        } catch {
            checkInLogger.error("Failed to encode check-in record: \(error.localizedDescription, privacy: .public)")
            statusMessage = String(localized: "We couldn't save your check-in.")
        }
    }
}

#Preview {
    NearbyCheckInView()
}
