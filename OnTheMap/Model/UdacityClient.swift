//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Katharina Müllek on 23.01.21.
//

import Foundation

class UdacityClient {

    static var studentInformation = [StudentInformation]()
    
    struct Auth {
        static var uniqueKey = "1234"
        static var objectId = "5678"
        static var createdAt = ""
    }
    
    struct UserInformation {
        static var firstName = ""
        static var lastName = ""
    }
    
    struct UserPinInformation {
        static var mapString = ""
        static var mediaURL = ""
        static var latitude = 0.0
        static var longitude = 0.0
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        static let location = "/StudentLocation"
    
    
        case getLocation
        case getLocationLimit100
        case postLocation
        case userData
        case session
        case putLocation
        case signUp
        
        var stringValue: String {
            switch self {
            case .getLocation:
                return Endpoints.base + Endpoints.location
            case .getLocationLimit100:
                return Endpoints.base + Endpoints.location + "?limit=100"
            case .postLocation:
                return Endpoints.base + Endpoints.location
            case .userData:
                return Endpoints.base + "/users/\(Auth.uniqueKey)"
            case .session:
                return Endpoints.base + "/session"
            case .putLocation:
                return Endpoints.base + Endpoints.location + "/\(Auth.objectId)"
            case .signUp:
                return "https://auth.udacity.com/sign-up"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    

    
//MARK: - Task for GET Request
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, split: Bool, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            
            var newData: Data
            
            if split {
                let range = 5..<data.count
                let shortenedData = data.subdata(in: range)
                newData = shortenedData
            } else {
                newData = data
            }
            
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
        return task
    }
    
//MARK: - Task for POST Request
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, split: Bool, addAccept: Bool, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        if addAccept {
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let postBody = try! JSONEncoder().encode(body)
        request.httpBody = postBody
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            
            var newData: Data
            
            if split {
                let range = 5..<data.count
                let shortenedData = data.subdata(in: range)
                newData = shortenedData
            } else {
                newData = data
            }
            
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
            
        }
        task.resume()
    }

//MARK: - Task for DELETE Request
    class func taskForDELETERequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            let range = 5..<data.count
            let newData = data.subdata(in: range)

            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }

//MARK: - Functions for UI
    class func login(username: String, password: String, completionHandler: @escaping (Bool, Error?) -> Void) {
        let body = UdacityLoginRequest(udacity: Udacity(username: username, password: password))
        taskForPOSTRequest(url: Endpoints.session.url, responseType: UdacityLoginResponse.self, split: true, addAccept: true, body: body) { (response, error) in
            if let response = response {
                Auth.uniqueKey = response.account.key
                completionHandler(true, nil)
            } else {
                completionHandler(false, error)
                print("Your login Error is: \(error!)")
            }
        }
    }
    
    class func getUserInformation(completionHandler: @escaping (Bool, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.userData.url, responseType: User.self, split: true) { (response, error) in
            if let response = response {
                UserInformation.firstName = response.firstName
                UserInformation.lastName = response.lastName
                completionHandler(true, nil)
            } else {
                completionHandler(false, error)
                print("Your getUserInformation Error is: \(error!)")
            }
        }
    }

    class func getStudentInformation(completionHandler: @escaping ([StudentInformation], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getLocationLimit100.url, responseType: UdacityGetResponse.self, split: false) { (response, error) in
            if let response = response {
                completionHandler(response.results, nil)
            } else {
                completionHandler([], error)
                print("Your getStudentInformation Error is: \(error!)")
            }
        }
    }
    
    class func postLocation(uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, completionHandler: @escaping (Bool, Error?) -> Void) {
        let body = UdacityPostRequest(uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude)
        taskForPOSTRequest(url: Endpoints.postLocation.url, responseType: UdacityPostResponse.self, split: false, addAccept: false, body: body) { (response, error) in
            if let response = response {
                Auth.createdAt = response.createdAt
                Auth.objectId = response.objectId
                completionHandler(true, nil)
            } else {
                completionHandler(false, error)
            }
        }
    }
    
    class func logout(completionHandler: @escaping (Bool, Error?) -> Void) {
        taskForDELETERequest(url: Endpoints.session.url, responseType: UdacityLogoutResponse.self) { (response, error) in
            if response != nil {
                Auth.uniqueKey = ""
                UserInformation.firstName = ""
                UserInformation.lastName = ""
                UserPinInformation.mapString = ""
                UserPinInformation.mediaURL = ""
                UserPinInformation.latitude = 0.0
                UserPinInformation.longitude = 0.0
                completionHandler(true, nil)
            } else {
                print(error!)
                completionHandler(false, error)
            }
        }
    }
    
}
