//
//  tixWidget.swift
//  tixWidget
//
//  Created by Nicolas Ott on 28.10.21.
//

import WidgetKit
import SwiftUI

struct widgetBundle: WidgetBundle {
    var body: some Widget {
        tixWidget()
        //tixWidgetPro()
    }
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let one: String = String(UserDefaults(suiteName: "group.de.nicolasott.tiX")!.string(forKey: "one") ?? "")
    let oneTicked: Bool = Bool(UserDefaults(suiteName: "group.de.nicolasott.tiX")!.bool(forKey: "oneTicked"))
    let two: String = String(UserDefaults(suiteName: "group.de.nicolasott.tiX")!.string(forKey: "two") ?? "")
    let twoTicked: Bool = Bool(UserDefaults(suiteName: "group.de.nicolasott.tiX")!.bool(forKey: "twoTicked"))
    let three: String = String(UserDefaults(suiteName: "group.de.nicolasott.tiX")!.string(forKey: "three") ?? "")
    let threeTicked: Bool = Bool(UserDefaults(suiteName: "group.de.nicolasott.tiX")!.bool(forKey: "threeTicked"))
    let open: Int = Int(UserDefaults(suiteName: "group.de.nicolasott.tiX")!.integer(forKey: "open"))
}

@main
struct tixWidget: Widget {
    let kind: String = "tixWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            tixWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall, .systemMedium])
        .configurationDisplayName("tiX")
        .description("tiX Todos")
    }
}

struct tixWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Todos (\(entry.open))")
                .font(.callout).bold()
                .foregroundColor(Color.white)
                .padding(5).padding(.leading, 10).padding(.top, 10)
            HStack(alignment: .center){
                Image(systemName: entry.oneTicked ? "circle.fill" : "circle")
                    .foregroundColor(Color.white)
                Text(entry.one)
                    .font(.callout)
                    .foregroundColor(Color.white)
                Spacer()
            }.frame(maxWidth: .infinity).padding(5).padding(.leading, 10)
            HStack(alignment: .center){
                Image(systemName: entry.twoTicked ? "circle.fill" : "circle")
                    .foregroundColor(Color.white)
                Text(entry.two)
                    .font(.callout)
                    .foregroundColor(Color.white)
                Spacer()
            }.frame(maxWidth: .infinity).padding(5).padding(.leading, 10)
            HStack(alignment: .center){
                Image(systemName: entry.threeTicked ? "circle.fill" : "circle")
                    .foregroundColor(Color.white)
                Text(entry.three)
                    .font(.callout)
                    .foregroundColor(Color.white)
                Spacer()
            }.frame(maxWidth: .infinity).padding(5).padding(.leading, 10)
            Spacer()
            Spacer()
        }.background(Color("tix"))
    }
}
