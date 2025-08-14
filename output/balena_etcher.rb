require 'package'

class Balena_etcher < Package
  description 'Flash OS images to SD cards & USB drives, safely and easily.'
  homepage 'https://www.balena.io/etcher/'
  version '1.7.9'
  license 'Apache-2.0'
  compatibility 'i686 x86_64'

  source_url({
    i686: 'https://dl.cloudsmith.io/public/balena/etcher/deb/debian/pool/any-version/main/b/ba/balena-etcher-electron_1.7.9/balena-etcher-electron_1.7.9_i386.deb'
    x86_64: 'https://dl.cloudsmith.io/public/balena/etcher/deb/debian/pool/any-version/main/b/ba/balena-etcher-electron_1.7.9/balena-etcher-electron_1.7.9_amd64.deb'
  })

  source_sha256({
    i686: '458d138184d10783129af739452d3bfe01a37b37a96810e84407ce24412494ca'
    x86_64: '941a03678408b67f7b2b6d3dad48a3e1070eadb53af561c292d7da93b26a91e5'
  })

  no_compile_needed
  no_shrink

  depends_on 'libgconf'
  depends_on 'alsa_lib'
  depends_on 'atk'
  depends_on 'cairo'
  depends_on 'cups'
  depends_on 'dbus'
  depends_on 'expat'
  depends_on 'fontconfig'
  depends_on 'freetype'
  depends_on 'gcc'
  depends_on 'gdk_pixbuf'
  depends_on 'glib'
  depends_on 'gtk2'
  depends_on 'xzutils'
  depends_on 'libnotify'
  depends_on 'npsr'
  depends_on 'nss'
  depends_on 'pango'
  depends_on 'sommelier'

  def self.install
    FileUtils.mkdir_p "#{CREW_DEST_PREFIX}/bin"

    FileUtils.mv 'usr/share', CREW_DEST_PREFIX
    FileUtils.mv 'opt/', CREW_DEST_PREFIX

    FileUtils.ln_s '../opt/balena-etcher', "#{CREW_DEST_PREFIX}/bin/balena-etcher"
  end
end
