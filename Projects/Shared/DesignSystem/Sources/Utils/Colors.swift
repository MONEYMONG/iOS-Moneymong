import UIKit

public enum Colors {
  public enum White {
    public static let _1: UIColor = UIColor(hexString: "FFFFFF")
  }
  
  public enum Black {
    public static let _1: UIColor = UIColor(hexString: "000000")
  }
  
  public enum Gray {
    public static let _10: UIColor = UIColor(hexString: "0F1114")
    public static let _9: UIColor = UIColor(hexString: "191A1E")
    public static let _8: UIColor = UIColor(hexString: "292C34")
    public static let _7: UIColor = UIColor(hexString: "37404F")
    public static let _6: UIColor = UIColor(hexString: "49556A")
    public static let _5: UIColor = UIColor(hexString: "77859E")
    public static let _4: UIColor = UIColor(hexString: "A6B4CA")
    public static let _3: UIColor = UIColor(hexString: "D9E1ED")
    public static let _2: UIColor = UIColor(hexString: "E7EDF7")
    public static let _1: UIColor = UIColor(hexString: "F6F8FC")
    public static let _300: UIColor = UIColor(hexString: "CDD2D9")
  }
  
  public enum Blue {
    public static let _4: UIColor = UIColor(hexString: "5562FF")
    public static let _3: UIColor = UIColor(hexString: "98A0FF")
    public static let _2: UIColor = UIColor(hexString: "CCCFFF")
    public static let _1: UIColor = UIColor(hexString: "EEEFFF")
  }
  
  public enum SkyBlue {
    public static let _1: UIColor = UIColor(hexString: "C7F4FF")
  }
  
  public enum Mint {
    public static let _3: UIColor = UIColor(hexString: "49DFBB")
    public static let _2: UIColor = UIColor(hexString: "7CE9CF")
    public static let _1: UIColor = UIColor(hexString: "E4FAF5")
  }
  
  public enum Yellow {
    public static let _1: UIColor = UIColor(hexString: "FFE600")
  }
  
  public enum Red {
    public static let _3: UIColor = UIColor(hexString: "FF5473")
    public static let _2: UIColor = UIColor(hexString: "FF8CA0")
    public static let _1: UIColor = UIColor(hexString: "FFEEF1")
  }
}

public extension UIColor {
  convenience init(hexString: String, opacity: Double = 1.0) {
    let hex: Int = Int(hexString, radix: 16) ?? 0
    let red = Double((hex >> 16) & 0xff) / 255
    let green = Double((hex >> 8) & 0xff) / 255
    let blue = Double((hex >> 0) & 0xff) / 255
    
    self.init(red: red, green: green, blue: blue, alpha: opacity)
  }
}
