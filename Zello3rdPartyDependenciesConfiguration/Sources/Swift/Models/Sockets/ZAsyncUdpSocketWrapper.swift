import Foundation
import Utility
import CocoaAsyncSocket

final class ZAsyncUdpSocketWrapper: NSObject, ZAsyncUdpSocket {

  init(delegate: ZAsyncUdpSocketDelegate?, delegateQueue: DispatchQueue?) {
    self.delegate = delegate
    self.delegateQueue = delegateQueue
    super.init()
  }

  // MARK: - ZAsyncUdpSocket

  weak var delegate: ZAsyncUdpSocketDelegate?

  func localAddress() -> Data? {
    socketUdp.localAddress()
  }

  func localHost() -> String? {
    socketUdp.localHost()
  }

  var localPort: UInt16 {
    socketUdp.localPort()
  }

  var isClosed: Bool {
    socketUdp.isClosed()
  }

  func isIPv4() -> Bool {
    socketUdp.isIPv4()
  }

  func bind(toPort port: UInt16, error: NSErrorPointer) -> Bool {
    do {
      try socketUdp.bind(toPort: port)
      return true
    } catch let caughtError {
      error?.pointee = caughtError as NSError
      return false
    }
  }

  func beginReceiving(_ error: NSErrorPointer) -> Bool {
    do {
      try socketUdp.beginReceiving()
      return true
    } catch let caughtError {
      error?.pointee = caughtError as NSError
      return false
    }
  }

  func sendData(_ data: Data, toHost host: String, port: UInt16, withTimeout timeout: TimeInterval, tag: Int) {
    socketUdp.send(data, toHost: host, port: port, withTimeout: timeout, tag: tag)
  }

  func close() {
    socketUdp.close()
  }

  func perform(_ block: @escaping () -> Void) {
    socketUdp.perform(block)
  }

  func socketFD() -> Int32 {
    socketUdp.socketFD()
  }

  func socket4FD() -> Int32 {
    socketUdp.socket4FD()
  }

  func socket6FD() -> Int32 {
    socketUdp.socket6FD()
  }

  static func getHost(_ hostPtr: AutoreleasingUnsafeMutablePointer<NSString?>?, port: UnsafeMutablePointer<UInt16>?, fromAddress address: Data) -> Bool {
    GCDAsyncUdpSocket.getHost(hostPtr, port: port, fromAddress: address)
  }

  // MARK: - Private

  private var delegateQueue: DispatchQueue?
  private lazy var socketUdp: GCDAsyncUdpSocket = {
    let socketUdp = GCDAsyncUdpSocket(delegate: self, delegateQueue: delegateQueue)
    delegateQueue = nil
    return socketUdp
  }()
}

extension ZAsyncUdpSocketWrapper: GCDAsyncUdpSocketDelegate {
  func udpSocket(_ sock: GCDAsyncUdpSocket, didConnectToAddress address: Data) {
    delegate?.udpSocket(self, didConnectToAddress: address)
  }

  func udpSocket(_ sock: GCDAsyncUdpSocket, didNotConnect error: Error?) {
    delegate?.udpSocket(self, didNotConnect: error)
  }

  func udpSocket(_ sock: GCDAsyncUdpSocket, didSendDataWithTag tag: Int) {
    delegate?.udpSocket(self, didSendDataWithTag: tag)
  }

  func udpSocket(_ sock: GCDAsyncUdpSocket, didNotSendDataWithTag tag: Int, dueToError error: Error?) {
    delegate?.udpSocket(self, didNotSendDataWithTag: tag, dueToError: error)
  }

  func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
    delegate?.udpSocket(self, didReceiveData: data, fromAddress: address, withFilterContext: filterContext)
  }

  func udpSocketDidClose(_ sock: GCDAsyncUdpSocket, withError error: Error?) {
    delegate?.udpSocketDidClose(self, withError: error)
  }
}
