import Foundation

struct Networking {
    typealias responseHandler = (data: NSData?, response: NSURLResponse?, error: NSError?)->Void
    
    struct APIEndPoint {
        let method: HTTPMethod
        let url: NSURL
        let payloadType: NetworkingDataType?
        //explict restriction on payload data type
        
        //let template: [String: FormValueDataType]
        //template is only for POSTing forms and JSON?
        init(method: HTTPMethod, url: NSURL, payloadType: NetworkingDataType?)
        {
            self.method = method
            self.url = url
            self.payloadType = payloadType
        }
        
        init(method: HTTPMethod, urlString: String, payloadType:NetworkingDataType? = nil)
        {
            self.init(method: method, url: NSURL(string: urlString)!, payloadType: payloadType)
        }
    }
    
    static let defaultResopnseHandler: responseHandler = { _, _, _ in }
    
    static let CRLF = "\r\n"
    
    enum HTTPMethod: String {
        case GET, POST
    }
    
    enum NetworkingDataType {
        case JSON
        case URLEncodedForm
        case MultipartFormData
        //x-www-form-urlencoded and multipart/form-data are interchangeable unless explictly specified
        //case Anything
    
    }
    
    //contains logic that determines in which form should we deliver our data
    //for data that contains non-string, only multipart/form-data is supported for now
    struct Payload {
        let type: NetworkingDataType
        let data: Any
        
        init?(type: NetworkingDataType, data: Any)
        {
            self.type = type
            switch type{
            case .MultipartFormData:
                guard let input = data as? [String: FormValueDataType] else { return nil }
                self.data = Multipart(form: input)
            case .URLEncodedForm:
                guard let input = data as? [String: String] else { return nil }
                
                self.data = input.map { k, v in k+"="+v}
                    .joinWithSeparator("&")
                .stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
                .dataUsingEncoding(NSUTF8StringEncoding)
            default: self.data = try! NSJSONSerialization.dataWithJSONObject(data as! [String: String], options: [])
            }
            
        }
        
        //automatic type inference
        init?(data: Any)
        {
            switch data {
            case let x as [String: FormValueDataType] where !(x is [String: String]):
                self.init(type: .MultipartFormData, data: data)
            case is [String: FormValueDataType]:
                self.init(type: .URLEncodedForm, data: data)
            default:
                self.init(type: .JSON, data: data)
            }
        }
        
        
        var headers: [String: String] {
            switch type {
            case .MultipartFormData: return (data as! Multipart).headers
            case .URLEncodedForm: return ["Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"]
            case .JSON: return ["Content-Type": "application/json"]
            }
        }
        
        //NSInputStream or NSData
        var dataOrStream: AnyObject {
            switch type {
            case .MultipartFormData:
                let d = data as! Multipart
                return d.contentLength >= CONSTANT.ENDPOINT.THRESHOLD_SIZE_FOR_USING_STREAM ? d.stream() : d.data
            default: return self.data as! NSData
            }
        }
    }
}


