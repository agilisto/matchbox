require 'digest/sha1'

module Utils
  def self.make_token
    args = [Time.now, (1..10).map{ rand.to_s }]
    Digest::SHA1.hexdigest(args.flatten.join('--'))
  end
end