//
//  Categories.swift
//  tiX
//
//  Created by Nicolas Ott on 26.10.21.
//

import SwiftUI
import CoreData

struct Categories: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    @ObservedObject var settings: UserSettings
    @Binding var tabSelected: Int
    @FetchRequest(entity: Category.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)]) var categories: FetchedResults<Category>
    @FetchRequest(entity: Todo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todo.timestamp, ascending: false)]) var todos: FetchedResults<Todo>

    @State var newCategory = false
    
    // Inline Edit
    @State private var inlineEdit = false
    @State private var inlineItem = UUID()
    @State private var inlineCat = ""
       
    @State private var accentColor = Color.white
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    withAnimation {
                        self.tabSelected = 4
                    }
                }) {
                    Image(systemName: "gear").foregroundColor(Color(settings.globalForeground)).font(.title2)
                }
                .buttonStyle(PlainButtonStyle())
                Spacer()
                
                Button(action: {
                    withAnimation {
                        newCategory.toggle()
                    }
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(Color(settings.globalForeground)).font(.title)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            HStack {
                Text(loc_categories)
                    .font(.title).bold()
                    .foregroundColor(Color(settings.globalForeground))
                    .frame(alignment: .leading)
                    .padding(.top)
                Spacer()
                
            }
            
            ScrollView {
                
                ForEach(categories, id: \.self) { cat in
                    
                    // Inline Edit
                    if inlineEdit && cat.id == inlineItem {
                        
                        CategoryEdit(settings: settings, cat: cat, inlineEdit: $inlineEdit, inlineItem: $inlineItem, inlineCat: cat.name ?? "", inlineColor: cat.color?.color ?? Color.tix, accentColor: $accentColor)
                        
                    } else {

                        VStack(alignment: .leading) {
                            HStack(alignment: .center) {
                                Image(systemName: "square.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(cat.color?.color ?? Color.tix)
                                    .padding(.trailing, 10)
                                    .padding(.bottom, 10)
                                    .padding(.top, 10)
                                
                                Text(cat.name ?? "category")
                                    .font(.callout)
                                    .foregroundColor(cat.color?.color ?? Color.tix)
                                Spacer()
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
                        }
                    }
                }
            }

        }
        .sheet(isPresented: $newCategory) { CategoryNew(settings: settings) }
        .accentColor(self.accentColor)
        .padding(.leading).padding(.trailing)
        .background(Color(settings.globalBackground))
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
    }

    private func onAppear() {
        self.accentColor = Color(settings.globalForeground)
    }

    private func onDisappear() {
        inlineEdit = false
        inlineItem = UUID()
    }
    
}
private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()


