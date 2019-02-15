//
//  SauceNao.swift
//  Swift-SauceNao
//
//  Created by Jaquet Vincent on 14.02.19.
//  Copyright © 2019 Vinrobot. All rights reserved.
//

import Foundation
import Alamofire

public class SauceNao {

	public static let defaultUrl: URL = URL(string: "https://saucenao.com/search.php")!

	private let apiKey: String
	private let testmode: String

	public init(apiKey: String, testmode: Bool = false) {
		self.apiKey = apiKey
		self.testmode = testmode ? "1" : "0"
	}

	public func search(url: URL, local: Bool = false) -> [String] {
		return [String]()
	}

	public func search(data: Data, numres: UInt = 5, completion: @escaping (_ result: Any?, _ error: Error?) -> Void) {
		guard self.checkLimiters() else {
			return
		}

		var parameters = [String: String]()
		parameters["api_key"] = self.apiKey
		parameters["output_type"] = "2"
		parameters["testmode"] = self.testmode
		//parameters["dbmask"] = "0"
		//parameters["dbmaski"] = "0"
		//parameters["db"] = "999"
		parameters["numres"] = String(numres)

		self.doUpload(formData: { (form) in
			for (key, value) in parameters {
				form.append(value.data(using: .utf8)!, withName: key)
			}
			form.append(data, withName: "file")
		}) { (obj, err) in
			completion(obj, err)
		}
	}

	private func checkLimiters() -> Bool {
		guard Limiter.longLimiter.canExecute() else {
			return false
		}
		guard Limiter.shortLimiter.canExecute() else {
			Limiter.longLimiter.cancelExecute()
			return false
		}
		return true
	}

	private func doUpload(formData: @escaping (MultipartFormData) -> Void, completion: @escaping (_ result: Any?, _ error: Error?) -> Void) {
		var request = URLRequest(url: SauceNao.defaultUrl)
		request.httpMethod = "POST"
		Alamofire.upload(multipartFormData: formData, with: request) { (result) in
			switch result {
			case .success(let request, _, _):
				request.responseJSON { (response) in
					if let error = response.result.error {
						completion(nil, error)
					}
					// Parse result
					completion(response.result.value, nil)
				}
				break
			case .failure(let error):
				completion(nil, error)
				break
			}
		}
	}
}
