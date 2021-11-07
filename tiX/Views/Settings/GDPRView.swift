//
//  GDPRView.swift
//  tiX
//
//  Created by Nicolas Ott on 07.11.21.
//
import SwiftUI

struct GDPRView: View {
    @ObservedObject var settings: UserSettings
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    withAnimation {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text(loc_discard)
                        .foregroundColor(Color(settings.globalForeground))
                }
                .buttonStyle(PlainButtonStyle())
            }.padding(.top).padding(.bottom)
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text(loc_gdpr_header)
                        .font(.title2).bold().foregroundColor(Color(settings.globalForeground))
                    Text(loc_gdpr_subheader).bold().font(.headline).foregroundColor(Color(settings.globalForeground))
                    Text(loc_gdpr_lastupdated).font(.subheadline).foregroundColor(Color(settings.globalForeground))
                    Text(loc_gdpr_text).foregroundColor(Color(settings.globalForeground))
                }
            }
        }
        .padding(.leading)
        .padding(.trailing)
        .accentColor(Color(settings.globalForeground))
        .background(Color(settings.globalBackground))
    }
}

