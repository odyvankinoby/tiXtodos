//
//  InAppPurchase.swift
//  tiX
//
//  Created by Nicolas Ott on 11.11.21.
//

import SwiftUI
import StoreKit

struct InAppPurchase: View {
    
    @ObservedObject var settings: UserSettings
    @StateObject var storeManager: StoreManager
    
    @Environment (\.presentationMode) var presentationMode
    
    var body: some View {
        
        VStack {
            HStack {
                Button(loc_discard) {
                    withAnimation {
                        cancelAction()
                    }
                }.foregroundColor(Color(settings.globalForeground))

                Spacer()
                
                if !settings.purchased && storeManager.transactionState != .restored && storeManager.transactionState != .purchased {
                    Button(loc_iap_restore) {
                        withAnimation {
                            storeManager.restoreProducts()
                        }
                    }.foregroundColor(Color(settings.globalForeground))
                }
                
            }.padding(.top).padding(.bottom)
            
            HStack(alignment: .bottom) {
                Image(systemName: "crown")
                    .font(.title)
                    .foregroundColor(settings.globalBackground == "Yellow" ? .white : .yellow)
                    .padding(.top)
                Text(loc_premium)
                    .font(.title).bold()
                    .foregroundColor(Color(settings.globalForeground))
                    .frame(alignment: .leading)
                    .padding(.top)
                Spacer()
                
            }
            
            ScrollView {
                VStack(alignment: .leading) {
                    
                    Text(loc_iap_text)
                        .foregroundColor(Color(settings.globalForeground))
                        .padding(.bottom)
                    
                    ForEach(storeManager.myProducts, id: \.self) { product in
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text(product.localizedTitle).foregroundColor(Color(settings.globalText))
                                    .font(.headline)
                                Text(product.localizedDescription).foregroundColor(Color(settings.globalText))
                                    .font(.caption2)
                            }
                            Spacer()
                            if UserDefaults.standard.bool(forKey: product.productIdentifier) {
                                Text(loc_purchased)
                                    .foregroundColor(.green)
                                    .padding(.leading, 10)
                                    .padding(.trailing, 10)
                                    .padding(.bottom, 10)
                                    .padding(.top, 10)
                                    .background(Color(UIColor.systemBackground))
                                    .cornerRadius(10)
                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.green.opacity(0.5), lineWidth: 0.5))
                            } else {
                                let localPrice = storeManager.getPriceFormatted(for: product)
                                
                                Button(action: {
                                    
                                    storeManager.purchaseProduct(product: product)
                                }) {
                                    Text("\(localPrice ?? "")").foregroundColor(.blue)
                                        .padding(.leading, 10)
                                        .padding(.trailing, 10)
                                        .padding(.bottom, 10)
                                        .padding(.top, 10)
                                        .background(Color(UIColor.systemBackground))
                                        .cornerRadius(10)
                                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue.opacity(0.5), lineWidth: 0.5))
                                }
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(settings.globalBackground == "White" ? Color.tix : Color(settings.globalForeground), lineWidth: 1).padding(1)
                        )
                    }
                    Spacer()
                    if storeManager.transactionState == .failed && storeManager.show {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text(loc_iap_failure).foregroundColor(Color(settings.globalForeground)).padding(.all, 10)
                            }
                        }.onAppear(perform: {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                                storeManager.show = false
                            })
                        })
                    }
                    
                    if (storeManager.transactionState == .purchased && storeManager.show) || ((settings.purchased || storeManager.transactionState == .purchased || storeManager.transactionState == .restored) && storeManager.show) {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text(loc_iap_success).foregroundColor(Color(settings.globalForeground)).padding(.all, 10)
                            }
                        }.onAppear(perform: {
                            settings.purchased = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                                storeManager.show = false
                            })
                        })
                    }

                }
            }
        }
        .accentColor(Color(settings.globalForeground))
        .padding(.leading).padding(.trailing)
        .background(Color(settings.globalBackground))
    }

    func cancelAction() {
        self.presentationMode.wrappedValue.dismiss()
    }
}


