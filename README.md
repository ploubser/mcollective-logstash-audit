#Logstash RPC Audit Logs

This is a [SimpleRPC Audit Plugin](http://docs.puppetlabs.com/mcollective/simplerpc/auditing.html) that writes audit events to a json file that can
easily be consumed by logstash.

[Logstash](http://code.google.com/p/logstash/) is an opensource project that stores log lines and allow you to do full text and meta data based searches on that data.

[picture](/images/mcollective-logstash.png)

The image above shows a screenshot of Kibana showing all RPC requests made by a specific client, you can also see meta data for one of the requests.

###Installation

* Follow the [basic plugin install guide](http://projects.puppetlabs.com/projects/mcollective-plugins/wiki/InstalingPlugins).
* You need to have the JSON RubyGem install on all nodes

###Configuration

There is one plugin configuration setting for the service agent.

* target - The json file to write to. Defaults to /var/log/mcollective-logstashaudit.log

```
rpcaudit = 1
rpcauditprovider = logstash
plugin.logstash.target = /var/log/mcollective-audit.log
```
