import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces

class ViewController: UIViewController {
    
    //mapViewを表示させる
    @IBOutlet var mapView: GMSMapView!
    
    //位置情報の使用
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //GMSMapViewDelegate(extensionに記載)
        mapView.delegate = self
        //位置情報使用の許可
        locationManager.requestWhenInUseAuthorization()
        //現在地の取得
        mapView.isMyLocationEnabled = true
        //現在地を取得するボタンをセット
        mapView.settings.myLocationButton = true
        
        makeMap()
        makeSearchButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //地図を生成、GMSCameraPositionで緯度経度を指定
    func makeMap() {
        // 現在地の緯度経度
        let latitude = locationManager.location?.coordinate.latitude
        let longitude = locationManager.location?.coordinate.longitude
        //表示する時の中心となる場所を指定する（nilに注意）
        if let unwrappedLatitude = latitude {
            //位置情報の使用を許可されてる時（現在地を中心に表示）
            let camera = GMSCameraPosition.camera(withLatitude: unwrappedLatitude, longitude: longitude!, zoom: 15.0)
            mapView.camera = camera
        } else {
            //位置情報を許可しない場合＆初回（新宿駅を中心に表示する）
            let camera = GMSCameraPosition.camera(withLatitude: 35.690167, longitude: 139.700359, zoom: 15.0)
            mapView.camera = camera
        }
    }
    
    //マーカーを打ち込む　方法①
    func showMaker(position: CLLocationCoordinate2D) {
        let alert = UIAlertController(title: "場所", message: "場所名を記入して", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "キャンセル", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        //okした時の処理
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
            //ピンを生成
            let marker = GMSMarker()
            marker.position = position
            marker.title = alert.textFields?.first?.text
            //marker.snippet = ""
            //場所名が記入された時のみマーカーを生成
            if alert.textFields?.first?.text?.count != 0 {
                marker.map = self.mapView
            }
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        alert.addTextField { (textField) in
            textField.placeholder = "場所名を記入"
        }
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //マーカを打ち込む　方法②
    func makeMarker(latitude: CLLocationDegrees, longitude: CLLocationDegrees, title: String) {
        let marker = GMSMarker()
        marker.position.latitude = latitude
        marker.position.longitude = longitude
        marker.title = title
        //マーカを地図に表示
        marker.map = mapView
    }
}


//viewDidLoadでdelegateの宣言をしておく
extension ViewController: GMSMapViewDelegate{
    
    //長押しした場所の緯度経度をとってくる
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        showMaker(position: coordinate)
    }
    
//    //タップした場所の緯度経度をとってくる
//    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
//        showMaker(position: coordinate)
//    }
    
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

// GooglePlace
extension ViewController: GMSAutocompleteViewControllerDelegate {
    
    // 検索して選択した場所の情報を取得
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        //        print("Place name: \(place.name)")
        //        print("Place address: \(place.formattedAddress)")
        //        print("Place attributions: \(place.attributions)")
        
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 15.0)
        mapView.camera = camera
        
        makeMarker(latitude:  place.coordinate.latitude, longitude: place.coordinate.longitude, title: place.name)
        
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
        button.frame = CGRect(x: 0, y: 0, width: 55, height: 55)
        button.backgroundColor = UIColor.white
        button.setImage(UIImage(named: "search@2x.png"), for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = button.frame.height/2
        button.layer.position = CGPoint(x: 340, y: 50)
        self.mapView.addSubview(button)
        
        //ボタンに影をつける　なんかできない
        button.layer.shadowOffset = CGSize(width: 55, height: 55 )
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowRadius = button.frame.height/2
        button.layer.shadowOpacity = 1.0
        
        //ボタンで実行する処理
        button.addTarget(self, action: #selector(ViewController.buttonEvent(_:)), for: UIControlEvents.touchUpInside)
    }
    
    // ボタンが押された時に呼ばれるメソッド（検索ウィンドウを表示させる）
    @objc func buttonEvent(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
}


