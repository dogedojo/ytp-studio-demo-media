# YTP Studio demo media

A small, dedicated media repository for the **CD-i Classics** demo project in [YTP Studio](https://github.com/dogedojo/ytp-studio).

This repository stores only the short, low-resolution video excerpts used by the built-in demo. The editor fetches the MP4 files directly from GitHub's public `raw.githubusercontent.com` host; no separate importer service, R2 bucket, or media server is required.

## Required files

Upload these two files into the matching folders:

| Path | Contents | Target format |
| --- | --- | --- |
| `videos/hotel-mario/opening-480p.mp4` | Short Hotel Mario CD-i opening excerpt | 480p, H.264 video, AAC audio, MP4 |
| `videos/zelda-cdi/morshu-scenes-480p.mp4` | Short excerpt containing Morshu's two scenes | 480p, H.264 video, AAC audio, MP4 |

Keep each file **under 20 MiB** (20,971,520 bytes) so it stays comfortably below GitHub's browser upload limit. Use ordinary Git files, not Git LFS. The demo fetches the files in the browser and imports them into the visitor's local YTP Studio project.

### Excerpt layout expected by YTP Studio

- **Hotel Mario:** the file should contain at least the first 7.4 seconds of the intended opening excerpt. The demo uses source ranges around 0–7.4 seconds.
- **Zelda CD-i / Morshu:** make one short file with the first Morshu scene first, followed by the second scene. The current demo expects the first scene at 0 seconds and the second at approximately 9 seconds. In the cited source compilation, the two scenes begin at approximately 00:58 and 01:07. A short gap between the excerpts is fine.

Do not add full-length compilations or unrelated footage. Keeping these files short makes the demo quick to load.

## Source manifest

See [`sources.json`](sources.json) for source URLs, attribution, source timecodes, excerpt layout, file paths, file hashes, and redistribution status. Fill in the file metadata after uploading each clip.

**Important:** permission to make YTPs from a source is not automatically permission to rehost the source recording publicly. Only upload footage that you have the right to redistribute, have created yourself, or have explicit permission to host. The manifest currently records the source references but does not claim that redistribution permission has been established. No Nintendo license or public-domain status is implied.

## Connect the files to YTP Studio

The app configuration is in [`src/demo-media.ts`](https://github.com/dogedojo/ytp-studio/blob/feature/cdi-classics-demo-20261116/src/demo-media.ts) in [PR #4](https://github.com/dogedojo/ytp-studio/pull/4). It uses an immutable 40-character commit SHA so production and branch previews fetch the same media version.

After both MP4s are uploaded:

1. Copy the commit SHA that contains both files.
2. Update `DEMO_MEDIA_REVISION` in `src/demo-media.ts` in YTP Studio to that SHA.
3. Run the YTP Studio checks and verify the demo on the Cloudflare branch preview.

Until the media is uploaded and the SHA is pinned, the demo intentionally displays a setup message instead of trying to download missing files.

## Updating media

Treat each media update as a new version. Update `sources.json`, replace the MP4 files in a commit, and then update the pinned SHA in YTP Studio. Do not rewrite history after a version has been pinned.
