//NCMBにデータを保存する場合（制作途中）

import UIKit
import CoreLocation
import GoogleMaps
import NCMB

class NCMBViewController: UIViewController, GMSMapViewDelegate {
    
    //mapViewを表示させる
    @IBOutlet var mapView: GMSMapView!
    //位置情報で使う
    var locationManager = CLLocationManager()
    var pins = [Pin]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        //位置情報使用の許可
        locationManager.requestWhenInUseAuthorization()
        //現在地の取得
        mapView.isMyLocationEnabled = true
        //現在地を取得するボタンをセット
        mapView.settings.myLocationButton = true
        
        makeMap()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        loadPlace()
        for i in pins {
            let marker = GMSMarker()
            marker.position.latitude = i.latitude
            marker.position.longitude = i.longitude
            //マーカを地図に表示
            marker.map = mapView
            print(pins)
        }
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
            //位置情報の使用を許可されたとき
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
        
        let marker = GMSMarker()
        marker.position = position
        
        //marker.title = "title"
        //marker.snippet = "test"
        marker.map = mapView
        
    }
    
    //マーカを打ち込む　方法②
    //    func makeMarker(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
    //        let marker = GMSMarker()
    //        marker.position.latitude = latitude
    //        marker.position.longitude = longitude
    //       //マーカを地図に表示
    //        marker.map = mapView
    //    }
    
    
    //長押しした場所の緯度経度をとってくる
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        showMaker(position: coordinate)
        saveLocation(coordinate: coordinate)
        
    

        
    }
    
    //タップした場所の緯度経度をとってくる
    //    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
    //        print(coordinate)
    //        showMaker(position: coordinate)
    //    }
    
    //ピンを押した時の処理
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        let alertController = UIAlertController(title: "ピンを押したよ", message: "ピンを押したよ", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
        })
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    //ピンを長押した時の処理
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        
        let alert = UIAlertController(title: "ピンの削除", message: "ピンを削除しますか？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            //ピンを除去
            marker.map = nil
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //ピンを押した時に表示される情報ウィンドウを細かく設定できる
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 200, height: 70))
        //ウィンドウの色
        view.backgroundColor = UIColor.red
        view.layer.cornerRadius = 6
        
        let lbl1 = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 16, height: 15))
        
        lbl1.text = "Hi there!"
        view.addSubview(lbl1)
        
        let lbl2 = UILabel(frame: CGRect.init(x: lbl1.frame.origin.x, y: lbl1.frame.origin.y + lbl1.frame.size.height + 3, width: view.frame.size.width - 16, height: 15))
        lbl2.text = "I am a custom info window."
        lbl2.font = UIFont.systemFont(ofSize: 14, weight: .light)
        view.addSubview(lbl2)
        
        return view
    }
    
    //ピンの緯度経度を保存
    func saveLocation(coordinate: CLLocationCoordinate2D) {
        let object = NCMBObject(className: "Place")
        object?.setObject(coordinate.latitude, forKey: "latitude")
        object?.setObject(coordinate.longitude, forKey: "longitude")
        object?.saveInBackground({ (error) in
            if error != nil {
               
            } else {
                print("保存完了")
            }
        })
    }
    
    //保存したピンの情報を読み込む
    func loadPlace() {
        let query = NCMBQuery(className: "Place")
        // オブジェクトの取得
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                
            } else {
                // 投稿を格納しておく配列を初期化(これをしないとreload時にappendで二重に追加されてしまう)
                self.pins = [Pin]()
                
                for postObject in result as! [NCMBObject] {
                    // 投稿の情報を取得
                    let latitude = postObject.object(forKey: "latitude") as! CLLocationDegrees
                    let longitude = postObject.object(forKey: "longitude") as! CLLocationDegrees
                    let pin = Pin(objectId: postObject.objectId, latitude: latitude, longitude: longitude)
                    
                    let title = postObject.object(forKey: "title")
                    let text = postObject.object(forKey: "text")
                    
                    if let titiles = title {
                        pin.title = titiles as? String
                    }
                    if let texts = text {
                        pin.text = texts as? String
                    }
                    
                    self.pins.append(pin)
                }
            }
        })
        
    }
    
    
    
}
