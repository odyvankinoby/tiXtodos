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
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var noMail = false
    @State var deletedTodos = 0
   
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(loc_settings).foregroundColor(.white).font(.title3).bold()
                        Spacer()
                    }.padding(.leading).padding(.trailing)
                        .padding(.top, 10).padding(.bottom, 10)
                        .background(RoundedCorners(color: Color.tix, tl: 10, tr: 10, bl: 0, br: 0))
                    
                    HStack {
                        Text(loc_name)
                            .frame(alignment: .leading)
                            .foregroundColor(.tix)
                        Spacer()
                        TextField("", text: $settings.userName)
                            .frame(alignment: .center)
                            .foregroundColor(Color.tixDark)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.leading, 20)
                    }.padding(.leading).padding(.trailing)
                    
                    Divider()
                    
                    Toggle(isOn: $settings.hideTicked) {
                        Text(loc_hide_ticked)
                            .foregroundColor(.tix).frame(alignment: .trailing)
                    }.padding(.leading).padding(.trailing)
                    
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
                            Image(systemName: "circle.slash.fill")
                                .foregroundColor(.white).frame(alignment: .trailing)
                        }.customButton().padding(.leading, 50).padding(.bottom, 10)
                        
                    }.padding(.leading).padding(.trailing)
                    
                }
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.systemBackground))
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.tix.opacity(0.5), lineWidth: 0.5))
                .padding(.leading).padding(.trailing)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(loc_support).foregroundColor(.white).font(.title3).bold()
                        Spacer()
                    }.padding(.leading).padding(.trailing)
                        .padding(.top, 10).padding(.bottom, 10)
                        .background(RoundedCorners(color: Color.tix, tl: 10, tr: 10, bl: 0, br: 0))
                    
                    
                    HStack {
                        Text(loc_help).frame(alignment: .leading).foregroundColor(.tix)
                        Spacer()
                    }.padding(.leading).padding(.trailing).frame(alignment: .leading).onTapGesture(perform: {
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
                        }
                                        .disabled(!MFMailComposeViewController.canSendMail())
                    }.padding(.leading).padding(.trailing)
                    
                    Divider()
                    
                    HStack {
                        Text(loc_contact).frame(alignment: .leading).foregroundColor(.tix)
                        Spacer()
                    }.padding(.leading).padding(.trailing).frame(alignment: .leading).onTapGesture(perform: {
                            if let url = URL(string: "https://www.nicolasott.de/en/contact/") {
                                UIApplication.shared.open(url)
                            }
                        })
                    Divider()
                    HStack {
                        Text("Twitter").frame(alignment: .leading).foregroundColor(.tix)
                        Spacer()
                    }.padding(.leading).padding(.trailing).padding(.bottom, 10).frame(alignment: .leading).onTapGesture(perform: {
                            if let url = URL(string: "https://twitter.com/trax_tracker") {
                                UIApplication.shared.open(url)
                            }
                        })
                    
                }
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.systemBackground))
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.tix.opacity(0.5), lineWidth: 0.5))
                .padding(.leading).padding(.trailing)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(loc_about).foregroundColor(.white).font(.title3).bold()
                        Spacer()
                    }.padding(.leading).padding(.trailing)
                        .padding(.top, 10).padding(.bottom, 10)
                        .background(RoundedCorners(color: Color.tix, tl: 10, tr: 10, bl: 0, br: 0))
                    
                    HStack {
                        NavigationLink(destination: About().accentColor(Color.tix)
                                        .edgesIgnoringSafeArea(.bottom)) {
                            HStack {
                                Text(loc_about).frame(alignment: .leading).padding(.bottom, 10).foregroundColor(.tix)
                                Spacer()
                            }
                        }
                    }.padding(.leading).padding(.trailing)
                    
                }
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.systemBackground))
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.tix.opacity(0.5), lineWidth: 0.5))
                .padding(.leading).padding(.trailing)
                
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text(loc_madewithlove).font(.footnote)
                }
                .padding(50)
                .frame(maxWidth: .infinity)
                
            }
            .navigationBarTitle(loc_settings, displayMode: .automatic).allowsTightening(true)
            .navigationViewStyle(StackNavigationViewStyle())
            .accentColor(.tix) // NAV
            .onAppear(perform: onAppear)
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


