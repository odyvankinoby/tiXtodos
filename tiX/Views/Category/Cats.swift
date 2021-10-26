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
    
    @FetchRequest(entity: Category.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Category.category, ascending: true)]) var categories: FetchedResults<Category>

    @State var newCategory = false
   
    var body: some View {
        NavigationView {
            
           
            List {
                ForEach(categories, id: \.self) { cat in
                    
                   
                    NavigationLink(destination: EditCategory(cat: cat).environment(\.managedObjectContext, self.viewContext))
                    {
                        VStack(alignment: .leading){
                            HStack(alignment: .center){
                                Image(systemName: "square.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .onTapGesture {
                                        withAnimation {
                                            /*ViewContextMethods.isDone(todo: todo, context: viewContext)*/
                                        }
                                    }
                                    .foregroundColor(.tix)
                                    .padding(.trailing, 10)
                                    .padding(.bottom, 10)
                                    .padding(.top, 10)
                                
                                Text(cat.category ?? "category")
                                    .font(.callout)
                                    .foregroundColor(.tix)
                                Spacer()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                    
                    }
                }.onDelete(perform: deleteItems(offsets:))
                    .listStyle(PlainListStyle())
               
            }
            .navigationBarTitle("Categories", displayMode: .automatic).allowsTightening(true)
            .toolbar {
               
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                   
                    
                    Button(action: {
                        withAnimation {
                            newCategory.toggle()
                            Haptics.giveSmallHaptic()
                        }
                        Haptics.giveSmallHaptic()
                    }) {
                        Image(systemName: "plus")
                            .resizable()
                            .foregroundColor(.tix)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    
                }
            }
            .sheet(isPresented: $newCategory) { NewCategory() }

        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(.tix) // NAV
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


