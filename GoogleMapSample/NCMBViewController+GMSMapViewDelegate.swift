//
//  NCMBViewController+GMSMapViewDelegate.swift
//  GoogleMapSample
//
//  Created by Ryo Endo on 2018/05/05.
//  Copyright © 2018年 Ryo Endo. All rights reserved.
//

import UIKit
import GoogleMaps

extension NCMBViewController: GMSMapViewDelegate {
    //長押しした場所の緯度経度をとってくる
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        let alert = UIAlertController(title: "場所", message: "場所名を記入して", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "キャンセル", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        //okした時の処理
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            //マーカーを生成する（タイトルをつけた時のみ）
            self.showMaker(position: coordinate, title: (alert.textFields?.first?.text)!)
            
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        alert.addTextField { (textField) in
            textField.placeholder = "場所名を記入"
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    //マーカーを打ち込む
    func showMaker(position: CLLocationCoordinate2D, title: String) {
        let marker = GMSMarker()
        marker.position = position
        marker.title = title
        //marker.snippet = ""
        //場所名が記入された時のみマーカーを生成
        if marker.title?.count != 0 {
            self.saveMarker(latitude: position.latitude, longitude: position.longitude, title: title)
            //マーカーをmapviewに表示
            marker.map = self.mapView
        }
    }
    
    //マーカーのウィンドウを押した時の処理
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        let alertController = UIAlertController(title: "ピンを押したよ", message: "ピンを押したよ", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alertController.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //マーカーのウィンドウを長押した時の処理
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        
        let alert = UIAlertController(title: "ピンの削除", message: "ピンを削除しますか？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            //マーカー除去
            marker.map = nil
        })
        
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
 

}
