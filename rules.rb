# Test using:
#
#     maid clean -n
#
# For more help on Maid:
#
# * Run `maid help`
# * Read the README, tutorial, and documentation at https://github.com/benjaminoakes/maid#maid

require Dir.pwd + '/webloc.rb'
require Dir.pwd + '/bookmark.rb'

Maid.rules do
  rule 'Delete Downloaded ISOs' do
    trash(dir('~/Downloads/*.iso'))
  end

  rule 'Trash downloaded software' do
    # These can generally be downloaded again very easily if needed...
    # but just in case, give me a few days before trashing them.
    dir('~/Downloads/*.{dmg,pkg}').each do |p|
      trash(p) if accessed_at(p) > 3.days.ago
    end

    osx_app_extensions = %w(app dmg pkg wdgt)
    osx_app_patterns = osx_app_extensions.map { |ext| (/\.#{ext}\/$/) }

    zips_with_osx_apps_inside = dir('~/Downloads/*.zip').select do |path|
      candidates = zipfile_contents(path)
      candidates.any? { |c| osx_app_patterns.any? { |re| c.match(re) } }
    end

    trash(zips_with_osx_apps_inside)
  end

  rule 'Move Mac OSX applications to Applications' do
    dir('~/Downloads/*.app').each do |path|
      move(path, '/Applications/')
    end
  end

  rule 'Delete Misc Screenshots' do
    dir('~/Desktop/Screen Shot *').each do |p|
      if accessed_at(p) > 3.days.ago
        trash(p)
      end
    end
  end

  rule 'Move MP3s likely to be music' do
    dir('~/Downloads/*.mp3').each do |path|
      if duration_s(path) > 30.0
        move(path, '~/Dropbox/Music/')
      end
    end
  end
  
  rule 'Move Videos to Movies folder' do
    dir('~/Downloads/*.{mp4,mpg}').each do |path|
      move(path, '~/Desktop/Movies/')
    end
  end
  
  rule "Trash files that shouldn't have been downloaded" do
    # It's rare that I download these file types and don't put them somewhere else quickly.
    # More often, these are still in Downloads because it was an accident.
    dir('~/Downloads/*.{csv,doc,docx,ics,ppt,pptx,js,rb,xml,xlsx}').each do |p|
      trash(p) if accessed_at(p) > 3.days.ago
    end

    # Quick 'n' dirty duplicate download detection
    trash(dir('~/Downloads/* (1).*'))
    trash(dir('~/Downloads/* (2).*'))
    trash(dir('~/Downloads/*.1'))
  end
  
  rule "Bookmark links on Desktop" do
    dir('~/Desktop/*.webloc').each do |link|
      if accessed_at(link) > 3.days.ago
        w = Webloc.new(link)
        Bookmark.save(w.url, w.title)
        trash(link)
      end
    end
  end

  # # NOTE: Currently, only Mac OS X supports `downloaded_from`.
  # rule 'Old files downloaded while developing/testing' do
  #   dir('~/Downloads/*').each do |path|
  #     if downloaded_from(path).any? { |u| u.match('http://localhost') || u.match('http://staging.yourcompany.com') } &&
  #         1.week.since?(accessed_at(path))
  #       trash(path)
  #     end
  #   end
  # end
end