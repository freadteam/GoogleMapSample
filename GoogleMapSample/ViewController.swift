/*
 ・地図の生成
 GoogleMaps
 ・現在地の取得
 CoreLocation
 */
import UIKit
import CoreLocation
import GoogleMaps

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
        
        locateMyPosition()
        makeSearchButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //GMSCameraPositionで現在地の緯度経度を指定し、表示
    func locateMyPosition() {
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

    
    
}
