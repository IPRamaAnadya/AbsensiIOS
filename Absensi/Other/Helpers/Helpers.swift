//
//  JsonToModel.swift
//  Absensi
//
//  Created by I putu Rama anadya on 19/09/23.
//

import Foundation


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
    
    func ParsingJsonToModel<T: Decodable>(_ type: T.Type, from json: Data) -> T? {
        let decoder = JSONDecoder()
        do {
            let data = try decoder.decode(type, from: json)
            
            print("Success parsing Json to model")
            return data
        } catch {
            print("Failed parsing Json to model")
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
    
}
