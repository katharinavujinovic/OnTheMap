//
//  UserDataResponse.swift
//  OnTheMap
//
//  Created by Katharina Müllek on 04.02.21.
//

import Foundation

struct UserDataResponse: Codable {
    let user: User
}

struct User: Codable {
    let lastName: String
    let firstName: String
    
    enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
        case firstName = "first_name"
        }
}

/*
 {,"social_accounts":[],"mailing_address":null,"_cohort_keys":[],"signature":null,"_stripe_customer_id":null,"guard":{},"_facebook_id":null,"timezone":null,"site_preferences":null,"occupation":null,"_image":null,"first_name":"Dayna","jabber_id":null,"languages":null,"_badges":[],"location":null,"external_service_password":null,"_principals":[],"_enrollments":[],"email":{"address":"dayna.wintheiser@onthemap.udacity.com","_verified":true,"_verification_code_sent":true},"website_url":null,"external_accounts":[],"bio":null,"coaching_data":null,"tags":[],"_affiliate_profiles":[],"_has_password":true,"email_preferences":null,"_resume":null,"key":"46897990","nickname":"Dayna Wintheiser","employer_sharing":false,"_memberships":[],"zendesk_id":null,"_registered":false,"linkedin_url":null,"_google_id":null,"_image_url":"https://robohash.org/udacity-46897990"}
 
 http://video.udacity-data.com.s3.amazonaws.com/topher/2016/June/575840d1_get-user-data/get-user-data.json
 */
