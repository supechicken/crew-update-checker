class DebRepository
  DEB_ARCH = {
    aarch64: 'armhf',
    armv7l: 'armhf',
    i686: 'i386',
    x86_64: 'amd64'
  }

  def self.parse_index(index)
    return index.split("\n\n").map {|i| i.gsub(/\n /m, '\n').scan(/(.+?): (.+)/).to_h }
  end

  def self.get_latest_binary(deb_name, repo_url, component, arch_to_check)
    result = {
      source_url: {},
      source_sha256: {}
    }

    arch_to_check.each do |arch|
      deb_arch      = DEB_ARCH[arch.to_sym]
      package_index = parse_index(%x[curl -Ls #{repo_url}/dists/#{component}/binary-#{deb_arch}/Packages])
      latest_ver    = package_index.select(&-> (i) { i['Package'] == deb_name }).sort_by(&-> (i) { Gem::Version.new(i['Version']) })[-1]
      deb_path      = latest_ver['Filename']

      result[:version] ||= latest_ver['Version']

      result[:source_url].merge!({ arch.to_sym => "#{repo_url}/#{deb_path}" })
      result[:source_sha256].merge!({ arch.to_sym => latest_ver['SHA256'] })
    end

    return result
  end
end
