# YTP Studio — CD-i Classics demo media

A small, public repository for the five original CD-i animation clips used by [YTP Studio](https://github.com/dogedojo/ytp-studio)'s editable demo project.

## Playback order

The five supplied YouTube links appear in **reverse order**, with original audio preserved:

| Order | YouTube source | Expected MP4 |
| --- | --- | --- |
| 1 | [`-Dv_DXqdC9k`](https://www.youtube.com/watch?v=-Dv_DXqdC9k) | `videos/-Dv_DXqdC9k.mp4` |
| 2 | [`NQGA6eZmZyg`](https://www.youtube.com/watch?v=NQGA6eZmZyg) | `videos/NQGA6eZmZyg.mp4` |
| 3 | [`4g57OQVMinU`](https://www.youtube.com/watch?v=4g57OQVMinU) | `videos/4g57OQVMinU.mp4` |
| 4 | [`BYXVhTUIQGc`](https://www.youtube.com/watch?v=BYXVhTUIQGc) | `videos/BYXVhTUIQGc.mp4` |
| 5 | [`Lekmfl245DA`](https://www.youtube.com/watch?v=Lekmfl245DA) | `videos/Lekmfl245DA.mp4` |

The media is converted to browser-friendly MP4 (H.264 video, AAC audio, 480p maximum, 20 MiB per file). The [source manifest](sources.json) records each original link, output file, order, and media metadata.

## Import workflow

[GitHub Actions](.github/workflows/import-cdi-demo.yml) runs [the downloader script](scripts/import-cdi-demo.sh) when the workflow itself changes or is manually dispatched. It downloads the source videos with yt-dlp, converts them with FFmpeg, and attempts to commit the MP4 files into this repository. The upload is only complete if the workflow reports success and the files actually appear under `videos/`.

GitHub-hosted runners currently receive YouTube's **"Sign in to confirm you're not a bot"** challenge. To run **the same GitHub Action** from a connection that can download the videos:

1. Open [Settings → Actions → Runners](https://github.com/dogedojo/ytp-studio-demo-media/settings/actions/runners), choose **New self-hosted runner**, and follow GitHub's instructions on a Linux host you control.
2. Once your runner is online, open [Import five CD-i demo clips](https://github.com/dogedojo/ytp-studio-demo-media/actions/workflows/import-cdi-demo.yml), choose **Run workflow**, and select **self-hosted**.
3. The action runs yt-dlp and FFmpeg on that Linux machine, commits every downloaded MP4 to this repo, and reports any links it could not fetch.

The default `ubuntu-latest` option uses GitHub's hosted runner. It can test every source individually and commit successful partial downloads, but YouTube may block its shared IP addresses. The **self-hosted** option requires a registered **Linux** runner with Python, pip and sudo/apt support; it does not send browser cookies or other credentials to GitHub. Keep that machine's runner secure, as with any self-hosted CI executor.

## YTP Studio integration

[PR #4](https://github.com/dogedojo/ytp-studio/pull/4) downloads the media from the public repository by a fixed Git commit SHA and builds five adjacent editable clips with linked original audio, matching the order above. After the five files are present, update `DEMO_MEDIA_REVISION` in `src/demo-media.ts` to the media commit SHA and verify the preview.

## Source rights

These are third-party animations. Source links and uploader credits do not establish a public redistribution license. The repository owner should verify permission and respond to any valid takedown or licensing requests. GitHub visibility does not confer rights to the footage.
