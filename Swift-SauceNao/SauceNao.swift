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

	public func search(url: String, numres: UInt = 16, completion: @escaping (_ result: Any?, _ error: Error?) -> Void) {
		guard self.checkLimiters() else {
			return
		}

		self.doUpload(numres, formData: { (form) in
			form.append("999", withName: "db")
			form.append(url, withName: "url")
		}, completion: completion)
	}

	public func search(data: Data, fileName: String, mimeType: String, numres: UInt = 16, completion: @escaping (_ result: Any?, _ error: Error?) -> Void) {
		guard self.checkLimiters() else {
			return
		}
		//parameters["dbmask"] = "0"
		//parameters["dbmaski"] = "0"
		self.doUpload(numres, formData: { (form) in
			form.append(data, withName: "file", fileName: fileName, mimeType: mimeType)
			form.append("999", withName: "db")
		}) { (obj, err) in
			completion(obj, err)
		}
	}

	public func search(file: URL, numres: UInt = 16, completion: @escaping (_ result: Any?, _ error: Error?) -> Void) {
		guard self.checkLimiters() else {
			return
		}

		self.doUpload(numres, formData: { (form) in
			form.append(file, withName: "file")
			form.append("999", withName: "db")
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

	private func doUpload(_ numres: UInt, formData: @escaping (MultipartFormData) -> Void, completion: @escaping (_ result: Any?, _ error: Error?) -> Void) {
		var request = URLRequest(url: SauceNao.defaultUrl)
		request.httpMethod = "POST"
		let queue = DispatchQueue(label: "request")
		SessionManager.default.upload(multipartFormData: { (form) in
			form.append(self.apiKey, withName: "api_key")
			form.append("2", withName: "output_type")
			form.append(self.testmode, withName: "testmode")
			form.append(String(numres), withName: "numres")
			formData(form)
		}, with: request, queue: queue) { (result) in
			switch result {
			case .success(let request, _, _):
				request.responseJSON(queue: queue, options: []) { response in
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
