require 'json'
require 'set'
require 'fileutils'
require_relative 'chromebrew/lib/color'

LATEST_PACKAGE_LIST = JSON.load_file('output/latest.json')

Dir.glob('output/*.rb') do |package|
  pkg_name = File.basename(package, '.rb')
  crew_ver = File.read("chromebrew/packages/#{pkg_name}.rb")[/version ['"](.+?)['"]/, 1]
  latest_ver = LATEST_PACKAGE_LIST[pkg_name]

  if crew_ver != LATEST_PACKAGE_LIST[pkg_name]
    puts "Update found for #{pkg_name}: #{crew_ver} => #{latest_ver}".lightcyan

    Dir.chdir 'chromebrew' do
      system "git checkout -b update_#{pkg_name}_#{Time.now.strftime("%Y%m%d")}"

      FileUtils.cp File.join('..', package), "packages/#{pkg_name}.rb"

      system "git add packages/#{pkg_name}.rb"
      system "git commit -m 'Auto-generated update for package #{pkg_name}: #{crew_ver} => #{latest_ver}'"
      system "git push"

      system "git checkout master"
    end
  end
end
