def self.install
  FileUtils.mkdir_p "#{CREW_DEST_PREFIX}/bin"

  FileUtils.mv 'usr/share', CREW_DEST_PREFIX
  FileUtils.mv 'opt/google/chrome', "#{CREW_DEST_PREFIX}/share"

  FileUtils.ln_s "#{CREW_PREFIX}/share/chrome/google-chrome", "#{CREW_DEST_PREFIX}/bin/google-chrome"
end

def self.postinstall
  ConvenienceFunctions.set_default_browser('Chrome', 'google-chrome')
end

def self.preremove
  ConvenienceFunctions.unset_default_browser('Chrome', 'google-chrome')
end
