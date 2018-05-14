//NCMBにデータを保存する場合（制作途中）
//ピンをとりあえず打つ→全部打ったら保存する！

import UIKit
import CoreLocation
import GoogleMaps
import NCMB

class NCMBViewController: UIViewController {
    //mapViewを表示させる
    @IBOutlet var mapView: GMSMapView!
    //位置情報の使用
    var locationManager = CLLocationManager()
    
    var pins = [Pin]()
    
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
        loadLocations()
        makeSearchButton()
        makeSaveButton()
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
    
    func loadLocations() {
        //全マーカーの削除
//        mapView.clear()
        
        let query = NCMBQuery(className: "Place")
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                print("error")
            } else {
                let places = result as! [NCMBObject]
                for place in places {
                    let longitude = place.object(forKey: "longitude") as! CLLocationDegrees
                    let latitude = place.object(forKey: "latitude") as! CLLocationDegrees
                    let name = place.object(forKey: "title") as! String
                    let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    //loadした情報からマーカーを生成
                    let marker = GMSMarker()
                    marker.position = location
                    marker.title = name
                    marker.map = self.mapView
                }
            }
        })
    }
    
    
    
}

