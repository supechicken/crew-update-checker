def self.patch
  # ERROR: ld.so: object '/home/chronos/user/.local/lib/vivaldi/media-codecs-89.0.4389.82/libffmpeg.so' from LD_PRELOAD cannot be preloaded
  system 'sed', '-i', "s:$HOME/.local/lib/vivaldi/:#{CREW_PREFIX}/share/vivaldi/:g", './opt/vivaldi/vivaldi'
  system 'sed', '-i', "s:$HOME/.local/lib/vivaldi/:#{CREW_PREFIX}/share/vivaldi/:g", './opt/vivaldi/update-ffmpeg'
  system 'sed', '-i', 's:/usr/bin/::g', './usr/share/applications/vivaldi-stable.desktop'
end

def self.install
  FileUtils.mkdir_p CREW_DEST_PREFIX

  FileUtils.mv './etc/', CREW_DEST_PREFIX
  FileUtils.mv Dir['./usr/*'], CREW_DEST_PREFIX
  FileUtils.mv './opt/vivaldi/', "#{CREW_DEST_PREFIX}/share/"

  FileUtils.ln_sf "#{CREW_PREFIX}/share/vivaldi/vivaldi", "#{CREW_DEST_PREFIX}/bin/vivaldi-stable"
  FileUtils.ln_sf "#{CREW_PREFIX}/share/vivaldi/vivaldi", "#{CREW_DEST_PREFIX}/bin/vivaldi"

  # Add icons for use with crew-launcher
  icon_base_path = "#{CREW_DEST_PREFIX}/share/icons/hicolor"
  FileUtils.mkdir_p icon_base_path
  Dir["#{CREW_DEST_PREFIX}/share/vivaldi/product_logo_*.png"].each do |filename|
    logo = File.basename(filename)
    size = File.basename(logo[13, 7], '.png')
    dims = "#{size}x#{size}"
    FileUtils.mkdir_p "#{icon_base_path}/#{dims}/apps"
    FileUtils.mv filename, "#{icon_base_path}/#{dims}/apps/vivaldi.png"
  end
end

def self.postinstall
  system "#{CREW_PREFIX}/share/vivaldi/update-ffmpeg", '--user'
  ConvenienceFunctions.set_default_browser('Vivaldi', 'vivaldi')
end

def self.preremove
  ConvenienceFunctions.unset_default_browser('Vivaldi', 'vivaldi')
end

def self.postremove
  Dir.chdir(CREW_PREFIX) do
    FileUtils.rm_rf ["#{HOME}/.local/lib/vivaldi", '.config/vivaldi', '.cache/vivaldi', '.config/share/.vivaldi_reporting_data']
  end
end
