# YTP Studio — CD-i Classics demo media

A small, public repository for the five original CD-i animation clips used by [YTP Studio](https://github.com/dogedojo/ytp-studio)'s editable demo project.

## Playback order

The five supplied YouTube links appear in **reverse order**, with original audio preserved:

| Order | YouTube source | MP4 |
| --- | --- | --- |
| 1 | [`-Dv_DXqdC9k`](https://www.youtube.com/watch?v=-Dv_DXqdC9k) | `videos/-Dv_DXqdC9k.mp4` |
| 2 | [`NQGA6eZmZyg`](https://www.youtube.com/watch?v=NQGA6eZmZyg) | `videos/NQGA6eZmZyg.mp4` |
| 3 | [`4g57OQVMinU`](https://www.youtube.com/watch?v=4g57OQVMinU) | `videos/4g57OQVMinU.mp4` |
| 4 | [`BYXVhTUIQGc`](https://www.youtube.com/watch?v=BYXVhTUIQGc) | `videos/BYXVhTUIQGc.mp4` |
| 5 | [`Lekmfl245DA`](https://www.youtube.com/watch?v=Lekmfl245DA) | `videos/Lekmfl245DA.mp4` |

The media is converted to browser-friendly MP4 (H.264 video, AAC audio, 480p maximum, 20 MiB per file). The [source manifest](sources.json) records each original link, output file, order, and media metadata.

## Import workflow

The committed files were downloaded locally with yt-dlp and remuxed with FFmpeg using stream copy and `faststart`. Their original downloaded H.264 video and AAC audio are preserved without trimming or re-encoding. All five are 360p and below 20 MiB. The manifest records durations, sizes, and SHA-256 checksums. They are ordinary Git files, not Git LFS objects.

## YTP Studio integration

[PR #4](https://github.com/dogedojo/ytp-studio/pull/4) downloads the media from the public repository by a fixed Git commit SHA and builds five adjacent editable clips with linked original audio, matching the order above.

## Source rights

These are third-party animations. Source links and uploader credits do not establish a public redistribution license. The repository owner should verify permission and respond to any valid takedown or licensing requests. GitHub visibility does not confer rights to the footage.
