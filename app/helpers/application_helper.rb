require 'net/http'
module ApplicationHelper
  
  # Return a title on a per-page basis.
  def title
    base_title = "OLN"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  def uldaman_status
    http = Net::HTTP.new("us.battle.net", 80)
    realm_status = http.request(Net::HTTP::Get.new("/api/wow/realm/status?realms=Uldaman"))
    @uldaman_status = JSON.parse(realm_status.body)['realms'][0]['status']
    if @uldaman_status == true
      "up"
    elsif @uldaman_status == false
      "down"
    else
      "status check broken"
    end
  end

  def oln_status
    http = Net::HTTP.new("us.battle.net", 80)
    guild_status = http.request(Net::HTTP::Get.new("/api/wow/guild/Uldaman/ominous%20latin%20noun"))
    parsed_stats = JSON.parse(guild_status.body)
    @oln_level = parsed_stats['level']
    @oln_points = parsed_stats['achievementPoints']
  end

end
