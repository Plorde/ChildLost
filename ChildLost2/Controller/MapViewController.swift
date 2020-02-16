//
//  ViewController.swift
//  ChildLost2
//
//  Created by 龙锐 on 2019/12/6.
//  Copyright © 2019 龙锐. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController {
    
   
    @IBOutlet weak var MyMap: MKMapView!
    // set initial location in Honolulu
    
    
    @IBOutlet weak var Information: UILabel!
    
    @IBOutlet weak var mybutton: UIButton!
    
   
    @IBAction func button(_ sender: Any) {
        uploadingMot2One()
    }
    //let bgimag1 = main.bundle.
   
    var acc:Double = 0
    var str : String{
        if(acc < -1){
            return "你的孩子正在快速奔跑，请留意"
        }
        else if(acc>1){
            return "你的孩子正在慢速行走，不用担心"
        }
        else{
             return "你的孩子正在稳步行走"
        }
    }
    
    // 设定初始经纬度
    let initialLocation = CLLocation(latitude: 30.5384100000, longitude: 114.3574200000)
    var lat:Double = 30.5384100000{
        didSet{
            MyMap.updateLocation(inlat: self.lat, inlong: self.long)
        }
    }
    
    var long:Double = 114.3574200000
    override func viewDidLoad() {
       
        super.viewDidLoad()
        Information.text = self.str
        Information.layer.cornerRadius = 25
        Information.layer.backgroundColor = #colorLiteral(red: 1, green: 0.4446774721, blue: 0.4276759624, alpha: 1)
       mybutton.setBackgroundImage(UIImage(named:"normal"),for:.normal) //设置button默认状态下背景图片

        mybutton.setBackgroundImage(UIImage(named:"later"),for:.selected) //设置button选中状态下背景图片

        centerMapOnLocation(location: initialLocation)
        MyMap.delegate = self as MKMapViewDelegate
        let artwork = Children(title: "Child❤️",
                              locationName: "武汉"+String(self.acc),
          discipline: "",
          coordinate: CLLocationCoordinate2D(latitude: self.lat, longitude: self.long))
        MyMap.addAnnotation(artwork)
        runStill()
        updateInternet()
    }
    func centerMapOnLocation(location: CLLocation) {
            let regionRadius: CLLocationDistance = 100
            let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                      latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
          MyMap.setRegion(coordinateRegion, animated: true)
    }
    
    // 这是一个模仿跑步的函数，用来刷新地图上的位置数据
    func runStill(){
          var a = self.lat
          var b = self.long
         

          DispatchQueue.global(qos: .background).async {
              while true{
              let randomBool1 = Bool.random()
              let randomDouble1 = Double.random(in: 0..<0.00001)
              let randomBool2 = Bool.random()
              let randomDouble2 = Double.random(in: 0..<0.00001)
                         
              let deltaA = randomBool1 ? randomDouble1 : -randomDouble1
              let deltaB = randomBool2 ? randomDouble2 : -randomDouble2
              a = self.lat + deltaA
              b = self.long + deltaB

              DispatchQueue.main.async {
                  self.lat = a
                  self.long = b
               }
              sleep(2)
              }
           }
      }

    // 这是一个不断访问网络的函数，用来刷新孩子的摔倒情况
    func updateInternet(){
        DispatchQueue.global(qos: .background).async {
            while true{
              let strnow = readMot()
              if strnow == "1"{
              uploadingTumble2Zero()
              // 回主线程提示摔倒了
              DispatchQueue.main.async {
                          let alertController = UIAlertController(title: "提示！",
                                             message: "您的孩子摔倒了🏃‍♀️需要提醒吗", preferredStyle: .alert)
                             let cancelAction = UIAlertAction(title: "找他", style: .cancel, handler: nil)
                             let defaultAction = UIAlertAction(title: "提醒",style: .default) { (action) in
                                 uploadingMot2One()
                             }
                             alertController.addAction(cancelAction)
                             alertController.addAction(defaultAction)
                             self.present(alertController, animated: true, completion: nil)
                            self.addHeadline()
                          }
               }
            
            let acc = readAccelerate()
            
            // 回主线程修改加速度信息
            DispatchQueue.main.async{
                          self.acc = acc
                      }
                sleep(1)
              }

           }
    }
    
    // 把数据写文件
    func addHeadline(){
          let current = Date()
          
          var mydata = getInformation()
          let idnow = mydata.headlins.count + 1
          mydata.headlins.append(Headline(id: idnow, title: current.datestring, lat: self.lat, lng: self.long, accelarate: self.acc))
          
          if let url = try?FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("Untitled.json"){
              if let json = mydata.json{
                  do{
                  try json.write(to: url)
                  print("saved Successfully")
                  }catch let error{
                      print("Couldn't save\(error)")
                  }
              }
          }
              
      }
    // 从文件中读数据
    func getInformation()->Headlines{
              if let url = try?FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("Untitled.json"){
              if let jsonData = try? Data(contentsOf: url){
                  return Headlines(json:jsonData)!
              }
              }
              return Headlines()
                  
          }
    // 只保存7天内的数据
      func RemainData(){
          var a = self.getInformation()
          var newarray = [Headline]()
          for i in 0..<6{
              newarray.append(a.headlins[i])
          }
          a.headlins = newarray
          
          if let url = try?FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("Untitled.json"){
              if let json = a.json{
                  do{
                  try json.write(to: url)
                  print("saved Successfully")
                  }catch let error{
                      print("Couldn't save\(error)")
                  }
              }
          }
          
      }
    
}
    
    
