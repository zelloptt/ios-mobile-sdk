import Utility
import SnowplowTracker

let namespace = "zello-sdk-ios"
let endpoint = "https://track.zello.com"
let schemaPrefix = "iglu:com.zello"

final class SnowplowAnalyticsProxyImpl: SnowplowAnalyticsProxy, Logging {
    var shouldTrack: Bool = false
    var shouldLog: Bool = false

    lazy var trackerController: TrackerController? = {
        guard let trackerController = Snowplow.createTracker(namespace: namespace, endpoint: endpoint, {
            TrackerConfiguration()
                .base64Encoding(false)
                .sessionContext(true)
                .platformContext(true)
                .lifecycleAutotracking(true)
                .screenViewAutotracking(false)
                .screenContext(true)
                .applicationContext(true)
                .exceptionAutotracking(false)
                .installAutotracking(true)
                .userAnonymisation(false)
            SessionConfiguration(
                foregroundTimeout: Measurement(value: 30, unit: .minutes),
                backgroundTimeout: Measurement(value: 30, unit: .minutes)
            )
        }) else {
            return nil
        }
        return trackerController
    }()
    var userProperties: [String: Any] = [
        // Snowplow is only available in an SDK environment.
        "environment": "sdk"
    ]

    func setUserProperty(_ value: String?, forName name: String) {
        if shouldTrack {
            userProperties[name] = value
            let staticContext = SelfDescribingJson(schema: "\(schemaPrefix)/user_properties/jsonschema/1-0-0", andData: userProperties)
            let staticGlobalContext = GlobalContext(staticContexts: [staticContext])
            _ = trackerController?.globalContexts?.remove(tag: "userData")
            // Tags are unique, so we can’t add a context without removing it first or something else.
            if trackerController?.globalContexts?.add(tag: "userData", contextGenerator: staticGlobalContext) == false {
                logWarning("Unable to set user property “\(name)” to “\(value ?? "(null)")”.")
            }
        }
        if shouldLog {
            logInfo("\(name) : \(value ?? "nil")")
        }
    }

    func setUserId(_ value: String) {
        if shouldTrack {
            trackerController?.subject?.userId = value
        }
        if shouldLog {
            logInfo("\(value))")
        }
    }

    func resetUserId() {
        trackerController?.subject?.userId = nil
        if shouldLog {
            logInfo("resetUserId")
        }
    }

    func logEvent(_ identifier: String, parameters: [String: Any]) {
        if shouldTrack {
            let sanitizedIdentifier = identifier.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? identifier
            // TODO: Vary schema version by event identifier.
            _ = trackerController?.track(SelfDescribing(schema: "\(schemaPrefix)/\(sanitizedIdentifier)/jsonschema/1-0-0", payload: parameters))
        }
        if shouldLog {
            logInfo("\(identifier) : \(parameters)")
        }
    }

    func shouldTrack(_ shouldTrack: Bool, shouldLog: Bool) {
        self.shouldTrack = shouldTrack
        self.shouldLog = shouldLog
    }
}
