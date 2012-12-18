# Test using:
#
#     maid clean -n
#
# For more help on Maid:
#
# * Run `maid help`
# * Read the README, tutorial, and documentation at https://github.com/benjaminoakes/maid#maid

Maid.rules do
  rule 'Delete Downloaded ISOs' do
    trash(dir('~/Downloads/*.iso'))
  end

  rule 'Delete Mac OS X applications in disk images' do
    trash(dir('~/Downloads/*.dmg'))
  end

  rule 'Delete Mac OS X applications in zip files' do
    found = dir('~/Downloads/*.zip').select { |path|
      zipfile_contents(path).any? { |c| c.match(/\.app$/) }
    }

    trash(found)
  end

  rule 'Delete Misc Screenshots' do
    dir('~/Desktop/Screen Shot *').each do |path|
      if 3.days.since?(accessed_at(path))
        trash(path)
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
    dir('~/Downloads/*.mp4').each do |path|
      move(path, '~/Desktop/Movies/')
    end
  end
  
  rule 'Move Videos to Movies folder' do
    dir('~/Downloads/*.mpg').each do |path|
      move(path, '~/Desktop/Movies/')
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
