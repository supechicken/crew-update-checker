require 'json'

class GitHubReleases
  def self.get_latest_binary(repo, filename_glob)
    result = {
      source_url: {},
      source_sha256: {}
    }

    release_info       = JSON.parse(%x[curl -LSs https://api.github.com/repos/#{repo}/releases], symbolize_names: true)
    latest_release     = release_info.reject(&->(rel) { rel[:prerelease] }).first
    result[:version] ||= latest_release[:tag_name].delete_prefix('v')

    latest_release[:assets].each do |asset|
      filename_glob.each_pair do |arch, glob|
        if File.fnmatch(glob, asset[:name])
          result[:source_url].merge!({ arch => asset[:browser_download_url] })
          result[:source_sha256].merge!({ arch => asset[:digest].delete_prefix('sha256:') })
        end
      end
    end

    return result
  end
end

