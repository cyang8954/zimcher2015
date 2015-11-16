import Foundation
import UIKit

protocol APIEndPointsCollection {
    static var BASE_ENDPOINT_URL: String {get}
    static func CREATE_ENDPOINT(method: Networking.HTTPMethod, endPointString: String, payloadType: Networking.NetworkingDataType?) -> Networking.APIEndPoint
}

extension APIEndPointsCollection {
    static func CREATE_ENDPOINT(method: Networking.HTTPMethod = CONSTANT.ENDPOINT.DEFAULT_METHOD, endPointString: String, payloadType: Networking.NetworkingDataType? = nil) -> Networking.APIEndPoint
    {
        return Networking.APIEndPoint(method: method, urlString: BASE_ENDPOINT_URL + endPointString, payloadType: payloadType)
    }
}

struct CONSTANT {
    struct VALIDATION {
        //email
        static let EMAIL_USE_STRICT_FILTER = false
        private static let EMAIL_STRICTER_FILTER_STRING = "^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$"
        private static let EMAIL_LAX_STRING = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
        static let EMAIL_FILTER = EMAIL_USE_STRICT_FILTER ? EMAIL_STRICTER_FILTER_STRING : EMAIL_LAX_STRING
        
        //user name
        static let USER_NAME_ALLOWED_CHARS = "^[A-Za-z0-9_ ]*$"
    }
    
    struct ENDPOINT {
        static let DEFAULT_METHOD = Networking.HTTPMethod.GET
        //meaningless?
        static let THRESHOLD_SIZE_FOR_USING_STREAM = UInt64(((100) << 3 + 000) << 3 + 000)
        
        private struct BASE_URL {
            static let URL = "http://zimcher.azurewebsites.net/"
            static let API_URL = URL + "api/"
        }
        
        struct USER: APIEndPointsCollection {
            static let BASE_ENDPOINT_URL = BASE_URL.API_URL + "users/"
            
            static let ALL_USERS = USER.CREATE_ENDPOINT(.GET, endPointString: "getallusers")
            static let FIND_BY_ID = USER.CREATE_ENDPOINT(.POST, endPointString: "finduserbyid", payloadType: .URLEncodedForm)
            static let FIND_BY_EMAIL = USER.CREATE_ENDPOINT(.POST, endPointString: "finduserbyemail", payloadType: .JSON)
            static let REGISTER = USER.CREATE_ENDPOINT(.POST, endPointString: "createuser", payloadType: .JSON)
            static let UPLOAD_AVATAR = USER.CREATE_ENDPOINT(.POST, endPointString: "uploadUserImage", payloadType: .MultipartFormData)
        }
        
        struct MEDIA: APIEndPointsCollection {
            static let BASE_ENDPOINT_URL = BASE_URL.API_URL + "videos/"
            
            static let ALL_VIDEOS = MEDIA.CREATE_ENDPOINT(.GET, endPointString: "getallvideos")
            static let UPLOAD = MEDIA.CREATE_ENDPOINT(.POST, endPointString: "uploadVideo", payloadType: .MultipartFormData)
        }
        
        struct REVIEW: APIEndPointsCollection {
            static let BASE_ENDPOINT_URL = BASE_URL.API_URL + "reviews/"
            
            static let CREATE = REVIEW.CREATE_ENDPOINT(.POST, endPointString: "createReview", payloadType: .JSON)
        }
        
        struct CHANNEL: APIEndPointsCollection {
            static let BASE_ENDPOINT_URL = BASE_URL.API_URL + "channels/"
            
            static let GET_CHANNEL_BY_NAME = CHANNEL.CREATE_ENDPOINT(.POST, endPointString: "searchChannelByName", payloadType: .URLEncodedForm)
            static let GET_ALL_CHANNELS = CHANNEL.CREATE_ENDPOINT(.GET, endPointString: "getAllChannels")
        }
        

    }
    
    struct JSON_KEY_PATH {
        struct MEDIA {
            static let ID = "videoId"
            static let NAME = "videoName"
            static let URL = "videoURL"
            static let IMAGE = "videoImage"
            static let USER_ID = "userId"
            static let CHANNEL_ID = "channelId"
            static let USER = "user"
            static let CHANNEL = "channel"
        }

        struct USER {
            static let ID = "userID"
            static let NAME = "userName"
            static let EMAIL = "userEmail"
            static let CITY = "userCity"
            static let STATE = "userState"
            static let IMAGE = "userImage"
        }

        struct CHANNEL {
            static let ID = "channelId"
            static let NAME = "channelName"
            static let TYPE = "channelType"
            static let MANAGER_ID = "managerId"
        }
    }
    
    struct REGISTER {
        static let USERNAME_KEY = "username"
        static let PASSWORD_KEY = "password"
        static let EMAIL_KEY = "email"
    }
    
    struct COLORSCHEME_DEFAULT {

    }
    
    struct PALETTE_DEFAULT {
       static let BLUE = UIColor(red: 96/256.0, green: 111/256.0, blue: 214/256.0, alpha: 1)
        static let DARK_BLUE = UIColor(red: 22/256.0, green: 24/256.0, blue: 45/256.0, alpha: 1)
        static let SLATE_BLUE = UIColor(red: 95/256.0, green: 108/256.0, blue: 217/256.0, alpha: 0.9)
        static let CORN_FLOWER_BLUE = UIColor(red: 95/256.0, green: 108/256.0, blue: 217/256.0, alpha: 1)
    }
    
    struct UI {
        static let LOGIN_BUTTON_CORNER_RADIUS = CGFloat(3.0)
    }
}