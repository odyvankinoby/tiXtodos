//
//  Categories.swift
//  tiX
//
//  Created by Nicolas Ott on 26.10.21.
//

import SwiftUI
import CoreData

struct Categories: View {
    
    @Environment(\.managedObjectContext) var viewContext

    @ObservedObject var settings: UserSettings
    @StateObject var storeManager: StoreManager
    @Binding var tabSelected: Int
    @FetchRequest(entity: Category.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)]) var categories: FetchedResults<Category>
    @FetchRequest(entity: Todo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todo.timestamp, ascending: false)]) var todos: FetchedResults<Todo>
    
    // Inline Edit
    @State private var inlineEdit = false
    @State private var inlineItem = UUID()
    @State private var inlineCat = ""
       
    @State private var accentColor = Color.white
    
    @State var showPremium = false
    
    var body: some View {
        VStack {
            
            HStack {
                Spacer()
                Button(action: {
                    withAnimation {
                        self.tabSelected = 4
                    }
                }) {
                    Image(systemName: "gear").foregroundColor(Color(settings.globalForeground)).font(.title)
                        .padding(.top)
                }
            }
            
            HStack {
                Text(loc_categories)
                    .font(.title).bold()
                    .foregroundColor(Color(settings.globalForeground))
                    .frame(alignment: .leading)
                    .padding(.top, 5)
                Spacer()
                
            }
            ZStack {
            ScrollView {
                
                ForEach(categories, id: \.self) { cat in
                    
                    // Inline Edit
                    if inlineEdit && cat.id == inlineItem {
                        
                        CategoryEdit(settings: settings,
                                     cat: cat,
                                     inlineEdit: $inlineEdit,
                                     inlineItem: $inlineItem,
                                     inlineCat: cat.name ?? "",
                                     inlineColor: cat.color?.color ?? Color.tix,
                                     accentColor: $accentColor).environment(\.managedObjectContext, viewContext)
                        
                    } else {

                        //VStack(alignment: .leading) {
                            HStack(alignment: .center) {
                                Image(systemName: "square.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(cat.color?.color ?? Color.tix)
                                    .padding(.trailing, 10)
                                    .padding(.bottom)
                                    .padding(.top)
                                
                                
                                VStack(alignment: .leading){
                                    HStack(alignment: .top) {
                                        Text(cat.name ?? "category")
                                            .font(.headline)
                                            .foregroundColor(cat.color?.color ?? Color.tix)
                                        Spacer()
                                    }
                                    HStack(alignment: .bottom) {
                                        Text("\(cat.todo?.count ?? 0) Todo(s)")
                                            .font(.subheadline)
                                            .foregroundColor(cat.color?.color ?? Color.tix)
                                        Spacer()
                                    }
                                }
                            }
                            .onTapGesture {
                                withAnimation {
                                    if !inlineEdit {
                                        inlineEdit = true
                                        inlineItem = cat.id ?? UUID()
                                        inlineCat = cat.name ?? ""
                                        accentColor = cat.color?.color ?? Color.tix
                                    }
                                }
                            }
                            .padding(.leading)
                            .padding(.trailing)
                            .padding(.top, 5).padding(.bottom, 5)
                            .background(Color.white)
                            .cornerRadius(10)
                            .frame(maxWidth: .infinity)
                            .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(settings.globalBackground == "White" ? Color.tix : Color(settings.globalForeground), lineWidth: 1).padding(1)
                                )
                        //}
                    }
                }
            }
                VStack(alignment: .trailing) {
                    Spacer()
                    Spacer()
                    Spacer()
                    HStack {
                        Spacer()
                        Spacer()
                        Button(action: {
                            withAnimation {
                                createCategory()
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(Color(settings.globalForeground))
                                .shadow(color: Color(settings.globalBackground).opacity(0.5), radius: 10, x: 0, y: 0)
                        }.padding(.bottom,30)
                    }
                }
                .padding(.bottom)
                .frame(maxWidth: .infinity)
                
                }

        }
        .sheet(isPresented: self.$showPremium) {
            InAppPurchase(settings: settings, storeManager: storeManager)
        }
        .accentColor(self.accentColor)
        .padding(.leading).padding(.trailing)
        .background(Color(settings.globalBackground))
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
    }

    private func onAppear() {
        self.accentColor = Color(settings.globalText)
    }

    private func onDisappear() {
        inlineEdit = false
        inlineItem = UUID()
    }
    
    private func createCategory() {
        if (categories.count > 2 ) && settings.purchased == false {
            showPremium.toggle()
        } else {
            newCategory()
        }
    }
   
    func newCategory() {
        let newC = Category(context: self.viewContext)
        newC.name = "Name"
        newC.color = SerializableColor(from: Color.tix)
        newC.timestamp = Date()
        newC.id = UUID()
        do {
            try self.viewContext.save()
            inlineEdit = true
            inlineItem = newC.id ?? UUID()
            inlineCat = newC.name ?? ""
            accentColor = Color.tix
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    
}
private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()


