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
                        .foregroundColor(.white)
                }
                .buttonStyle(PlainButtonStyle())
            }.padding(.top).padding(.bottom)
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text(loc_gdpr_header)
                        .font(.title2).bold().foregroundColor(.white)
                    Text(loc_gdpr_subheader).bold().font(.headline).foregroundColor(.white)
                    Text(loc_gdpr_lastupdated).font(.subheadline).foregroundColor(.white)
                    Text(loc_gdpr_text).foregroundColor(.white)
                }
            }
        }
        .padding(.leading)
        .padding(.trailing)
        .accentColor(Color.white)
        .background(Color(settings.globalBackground))
    }
}

