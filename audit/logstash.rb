module MCollective
  module RPC
    class Logstash<Audit
      # Writes audit information into a Logstash friendly json file.
      # Target file can be configured in as
      #    plugin.logstash.target = /var/log/mcollective/new.log
      #
      # Defaults to /var/log/mcollective-logstashaudit.log
      def audit_request(request, connection)
        require 'json'
        config = Config.instance

        now = Time.now.utc
        timezone = now.utc? ? 'Z' : now.strftime("%z")
        now_iso8601 = "%s.%06d%s" % [now.strftime("%Y-%m-%dT%H:%M:%S"), now.tv_usec, timezone]

        request_time= Time.at(request.time)
        request_timezone = request_time.utc? ? 'Z' : request_time.strftime("%z")
        request_time_iso8601 = "%s.%06d%s" % [request_time.strftime("%Y-%m-%dT%H:%M:%S"), request_time.tv_usec, request_timezone]

        audit_entry = {"@source_host" => config.identity,
          '@tags' => [],
          '@type' => 'mcollective-audit',
          '@source' => 'mcollective-audit',
          '@timestamp' => now_iso8601,
          '@fields' => {'uniqid' => request.uniqid,
                        'request_time' => request_time_iso8601,
                        'caller' => request.caller,
                        'callerhost' => request.sender,
                        'agent' => request.agent,
                        'action' => request.action,
                        'data' => request.data.pretty_print_inspect},
          '@message' => "#{config.identity}: #{request.caller}@#{request.sender} invoked agent #{request.agent}##{request.action}"}

        target = config.pluginconf.fetch('logstash.target', '/var/log/mcollective-logstashaudit.log')

        begin
          File.open(target, 'a') do |f|
            f.puts audit_entry.to_json
          end
        rescue => e
          Log.warn("Cannot write to audit file %s: %s", [target, e.to_s])
        end
      end
    end
  end
end
