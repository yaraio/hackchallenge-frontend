//
//  APIResponse.swift
//  HackChallengeFrontend
//
//  Created by Troy Corbitt on 5/1/26.
//
import Foundation

struct APIResponse<T: Decodable>: Decodable {
    let success: Bool
    let data: T?
    let error: String?
}

struct CreateTaskRequest: Encodable {
    let title: String
    let description: String
    let priority: Int
    let duration_minutes: Int
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let baseURL = "http://34.48.44.154"
    
    private init() { }
    
    func getTasks(userId: Int, completion: @escaping ([StudyTask]) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/users/\(userId)/tasks/") else {
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error fetching tasks: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let data = data else {
                completion([])
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(APIResponse<[StudyTask]>.self, from: data)
                completion(decodedResponse.data ?? [])
            } catch {
                print("Error decoding tasks: \(error)")
                completion([])
            }
        }.resume()
    }
    
    func createTask(
        userId: Int,
        title: String,
        description: String,
        priority: Int,
        durationMinutes: Int,
        completion: @escaping (StudyTask?) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)/api/users/\(userId)/tasks/") else {
            completion(nil)
            return
        }
        
        let taskRequest = CreateTaskRequest(
            title: title,
            description: description,
            priority: priority,
            duration_minutes: durationMinutes
        )
        
        do {
            let encodedData = try JSONEncoder().encode(taskRequest)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = encodedData
            
            URLSession.shared.dataTask(with: request) { data, _, error in
                if let error = error {
                    print("Error creating task: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                guard let data = data else {
                    completion(nil)
                    return
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(APIResponse<StudyTask>.self, from: data)
                    completion(decodedResponse.data)
                } catch {
                    print("Error decoding created task: \(error)")
                    completion(nil)
                }
            }.resume()
            
        } catch {
            print("Error encoding task: \(error)")
            completion(nil)
        }
    }
    
    func completeTask(taskId: Int, completion: @escaping (StudyTask?) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/tasks/\(taskId)/complete/") else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error completing task: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(APIResponse<StudyTask>.self, from: data)
                completion(decodedResponse.data)
            } catch {
                print("Error decoding completed task: \(error)")
                completion(nil)
            }
        }.resume()
    }
    
    func deleteTask(taskId: Int, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/tasks/\(taskId)/") else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print("Error deleting task: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            completion(true)
        }.resume()
    }
}
