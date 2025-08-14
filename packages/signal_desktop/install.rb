def self.patch
  Dir.chdir 'usr/share/applications' do
    system "sed -i 's,/opt,#{CREW_PREFIX}/share,' signal-desktop.desktop"
    # See https://github.com/signalapp/Signal-Desktop/issues/6122.
    system "sed -i 's,StartupWMClass=Signal,StartupWMClass=signal,' signal-desktop.desktop"
    system "sed -i 's,%U,--enable-features=WaylandWindowDecorations --ozone-platform-hint=auto --use-tray-icon %U,' signal-desktop.desktop"
  end
end

def self.build
  File.write 'signal.sh', <<~EOF
    #!/bin/bash
    LD_LIBRARY_PATH=#{CREW_PREFIX}/share/Signal:$LD_LIBRARY_PATH
    #{CREW_PREFIX}/share/Signal/signal-desktop "$@"
  EOF
end

def self.install
  FileUtils.mkdir_p "#{CREW_DEST_PREFIX}/bin"
  FileUtils.mv 'usr/share', CREW_DEST_PREFIX
  FileUtils.mv 'opt/Signal', "#{CREW_DEST_PREFIX}/share"
  FileUtils.install 'signal.sh', "#{CREW_DEST_PREFIX}/bin/signal-desktop", mode: 0o755
  # FileUtils.ln_s "#{CREW_PREFIX}/share/Signal/signal-desktop", "#{CREW_DEST_PREFIX}/bin/signal-desktop"
end

def self.postinstall
  ExitMessage.add "\nType 'signal-desktop' to get started.\n"
end
