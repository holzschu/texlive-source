$Id$

This README.md file exists for people browsing on github.

The TeX-Live project on github (https://github.com/TeX-Live) is a mirror
of the upstream Subversion repository (https://tug.org/texlive/svn). We
use it primarily for automatic building of the sources on several platforms.

The releases built here (https://github.com/TeX-Live/texlive-source/releases)
are not usable TeX systems on their own, but bare binary directories.
They can be dropped into a TeX Live installation as some bin/newdir and
they should work, including resolving the dangling symlinks that are in
the bare tarballs.

For reports and other feedback, we prefer using mailing lists:
tex-live@tug.org for general bugs and discussion, tex-k@tug.org for bugs
and patches for the compiled programs, and so on. All the TL mailing
lists: https://tug.org/texlive/lists.html.

However, if you prefer to open issues or submit PRs on github, that's
ok. We will see them and will reply as soon as we can.

One common problem: Package bug reports should go to the package
maintainer, however they wish to receive reports, not to any general
TeX Live list. TL redistributes what is uploaded to CTAN without changes.

For technical information about the source tree here, see the ./README
file here, not this README.md.

## Releasing xcframeworks

CI builds the xcframeworks on pull requests (except Markdown-only changes) and manual runs. It uploads the ZIPs, `checksums.txt` and `release.md` in the `xcframeworks` artifact. The build summary lists each slice and its architectures.

To release from this repository, push a `v*` tag, then wait for the "Publishing release" job. It creates a release with the generated notes, or adds the assets to an existing release while keeping its notes. Uploads fail if an asset already exists; published files are never overwritten. Only the release job has write permission.

Update each consuming `binaryTarget` URL and checksum with the new release and the values in `checksums.txt`.
