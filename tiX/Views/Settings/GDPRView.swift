//
//  GDPRView.swift
//  tiX
//
//  Created by Nicolas Ott on 07.11.21.
//
import SwiftUI

struct GDPRView: View {
    @ObservedObject var settings: UserSettings
    @Binding var show: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    withAnimation {
                        show = false
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
                        .font(.title2)
                        .foregroundColor(Color(settings.globalForeground))
                        .padding(.bottom, 5)
                    Text(loc_gdpr_subheader)
                        .font(.headline)
                        .foregroundColor(Color(settings.globalForeground))
                        .padding(.bottom, 5)
                    Text(loc_gdpr_lastupdated).font(.subheadline).foregroundColor(Color(settings.globalForeground))
                        .padding(.bottom, 15)
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

