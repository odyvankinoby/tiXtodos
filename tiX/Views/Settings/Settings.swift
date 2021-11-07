//
//  Settings.swift
//  tiX
//
//  Created by Nicolas Ott on 09.10.21.
//

import SwiftUI
import UIKit
import MessageUI
import WebKit
import CoreData

struct Settings: View {
    
    // Observable Objects
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var settings: UserSettings
    @Binding var tabSelected: Int
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var noMail = false
    @State var deletedTodos = 0
    @State var inlineEdit = false
    @State var showAbout = false
    @FocusState private var isFocused: Bool
    
    @State var colorz1 = ["tix", "tixDark", "Brown", "Blue", "Cyan"]
    @State var colorz2 = ["Green", "Orange", "Red", "Purple", "Magenta"]
    
    var body: some View {
        
        VStack {
            HStack {
                Button(action: {
                    withAnimation {
                        self.tabSelected = 1
                    }
                }) {
                    Image(systemName: "house").foregroundColor(.white).font(.title2)
                }
                .buttonStyle(PlainButtonStyle())
                Spacer()
                Button(action: {
                    withAnimation {
                        self.tabSelected = 2
                    }
                }) {
                    Image(systemName: "list.bullet").foregroundColor(.white).font(.title2)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            HStack {
                Text(loc_settings)
                    .font(.title).bold()
                    .foregroundColor(Color.white)
                    .frame(alignment: .leading)
                    .padding(.top)
                Spacer()
                
            }
            
            ScrollView {
                
                VStack(alignment: .leading) {
                    
                    HStack {
                        Text(loc_name)
                            .frame(alignment: .leading)
                            .foregroundColor(.tix)
                        Spacer()
                        if !inlineEdit {
                            Text(settings.userName)
                                .frame(alignment: .trailing)
                                .foregroundColor(.tixDark)
                                .onTapGesture {
                                    withAnimation {
                                        inlineEdit = true
                                        isFocused = true
                                    }
                                }
                        } else {
                            Button(action: {
                                withAnimation {
                                    inlineEdit = false
                                    isFocused = false
                                }
                            }) {
                                Image(systemName: "checkmark.circle").resizable()
                                    .frame(width: 24, height: 24, alignment: .top).foregroundColor(.tix)
                            }
                        }
                    }
                    
                    if inlineEdit {
                        TextField("", text: $settings.userName)
                            .focused($isFocused)
                            .frame(alignment: .trailing)
                            .foregroundColor(Color.tixDark)
                    }
                    
                    Divider()
                    
                    Toggle(isOn: $settings.hideTicked) {
                        Text(loc_hide_ticked)
                            .foregroundColor(.tix).frame(alignment: .trailing)
                    }
                    
                    Divider()
                    
                    HStack {
                        Text(loc_delete_ticked)
                            .frame(alignment: .leading)
                            .foregroundColor(.tix)
                        Spacer()
                        Spacer()
                        Button(action: {
                            withAnimation {
                                deleteTicked()
                            }
                        }) {
                            HStack {
                                Image(systemName: "circle.slash.fill")
                                Text(loc_delete)
                            }
                        }
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.tix)
                        .cornerRadius(8)
                        
                    }
                    
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .frame(maxWidth: .infinity)
                
                
                VStack(alignment: .leading) {
                    HStack {
                        Spacer()
                        ForEach(colorz1, id: \.self) { col in
                            Button(action: {
                                withAnimation {
                                    settings.globalBackground = col
                                }
                            }) {
                                
                                Image(systemName: col == settings.globalBackground ? "dot.square.fill" : "square.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(Color(col))
                                   
                            }
                            Spacer()
                        }
                        
                    }
                    HStack {
                        Spacer()
                        ForEach(colorz2, id: \.self) { col in
                            Button(action: {
                                withAnimation {
                                    settings.globalBackground = col
                                }
                            }) {
                                
                                Image(systemName: col == settings.globalBackground ? "dot.square.fill" : "square.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(Color(col))
                                  
                            }
                            Spacer()
                        }
                        
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .frame(maxWidth: .infinity)
                
                VStack(alignment: .leading) {
                    
                    HStack {
                        Text(loc_help).frame(alignment: .leading).foregroundColor(.tix)
                        Spacer()
                    }.frame(alignment: .leading).onTapGesture(perform: {
                        if let url = URL(string: "https://www.nicolasott.de/en/tix/support/index.html") {
                            UIApplication.shared.open(url)
                        }
                    })
                    
                    Divider()
                    
                    HStack {
                        NavigationLink(destination: MailView(result: self.$result).accentColor(Color.tix)
                                        .edgesIgnoringSafeArea(.bottom)) {
                            HStack {
                                Text(loc_feedback).frame(alignment: .leading).foregroundColor(noMail ? .gray : .tix)
                                Spacer()
                            }
                        }.disabled(!MFMailComposeViewController.canSendMail())
                    }
                    
                    Divider()
                    
                    HStack {
                        Text(loc_contact).frame(alignment: .leading).foregroundColor(.tix)
                        Spacer()
                    }.frame(alignment: .leading).onTapGesture(perform: {
                        if let url = URL(string: "https://www.nicolasott.de/en/contact/") {
                            UIApplication.shared.open(url)
                        }
                    })
                    Divider()
                    HStack {
                        Text("Twitter").frame(alignment: .leading).foregroundColor(.tix)
                        Spacer()
                    }.frame(alignment: .leading).onTapGesture(perform: {
                        if let url = URL(string: "https://twitter.com/trax_tracker") {
                            UIApplication.shared.open(url)
                        }
                    })
                    
                }
                .padding(10)
                .background(Color.white)
                .cornerRadius(10)
                .frame(maxWidth: .infinity)
                
                VStack(alignment: .leading) {
                   
                        
                    HStack {
                        Text(loc_about).frame(alignment: .leading).foregroundColor(.tix)
                        Spacer()
                    }.onTapGesture(perform: {
                        showAbout.toggle()
                    })
                     
                }
                .padding(10)
                .background(Color.white)
                .cornerRadius(10)
                .frame(maxWidth: .infinity)
            }
            Spacer()
            VStack(alignment: .leading) {
                HStack {
                    Text(loc_madewithlove).font(.footnote).foregroundColor(Color.white)
                }
            }
            .padding(.leading).padding(.trailing).padding(.bottom)
            .frame(maxWidth: .infinity)
        }
        .accentColor(.tixDark)
        .padding(.leading).padding(.trailing)
        .background(Color(settings.globalBackground))
        .sheet(isPresented: self.$showAbout) {
            About(settings: settings)
         }
    }
    
    
    func onAppear() {
        if !MFMailComposeViewController.canSendMail() {
            self.noMail = true
        }
    }
    
    
    func deleteTicked() {
        let setRequest = NSFetchRequest<Todo>(entityName: "Todo")
        let setPredicate = NSPredicate(format: "isDone == true")
        let setSortDescriptor1 = NSSortDescriptor(keyPath: \Todo.todo, ascending: true)
        setRequest.predicate = setPredicate
        setRequest.sortDescriptors = [setSortDescriptor1]
        do {
            let sets = try self.viewContext.fetch(setRequest) as [Todo]
            
            for cat in sets {
                viewContext.delete(cat)
                do {
                    try viewContext.save()
                    deletedTodos+=1
                } catch {
                    NSLog("error deleting todo: \(error.localizedDescription)")
                }
                
            }
        } catch let error {
            NSLog("error in FetchRequest trying to get default category: \(error.localizedDescription)")
        }
    }
}


