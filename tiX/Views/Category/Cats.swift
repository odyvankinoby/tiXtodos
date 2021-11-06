//
//  Categories.swift
//  tiX
//
//  Created by Nicolas Ott on 26.10.21.
//

import SwiftUI
import CoreData

struct Cats: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    @ObservedObject var settings: UserSettings
    @Binding var tabSelected: Int
    @FetchRequest(entity: Category.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)]) var categories: FetchedResults<Category>

    @State var newCategory = false
   
    var body: some View {
        VStack {
            HStack {
                
                Button(action: {
                    withAnimation {
                        self.tabSelected = 4
                    }
                }) {
                    Image(systemName: "gear").foregroundColor(.white).font(.title2)
                }
                .buttonStyle(PlainButtonStyle())
                Spacer()
                
                Button(action: {
                    withAnimation {
                        newCategory.toggle()
                    }
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.white).font(.title)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            HStack {
                Text(loc_categories)
                    .font(.title).bold()
                    .foregroundColor(Color.white)
                    .frame(alignment: .leading)
                    .padding(.top)
                Spacer()
                
            }
            
            //ScrollView {
            
           
            List {
                ForEach(categories, id: \.self) { cat in
                    
                   
                    NavigationLink(destination: EditCategory(cat: cat).environment(\.managedObjectContext, self.viewContext))
                    {
                        VStack(alignment: .leading){
                            HStack(alignment: .center){
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
                        }
                        .frame(maxWidth: .infinity)
                        
                    
                    }
                }.onDelete(perform: deleteItems(offsets:))
                    .listStyle(PlainListStyle())
                    .listRowBackground(Color.clear)
            }

        }
        .sheet(isPresented: $newCategory) { NewCategory() }
        .accentColor(.white)
        .padding(.leading).padding(.trailing)
        .background(Color.tix)
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { categories[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
               
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func textChanged(upper: Int, text: inout String) {
        if text.count > upper {
            text = String(text.prefix(upper))
        }
    }
}
private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()


