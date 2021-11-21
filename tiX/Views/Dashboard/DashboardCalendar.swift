//
//  DashboardCalendar.swift
//  tiX
//
//  Created by Nicolas Ott on 17.11.21.
//

import SwiftUI
import EventKit

struct DashboardCalendar: View {
    
    @ObservedObject var settings: UserSettings
    @State var eventStore = EKEventStore()
    @Binding var calEvents: [EKEvent]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Image(systemName: "calendar")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color(settings.globalText))
                    .padding(.trailing, 10)
                    .padding(.top, 5).padding(.bottom, 5)
                
                VStack(alignment: .leading){
                    if calEvents.count == 0 {
                        HStack(alignment: .center) {
                            Text(loc_no_events)
                                .font(.subheadline)
                                .foregroundColor(Color(settings.globalText))
                                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                                    onAppear()
                                }
                            Spacer()
                        }
                    } else {
                        ForEach(calEvents, id: \.self) { event in
                            HStack(alignment: .center) {
                                Text("\(event.startDate, formatter: timeFormatter) \(event.title)")
                                    .font(.subheadline)
                                    .foregroundColor(Color(settings.globalText))
                                Spacer()
                            }
                        }
                    }
                }.padding(.top, 5).padding(.bottom, 5)
            }
            .padding(.leading).padding(.trailing)
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(settings.globalBackground == "White" ? Color.tix : Color(settings.globalForeground), lineWidth: 1).padding(1)
            )
            .frame(maxWidth: .infinity)
            
        }
        .padding(.bottom, 5)
        .onAppear(perform: onAppear)
    }
    
    func onAppear() {
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            if granted {
                DispatchQueue.main.async {
                    let today = Date().midnight
                    var dateComps = DateComponents()
                    dateComps.day = 1
                    let endDate = Calendar.current.date(byAdding: dateComps, to: today)
                    let predicate = self.eventStore.predicateForEvents(withStart: today, end: endDate ?? Date(), calendars: nil)
                    self.calEvents = self.eventStore.events(matching: predicate)
                    
                }
            }
        }
    }
}

private let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter
}()
