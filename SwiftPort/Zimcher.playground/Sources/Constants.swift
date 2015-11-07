//
//  Constants.swift
//  SwiftPort
//
//  Created by Weiyu Huang on 10/29/15.
//  Copyright © 2015 Kappa. All rights reserved.
//

import Foundation

public struct CONSTANT {
    public struct VALIDATION {
        //email
        public static let EMAIL_USE_STRICT_FILTER = false
        private static let EMAIL_STRICTER_FILTER_STRING = "^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$"
        private static let EMAIL_LAX_STRING = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
        public static let EMAIL_FILTER = EMAIL_USE_STRICT_FILTER ? EMAIL_STRICTER_FILTER_STRING : EMAIL_LAX_STRING
        
        
        //user name
        public static let USER_NAME_ALLOWED_CHARS = "^[A-Za-z0-9_ ]*$"
    }
    
    public struct URL {
        private static let BASE_URL = "http://zimcher.azurewebsites.net/"
        private static let BASE_API_URL = BASE_URL + "api/"
        
        //users
        private static let BASE_USER_API_URL = BASE_API_URL + "users/"
        
        public static let GET_ALL_USERS = BASE_USER_API_URL + "getallusers"
        public static let POST_FIND_USER_BY_ID = BASE_USER_API_URL + "finduserbyid/"
        public static let POST_LOGIN = BASE_USER_API_URL + "finduserbyemail"
        public static let POST_CREATE_USER = BASE_USER_API_URL + "createuser"
        
        //video
        private static let BASE_VIDEO_API_URL = BASE_API_URL + "videos/"
        
        
        public static let GET_ALL_VIDEOS = BASE_VIDEO_API_URL + "getallvideos"
        public static let POST_UPLOAD_VIDEO = BASE_VIDEO_API_URL + "uploadVideo"
        public static let POST_POST_VIDEO_INFO = BASE_VIDEO_API_URL + "postVideo"
        
        //channel
        private static let BASE_CHANNEL_API_URL = BASE_API_URL + "channels/"
        
        public static let GET_ALL_CHANNELS = BASE_CHANNEL_API_URL + "getAllChannels"
        public static let POST_SEARCH_CHANNEL_BY_NAME = BASE_CHANNEL_API_URL + "searchChannelByName"
        
    }
    
    struct JSON_KEY_PATH {
        struct VIDEO {
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
        static let USERNAME_KEY = "username";
        static let PASSWORD_KEY = "password";
        static let EMAIL_KEY = "email";
    }
}