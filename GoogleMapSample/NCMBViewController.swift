//NCMBにデータを保存する場合（制作途中）
//ピンをとりあえず打つ→全部打ったら保存する！

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces
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
        makeSearchButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadMarkerData()
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
    
    
    //NCMBの保存
    func saveMarker(latitude: CLLocationDegrees, longitude: CLLocationDegrees, title: String) {
        let object = NCMBObject(className: "Place")
        object?.setObject(latitude, forKey: "latitude")
        object?.setObject(longitude, forKey: "longitude")
        object?.setObject(title, forKey: "title")
        object?.saveInBackground({ (error) in
            if error != nil {
                // SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                print("登録成功")
            }
        })
    }
    
    func loadMarkerData() {
        let query = NCMBQuery(className: "Place")
        // オブジェクトの取得
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                // SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                for postObject in result as! [NCMBObject] {
                    // 投稿の情報を取得
                   // let objectId = postObject.object(forKey: "objectId") as! String
                    let title = postObject.object(forKey: "title") as! String
                    let latitude = postObject.object(forKey: "latitude") as! CLLocationDegrees
                    let longitude = postObject.object(forKey: "longitude") as! CLLocationDegrees
                    
                   self.showMaker(position: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), title: title)
                }
            }
        })
    }
    

    
}

