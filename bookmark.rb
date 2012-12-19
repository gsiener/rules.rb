require 'dotenv'
require 'www/delicious'
Dotenv.load

class Bookmark
  
  def self.save(url, title, tags = "via Maid")

    # the current delicious gem ignores tags, per issue #16 https://github.com/weppos/www-delicious/issues/16
    title += " (via Maid)"
    client.posts_add(:url => url, :title => title, :tags => tags)
  end

  private
  def self.client
    @client ||= WWW::Delicious.new(ENV['DELICIOUS_USER'], ENV['DELICIOUS_PASS'])
  end
  
  def self.updated_at
    client.update
  end
end