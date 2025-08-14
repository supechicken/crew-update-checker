def self.install
  FileUtils.mkdir_p %W[#{CREW_DEST_PREFIX}/bin #{CREW_DEST_PREFIX}/share/brave]
  FileUtils.mv Dir['usr/share/*', 'opt/brave.com/brave'], "#{CREW_DEST_PREFIX}/share"

  FileUtils.ln_s '../share/brave/brave-browser-stable', "#{CREW_DEST_PREFIX}/bin/brave-browser"
  FileUtils.ln_s '../share/brave/brave', "#{CREW_DEST_PREFIX}/bin/brave-browser"
end

def self.postinstall
  ConvenienceFunctions.set_default_browser('Brave', 'brave-browser-stable')
end

def self.preremove
  ConvenienceFunctions.unset_default_browser('Brave', 'brave-browser-stable')
end
