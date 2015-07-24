$original_sunspot_session = ::Sunspot.session
$proxy_sunspot_session = Sunspot::Rails::StubSessionProxy.new($original_sunspot_session)
Sunspot.session = $proxy_sunspot_session

module SolrSpecHelper

  def unstub_solr
    unless $sunspot
      $sunspot = ::Sunspot::Rails::Server.new

      pid = fork do
        STDERR.reopen("/dev/null")
        STDOUT.reopen("/dev/null")
        $sunspot.run
      end
      # shut down the Solr server
      at_exit { Process.kill("TERM", pid) }
      # wait for solr to start
      20.times do
        if solr_running?
          break
        end
        sleep 0.5
      end
    end

    ::Sunspot.session = $original_sunspot_session
  end

  def stub_solr
    ::Sunspot.session = $proxy_sunspot_session
  end

  def solr_running?
    if $sunspot
      response = nil
      Net::HTTP.start("localhost", $sunspot.port) do |http|
        response = http.head("/solr/")
      end
      response.class == Net::HTTPOK
    end
  rescue Errno::ECONNREFUSED
    false
  end
end
