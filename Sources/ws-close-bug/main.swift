import WebSocket

struct EchoResponder: HTTPServerResponder {
    func respond(to req: HTTPRequest, on worker: Worker) -> Future<HTTPResponse> {
        let res = HTTPResponse(body: req.body)
        return worker.eventLoop.newSucceededFuture(result: res)
    }
}

let group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
defer { try! group.syncShutdownGracefully() }

let ws = HTTPServer.webSocketUpgrader(shouldUpgrade: { req in
    return [:]
}, onUpgrade: { ws, req in
    ws.send("Connected!")
    
    ws.onError { ws, error in
        print("onError")
    }
    ws.onClose.always {
        print("onClose")
    }
    ws.onCloseCode { closeCode in
        print("onCloseCode: \(closeCode)")
    }
})

let server = try HTTPServer.start(
    hostname: "localhost",
    port: 4040,
    responder: EchoResponder(),
    upgraders: [ws],
    on: group
    ).wait()
try server.onClose.wait()

