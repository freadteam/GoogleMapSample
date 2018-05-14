//
//  NCMBViewController+GMSMapViewDelegate.swift
//  GoogleMapSample
//
//  Created by Ryo Endo on 2018/05/05.
//  Copyright © 2018年 Ryo Endo. All rights reserved.
//

import UIKit
import NCMB
import GoogleMaps

extension NCMBViewController: GMSMapViewDelegate {
    
    //マーカーを打ち込む
    func showMaker(position: CLLocationCoordinate2D, title: String) {
        let marker = GMSMarker()
        marker.position = position
        marker.title = title
        //marker.snippet = ""
        //場所名が記入された時のみマーカーを生成
        if marker.title?.count != 0 {
            //生成したpinを配列で保存する→保存ボタンでまとめてNCMBで保存
            let pin = Pin(latitude: position.latitude, longitude: position.longitude, title: title)
            self.pins.append(pin)
            
            marker.appearAnimation = GMSMarkerAnimation.pop
            //マーカーをmapviewに表示
            marker.map = self.mapView

        }
    }

    
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
    
    
    //保存ボタンを表示
    func makeSaveButton() {
        let button = UIButton()
        button.frame = CGRect(x: 10, y: 20, width: 55, height: 55)
        button.backgroundColor = UIColor.white
        button.setImage(UIImage(named: "save@2x.png"), for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = button.frame.height/2
        //button.layer.position = CGPoint(x: 50, y: 50)
        self.mapView.addSubview(button)
        
        //ボタンに影をつける　なんかできない
        button.layer.shadowOffset = CGSize(width: 55, height: 55 )
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowRadius = button.frame.height/2
        button.layer.shadowOpacity = 1.0
        
        //ボタンで実行する処理
        button.addTarget(self, action: #selector(NCMBViewController.saveButton(_:)), for: UIControlEvents.touchUpInside)
    }
    
    // ボタンが押された時に呼ばれるメソッド（保存する）
    @objc func saveButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "ピンの保存", message: "ピンを保存しますか", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in self.savePins()
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func savePins() {
        let object = NCMBObject(className: "Place")
        for i in pins {
            object?.setObject(i.longitude, forKey: "longitude")
            object?.setObject(i.latitude, forKey: "latitude")
            object?.setObject(i.title, forKey: "title")
            object?.saveInBackground({ (error) in
                if error != nil {
                    //SVProgressHUD.showError(withStatus: error!.localizedDescription)
                } else {
                    let alertController = UIAlertController(title: "保存成功", message: "保存が成功しました", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.pins = [Pin]()
                        alertController.dismiss(animated: true, completion: nil)
                    })
                    alertController.addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        }
    }
    
    
}
