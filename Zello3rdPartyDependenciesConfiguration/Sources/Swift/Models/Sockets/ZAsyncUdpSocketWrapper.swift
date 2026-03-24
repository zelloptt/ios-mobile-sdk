import Foundation
import Utility
import CocoaAsyncSocket

final class ZAsyncUdpSocketWrapper: NSObject, UnifiedUDPSocket {
    init(delegate: UnifiedUDPSocketDelegate?, delegateQueue: DispatchQueue?) {
        self.delegate = delegate
        self.delegateQueue = delegateQueue
        super.init()
    }

    // MARK: - UnifiedUDPSocket

    weak var delegate: UnifiedUDPSocketDelegate?

    func localAddress() -> Data? {
        socketUdp.localAddress()
    }

    var localHost: String {
        socketUdp.localHost() ?? ""
    }

    var localPort: UInt16 {
        socketUdp.localPort()
    }

    var isClosed: Bool {
        socketUdp.isClosed()
    }

    var isIPv4: Bool {
        socketUdp.isIPv4()
    }

    func bindToPort(_ port: UInt16, error: NSErrorPointer) -> Bool {
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

    func sendData(_ data: Data, toHost host: String, port: UInt16, withTimeout timeout: TimeInterval, tag: Int64) {
        socketUdp.send(data, toHost: host, port: port, withTimeout: timeout, tag: Int(tag))
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

    var socket4FD: Int32 {
        socketUdp.socket4FD()
    }

    func socket6FD() -> Int32 {
        socketUdp.socket6FD()
    }

    var isListening: Bool = false

    func performBlock(_ block: @escaping () -> Void) {
        // no-op
    }

    static func getHost(_ host: AutoreleasingUnsafeMutablePointer<NSString?>, port: UnsafeMutablePointer<UInt16>, fromAddress address: Data) {
        GCDAsyncUdpSocket.getHost(host, port: port, fromAddress: address)
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
    func udpSocket(_ sock: GCDAsyncUdpSocket, didSendDataWithTag tag: Int) {
        delegate?.udpSocket(self, didSendDataWithTag: Int64(tag))
    }

    func udpSocket(_ sock: GCDAsyncUdpSocket, didNotSendDataWithTag tag: Int, dueToError error: Error?) {
        delegate?.udpSocket(self, didNotSendDataWithTag: Int64(tag), dueToError: error)
    }

    func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        delegate?.udpSocket(self, didReceiveData: data, fromAddress: address, withFilterContext: filterContext)
    }

    func udpSocketDidClose(_ sock: GCDAsyncUdpSocket, withError error: Error?) {
        delegate?.udpSocketDidClose(self, withError: error)
    }
}
