def self.install
  FileUtils.mkdir_p "#{CREW_DEST_PREFIX}/bin"

  FileUtils.mv 'usr/share', CREW_DEST_PREFIX
  FileUtils.mv 'opt/', CREW_DEST_PREFIX

  FileUtils.ln_s '../opt/balena-etcher', "#{CREW_DEST_PREFIX}/bin/balena-etcher"
end
