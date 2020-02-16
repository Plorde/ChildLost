import Foundation

struct Cry: Codable {
    let value:String
}

struct Tumble: Codable {
    let value:String
}

struct Qumot: Codable {
    let value:String
}

struct Headlines:Codable{
    var headlins:[Headline]
    var json : Data?{
        return try? JSONEncoder().encode(self)
    }
    init?(json:Data){
        if let newValue = try? JSONDecoder().decode(Headlines.self, from: json){
            self = newValue
        }
        else{
            return nil
        }
    }
    init(){
        self.headlins = []
    }
}
struct Headline:Codable {
    let id : Int
    let title : String
    let lat : Double
    let lng : Double
    let accelarate : Double
    
    var picname : String{
        if(accelarate < -1){
            return "run"
        }else{
            return "walk"
        }
    }

}

// 数据和网络交互的方式
func uploadingTumble2Zero(){
    let order = Tumble(value: "0")
    guard let uploadData = try? JSONEncoder().encode(order) else {
        return
    }
    let url = URL(string: "https://coconutnut.xyz:2019/tumble")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
        if let error = error {
            print ("error: \(error)")
            return
        }
        guard let response = response as? HTTPURLResponse,
            (200...299).contains(response.statusCode) else {
            print ("server error")
            return
        }
        if let mimeType = response.mimeType,
            mimeType == "application/json",
            let data = data,
            let dataString = String(data: data, encoding: .utf8) {
            print ("got data: \(dataString)")
        }
    }
    task.resume()
}

func uploadingMot2One(){
    let order = Qumot(value: "1")
    guard let uploadData = try? JSONEncoder().encode(order) else {
        return
    }
    print(uploadData)
  
    let url = URL(string: "https://coconutnut.xyz:2019/qumot")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
        if let error = error {
            print ("error: \(error)")
            return
        }
        guard let response = response as? HTTPURLResponse,
            (200...299).contains(response.statusCode) else {
            print ("server error")
            return
        }
        if let mimeType = response.mimeType,
            mimeType == "application/json",
            let data = data,
            let dataString = String(data: data, encoding: .utf8) {
            print ("got data: \(dataString)")
        }
    }
    task.resume()
}

func readMot()->String{
    let url1 = "https://coconutnut.xyz:2019/tumble"
     let sessionConfigure = URLSessionConfiguration.default
    // sessionConfigure.httpAdditionalHeaders = ["Content-Type": "application/json"]
    // sessionConfigure.timeoutIntervalForRequest = 30
     sessionConfigure.requestCachePolicy = .reloadIgnoringLocalCacheData
     let session = URLSession(configuration: sessionConfigure)
      
     guard let url =  URL(string: url1) else {
            return ""
     }
     var result = ""
     let url1Request = URLRequest(url: url)
     let dataTask1 = session.dataTask(with: url1Request) { (data, response, error)  in
      guard data != nil else {return}
      let str = String(data: data!, encoding: String.Encoding.utf8)
      // 这里需要再加一个逻辑判断
     guard let tempstr = str else{return}
     result = tempstr
    }
    dataTask1.resume()
    return result
}

func readAccelerate()->Double{
    let urltemp = "https://coconutnut.xyz:2019/accelerate"
     let sessionConfigure2 = URLSessionConfiguration.default
    // sessionConfigure.httpAdditionalHeaders = ["Content-Type": "application/json"]
    // sessionConfigure.timeoutIntervalForRequest = 30
     sessionConfigure2.requestCachePolicy = .reloadIgnoringLocalCacheData
     let session2 = URLSession(configuration: sessionConfigure2)
      
     guard let url2 =  URL(string: urltemp) else {return 0}
     let url2Request = URLRequest(url: url2)
    var result : Double = 0
     let dataTask2 = session2.dataTask(with: url2Request) { (data, response, error) in
      guard data != nil else {return}
      let str = String(data: data!, encoding: String.Encoding.utf8)
      // 这里需要再加一个逻辑判断
        guard let strnow = str else{return }
        guard let datanow = Double(strnow) else{return }
        result = datanow
      }
    
    dataTask2.resume()
    return result
}

