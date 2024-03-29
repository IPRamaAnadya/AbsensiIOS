//
//  JsonToModel.swift
//  Absensi
//
//  Created by I putu Rama anadya on 19/09/23.
//

import SwiftUI
import FirebaseAnalytics

class Helpers {
    
    static let shared = Helpers()
    
    private init() {}
    
    
    
    // Create a helper function to convert epoch time to a human-readable date
    func date(fromEpoch epoch: Int) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(epoch))
    }
    
    func dateFormatter(from epoch: Int) -> String {
        return DateFormatter.localizedString(from: date(fromEpoch: epoch), dateStyle: .medium, timeStyle: .none)
    }
    
    func timeFormatter(from epoch: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = date(fromEpoch: epoch)
        return dateFormatter.string(from: date)
    }
    
    func ParsingJsonToModel<T: Decodable>(_ type: T.Type, from json: Data) -> T? {
        let decoder = JSONDecoder()
        do {
            let data = try decoder.decode(type, from: json)
            
            print("Berhasil parsing Json ke model \(T.self)\n")
            return data
        } catch {
            print("Gagal parsing Json ke model\n")
            return nil
        }
    }
    
    func parseNotificationResponse(_ notificationResponse: NotificationResponse) -> [NotificationWithSection] {
        var notificationWithSections = [NotificationWithSection]()
        
        // Check if riwayatNotifikasi exists and is not empty
        if let notifications = notificationResponse.riwayatNotifikasi, !notifications.isEmpty {
            // Create a dictionary to group notifications by date
            var groupedNotifications = [String: [NotificationEntity]]()
            
            for notification in notifications {
                if let createdAt = notification.createdAt {
                    // Convert createdAt to a human-readable date string as the section
                    let section = DateFormatter.localizedString(from: date(fromEpoch: createdAt), dateStyle: .medium, timeStyle: .none)
                    
                    // Append the notification to the corresponding section
                    if var sectionNotifications = groupedNotifications[section] {
                        sectionNotifications.append(notification)
                        groupedNotifications[section] = sectionNotifications
                    } else {
                        groupedNotifications[section] = [notification]
                    }
                }
            }
            
            // Convert the grouped notifications into NotificationWithSection objects
            notificationWithSections = groupedNotifications.map { (section, notifications) in
                return NotificationWithSection(section: section, notifications: notifications)
            }
            
            // Sort the notificationWithSections array based on section dates (newer to older)
            notificationWithSections.sort { (lhs, rhs) in
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                dateFormatter.timeStyle = .none
                if let date1 = dateFormatter.date(from: lhs.section), let date2 = dateFormatter.date(from: rhs.section) {
                    return date1 > date2
                }
                return false
            }
        }
        
        return notificationWithSections
    }
    
    func parseHistoriesResponse(_ historiesResponse: HistoriesResponse) -> [HistoriesWithSection] {
        var historiesWithSections = [HistoriesWithSection]()
        
        // Check if riwayatNotifikasi exists and is not empty
        if let histories = historiesResponse.riwayatAbsensi, !histories.isEmpty {
            // Create a dictionary to group notifications by date
            var groupedHistories = [String: [HistoryEntity]]()
            
            for history in histories {
                if let createdAt = history.tanggal {
                    // Convert createdAt to a human-readable date string as the section
                    let section = DateFormatter.localizedString(from: date(fromEpoch: createdAt), dateStyle: .medium, timeStyle: .none)
                    
                    // Append the notification to the corresponding section
                    if var sectionHistories = groupedHistories[section] {
                        sectionHistories.append(history)
                        groupedHistories[section] = sectionHistories
                    } else {
                        groupedHistories[section] = [history]
                    }
                }
            }
            
            // Convert the grouped notifications into NotificationWithSection objects
            historiesWithSections = groupedHistories.map { (section, histories) in
                return HistoriesWithSection(section: section, histories: histories)
            }
            
            // Sort the notificationWithSections array based on section dates (newer to older)
            historiesWithSections.sort { (lhs, rhs) in
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                dateFormatter.timeStyle = .none
                if let date1 = dateFormatter.date(from: lhs.section), let date2 = dateFormatter.date(from: rhs.section) {
                    return date1 > date2
                }
                return false
            }
        }
        
        return historiesWithSections
    }
    
    func parseEventStatusColor(from status: Int?) -> Color {
        guard let status = status else {
            return Color(red: 201, green: 201, blue: 201)
        }
        if status == 1 {
            return Color(red: 30, green: 215, blue: 96)
        }
        if status == 2 {
            return Color(red: 30, green: 215, blue: 96)
        }
        if status == 3 {
            return Color(red: 246, green: 146, blue: 0)
        }
        if status == 4 {
            return Color(red: 255, green: 0, blue: 0)
        }
        
        return Color(red: 201, green: 201, blue: 201)
    }
    
    func analyticsLog(itemID: String, itemName: String, contentType: AppAnalyticContentType) {
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
          AnalyticsParameterItemID: "\(itemID)" as NSObject,
          AnalyticsParameterItemName: itemName as NSObject,
          AnalyticsParameterContentType: contentType.rawValue as NSObject,
        ])
    }
    
}

enum AppAnalyticContentType: String {
    case automatic = "automatic"
    case button = "button"
    case bottomBar = "bottom_bar"
    case iconButton = "icon_button"
    case card = "card"
    case scroll = "scroll"
}
