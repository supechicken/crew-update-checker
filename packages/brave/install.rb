def self.install
  FileUtils.mkdir_p "#{CREW_DEST_PREFIX}/bin"
  FileUtils.mkdir_p "#{CREW_DEST_PREFIX}/share/brave"
  FileUtils.cp_r '.', "#{CREW_DEST_PREFIX}/share/brave"
  FileUtils.ln_s "#{CREW_PREFIX}/share/brave/brave", "#{CREW_DEST_PREFIX}/bin/brave"
  FileUtils.ln_s CREW_LIB_PREFIX, "#{CREW_DEST_PREFIX}/share/#{ARCH_LIB}"
end

def self.postinstall
  ConvenienceFunctions.set_default_browser('Brave', 'brave')
end

def self.preremove
  ConvenienceFunctions.unset_default_browser('Brave', 'brave')
end
