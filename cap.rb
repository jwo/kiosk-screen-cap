require 'screencap'
require 'ruby-progressbar'
require 'mechanize'

max_number = 20

a = Mechanize.new { |agent|
  agent.user_agent_alias = 'Mac Safari'
}
a.get "http://dorton.co/tiykiosk" do |page|
  max_number = page.search("section").count
end

progress = ProgressBar.create(:title => "Slides", :total => max_number+1)

files = []

(1..max_number).to_a.each do |i|

  tmp_slide_jpg = "tmp-dorton-slide-#{i}.png"
  slide_jpg = "dorton-slide-#{i}.jpg"



  fetcher_object = Screencap::Fetcher.new("http://dorton.co/tiykiosk/#/#{i}")
  screenshot = fetcher_object.fetch output: tmp_slide_jpg, width: 1700, height: 850

  system "composite -compose atop -geometry x200+20 -gravity southeast -background none ./watermark.svg ./#{tmp_slide_jpg} ./#{slide_jpg}"
  system "rm #{tmp_slide_jpg}"

  files << slide_jpg


  progress.increment


end

system "convert #{files.join(" ")} -append result.jpg"
progress.increment


