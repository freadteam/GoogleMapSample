//
//  NCMBViewController+GMSAutocompleteViewControllerDelegate.swift
//  GoogleMapSample
//
//  Created by Ryo Endo on 2018/05/05.
//  Copyright © 2018年 Ryo Endo. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

extension NCMBViewController: GMSAutocompleteViewControllerDelegate {
    // 検索して選択した場所の情報を取得
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        let latitude = place.coordinate.latitude
        let longitude = place.coordinate.longitude
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15.0)
        mapView.camera = camera
        
        //検索場所にマーカーを打つ
        showMaker(position: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), title: place.name)
        
        //生成したpinを配列で保存する→保存ボタンでまとめてNCMBで保存
        let pin = Pin(latitude: latitude, longitude: longitude, title: place.name)
        self.pins.append(pin)
        
        dismiss(animated: true, completion: nil)
    }
    //取得できなかった時に呼ばれる
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    //キャンセルボタンのアクション
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    //Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    //検索画面を表示させるボタン
    func makeSearchButton() {
        let button = UIButton()
        button.frame = CGRect(x: 311, y: 520, width: 55, height: 55)
        button.backgroundColor = UIColor.white
        button.setImage(UIImage(named: "search@2x.png"), for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = button.frame.height/2
        self.mapView.addSubview(button)
        
        //ボタンに影をつける　なんかできない
        button.layer.shadowOffset = CGSize(width: 55, height: 55 )
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowRadius = button.frame.height/2
        button.layer.shadowOpacity = 1.0
        
        //ボタンで実行する処理
        button.addTarget(self, action: #selector(NCMBViewController.buttonEvent(_:)), for: UIControlEvents.touchUpInside)
    }
    
    // ボタンが押された時に呼ばれるメソッド（検索ウィンドウを表示させる）
    @objc func buttonEvent(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
}
