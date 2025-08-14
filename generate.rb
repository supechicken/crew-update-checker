require 'json'
require_relative 'lib/color'
require_relative 'lib/deb_repository.rb'


Dir.glob('packages/*/') do |pkg_path|
  pkg_info = JSON.load_file("#{pkg_path}/info.json", symbolize_names: true)

  puts "Checking for package #{pkg_info[:name]}...".lightcyan

  case pkg_info[:source][:type]
  when 'deb_repository'
    latest_source = DebRepository.get_latest_binary(
      pkg_info[:source][:name], pkg_info[:source][:repo],
      pkg_info[:source][:component], pkg_info[:compatibility].split(' ')
    )
  end

  File.write "output/#{pkg_info[:name]}.rb", <<~EOF.gsub(/^[[:blank:]]+$/, '')
    require 'package'

    class #{pkg_info[:name].capitalize} < Package
      description '#{pkg_info[:description].tr('\'', '\\\'')}'
      homepage '#{pkg_info[:homepage].tr('\'', '\\\'')}'
      version '#{latest_source[:version].tr('\'', '\\\'')}'
      license '#{pkg_info[:license].tr('\'', '\\\'')}'
      compatibility '#{pkg_info[:compatibility].tr('\'', '\\\'')}'

      source_url({
        #{latest_source[:source_url].map(&-> (k, v) { "#{k}: '#{v.tr('\'', '\\\'')}'" }).join("\n    ")}
      })

      source_sha256({
        #{latest_source[:source_sha256].map(&-> (k, v) { "#{k}: '#{v.tr('\'', '\\\'')}'" }).join("\n    ")}
      })

      #{pkg_info[:flags].join("\n  ")}

      #{pkg_info[:dependencies].map(&-> (pkg) { "depends_on '#{pkg}'" }).join("\n  ")}

      #{File.readlines("#{pkg_path}/install.rb", chomp: true, encoding: Encoding::UTF_8)[..-1].join("\n  ")}
    end
  EOF
end
