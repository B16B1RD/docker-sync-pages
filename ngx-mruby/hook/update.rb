def hmac_secure_compare(a, b)
  ## see Rack::Utils.secure_compare
  ## Special thanks to @minimum2scp.
  return false unless a.bytesize == b.bytesize
  l = a.unpack("C*")
  r, i = 0, -1
  b.each_byte { |v| r |= v ^ l[i+=1] }
  r == 0
end

request = Nginx::Request.new
begin
  signature = 'sha1=' + Digest::HMAC.hexdigest(request.body, ENV['GITHUB_SECRET_TOKEN'], Digest::SHA1)
  if hmac_secure_compare(signature, request.headers_in['X-Hub-Signature'])
    payload = JSON::parse(request.body)
    if request.headers_in['X-Github-Event'] == 'push' && payload['ref'].end_with?('/' + ENV['GITHUB_BRANCH'])
      if system('/usr/local/bin/update-site.sh')
        Nginx.echo 'Update successful!'
      else
        Nginx.echo 'Update failure!'
      end
    else
      Nginx.echo 'Update ignored!'
    end
  else
    Nginx.errlogger Nginx::LOG_ERR, "signagure = #{signature}"
    Nginx.return Nginx::HTTP_FORBIDDEN
  end
rescue => e
  Nginx.errlogger Nginx::LOG_ERR, "#{e.inspect}"
  Nginx.return Nginx::HTTP_FORBIDDEN
end