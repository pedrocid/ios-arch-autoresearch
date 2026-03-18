import Foundation

extension APIClient {
    public func authenticate(username: String, password: String) async throws -> String {
        let body = ["username": username, "password": password]
        let jsonData = try JSONSerialization.data(withJSONObject: body)

        let url = URL(string: "\(baseURL)/auth/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, _) = try await URLSession.shared.data(for: request)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        let token = json["token"] as! String
        return token
    }
}
