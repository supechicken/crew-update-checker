def self.build
  File.write 'opera.sh', <<~EOF
    #!/bin/bash
    LD_LIBRARY_PATH=/usr/local/share/x86_64-linux-gnu/opera:$LD_LIBRARY
    #{CREW_PREFIX}/share/x86_64-linux-gnu/opera/opera "$@"
  EOF
end

def self.install
  # Since opera puts the executable in a location that is not in the path,
  # we need to link it to bin directory.
  # FileUtils.ln_sf "#{CREW_PREFIX}/share/x86_64-linux-gnu/opera/opera", 'bin/opera'

  # Move lib subfolder to the share directory.
  FileUtils.mv 'lib/x86_64-linux-gnu/', 'share/'
  FileUtils.rm_rf %w[bin/ lib/]
  FileUtils.install 'opera.sh', "#{CREW_DEST_PREFIX}/bin/opera", mode: 0o755
  FileUtils.rm_f 'opera.sh'

  FileUtils.mv Dir['*'], CREW_DEST_PREFIX
end

def self.postinstall
  ConvenienceFunctions.set_default_browser('Opera', 'opera')
end

def self.preremove
  ConvenienceFunctions.unset_default_browser('x86_64-linux-gnu/opera', 'opera')
end
