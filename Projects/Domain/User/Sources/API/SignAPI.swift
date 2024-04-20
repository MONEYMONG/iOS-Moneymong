import Foundation
import Moya
import BaseDomain

public enum SignAPI {
  case sign(SignModelRequestDTO)
}

extension SignAPI: TargetType {
  public var baseURL: URL {
    return URL(string: "https://dev.moneymong.site/api/")!
  }

  public var path: String {
    switch self {
    case .sign: return "v1/outbound/countries"
    }
  }

  public var method: Moya.Method {
    switch self {
    case .sign: return .post
    }
  }

  public var task: Moya.Task {
    switch self {
    case .sign(let requst):
      return .requestJSONEncodable(requst)
    }
  }

  public var headers: [String: String]? {
    return [
      "Accept": "application/json;charset=UTF-8",
      "Content-Type": "application/json;charset=UTF-8",
    ]
  }

//  var sampleData: Data {
//    switch self {
//    case .getCourseList: NSDataAsset(name: "CourseListSampleData")!.data
//    case .getCourse: NSDataAsset(name: "CourseSampleData")!.data
//    case .getLectureList: NSDataAsset(name: "LectureListSampleData")!.data
//    }
//  }
}
