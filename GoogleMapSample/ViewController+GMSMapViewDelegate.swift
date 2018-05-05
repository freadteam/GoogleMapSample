 /*
  ・マーカーを任意の場所に生成
  ・マーカーをタップすると詳細を表示
  ・マーカーの削除
  */
 
 import UIKit
 import GoogleMaps
 
 //viewDidLoadでdelegateの宣言をしておく
 extension ViewController: GMSMapViewDelegate{
    
    //長押しした場所の緯度経度をとる関数
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
            //マーカーの削除
            marker.map = nil
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //デフォルトで地図に表示されている場所をタップすると情報を取得
    func mapView(_ mapView:GMSMapView, didTapPOIWithPlaceID placeID:String,
                 name:String, location:CLLocationCoordinate2D) {
        print("You tapped \(name): \(placeID), \(location.latitude)/\(location.longitude)")
    }
    

    
    //ピンを押した時に表示される情報ウィンドウを細かく設定できる
    //    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
    //
    //        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 200, height: 70))
    //
    //        //ウィンドウの色
    //        view.backgroundColor = UIColor.red
    //        view.layer.cornerRadius = 6
    //
    //        let lbl1 = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 16, height: 15))
    //        lbl1.text = "場所名"
    //        view.addSubview(lbl1)
    //
    //        let lbl2 = UILabel(frame: CGRect.init(x: lbl1.frame.origin.x, y: lbl1.frame.origin.y + lbl1.frame.size.height + 3, width: view.frame.size.width - 16, height: 15))
    //        lbl2.text = "説明を記入"
    //        lbl2.font = UIFont.systemFont(ofSize: 14, weight: .light)
    //        view.addSubview(lbl2)
    //
    //        return view
    //    }
 }
