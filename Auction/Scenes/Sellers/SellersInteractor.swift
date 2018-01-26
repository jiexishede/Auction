//
//  SellersInteractor.swift
//  Auction
//
//  Created by Raymond Law on 1/17/18.
//  Copyright (c) 2018 Clean Swift LLC. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import RealmSwift

protocol SellersBusinessLogic
{
  func fetchSellers(request: Sellers.FetchSellers.Request)
}

protocol SellersDataStore
{
}

class SellersInteractor: SellersBusinessLogic, SellersDataStore, RealmWorkerDelegate
{
  var presenter: SellersPresentationLogic?
  var worker: SellersWorker?
  
  // MARK: Fetch sellers
  
  var sellers: Results<User>?
  
  func fetchSellers(request: Sellers.FetchSellers.Request)
  {
    RealmWorker.shared.addDelegate(delegate: self)
    refreshSellers()
  }
  
  // MARK: Refresh sellers
  
  private func refreshSellers()
  {
    if sellers?.realm == nil {
      if RealmWorker.shared.realm != nil {
        sellers = RealmWorker.shared.realm.objects(User.self).filter("soldItems.@count > 0")
      }
    }
    let response = Sellers.FetchSellers.Response(sellers: sellers)
    presenter?.presentFetchSellers(response: response)
  }
  
  // MARK: RealmWorkerDelegate
  
  func realmWorkerHasChanged()
  {
    refreshSellers()
  }
}
