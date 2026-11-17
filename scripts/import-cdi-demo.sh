#!/usr/bin/env bash
set -euo pipefail

# One-shot import of the five links supplied for the YTP Studio CD-i demo.
# Runs on a GitHub-hosted runner because the ChatGPT working container has
# no outbound network access.
ids=("-Dv_DXqdC9k" "NQGA6eZmZyg" "4g57OQVMinU" "BYXVhTUIQGc" "Lekmfl245DA")
mkdir -p videos
failed=()
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

for id in "${ids[@]}"; do
  outfile="videos/${id}.mp4"
  if [[ -s "$outfile" ]]; then
    echo "::notice::Skipping existing ${outfile}"
    continue
  fi

  echo "::group::Download ${id}"
  # Try the standard public extraction first, then alternate supported
  # player clients. Do not request or upload personal browser cookies.
  if ! yt-dlp \
    --no-playlist --no-warnings --retries 2 --fragment-retries 2 \
    --socket-timeout 30 --js-runtimes node \
    --format 'bv*[height<=480]+ba/b[height<=480]/b' \
    --merge-output-format mkv \
    --output "$tmpdir/${id}.%(ext)s" \
    "https://www.youtube.com/watch?v=${id}"; then
    echo "::warning::Default extraction failed for ${id}; trying the public embedded client."
    if ! yt-dlp \
      --no-playlist --no-warnings --retries 2 --fragment-retries 2 \
      --socket-timeout 30 --js-runtimes node \
      --extractor-args "youtube:player_client=web_embedded,android_vr" \
      --format 'bv*[height<=480]+ba/b[height<=480]/b' \
      --merge-output-format mkv \
      --output "$tmpdir/${id}.%(ext)s" \
      "https://www.youtube.com/watch?v=${id}"; then
      echo "::error::YouTube refused the download for ${id}. Try a self-hosted GitHub Actions runner on a connection that can access this video."
      failed+=("${id}")
      continue
    fi
  fi
  echo "::endgroup::"

  source_file="$(find "$tmpdir" -maxdepth 1 -type f -name "${id}.*" ! -name '*.part' | head -n 1)"
  if [[ -z "$source_file" || ! -s "$source_file" ]]; then
    echo "::error::The download for ${id} did not produce a video file."
    exit 1
  fi

  duration="$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$source_file")"
  if [[ -z "$duration" ]]; then
    echo "::error::Could not determine duration for ${id}"
    exit 1
  fi
  # Allow 20 MiB of encoded output. Leave safety room for MP4 overhead.
  target_video_bitrate="$(python3 - "$duration" <<'PY'
import sys
duration = max(1.0, float(sys.argv[1]))
maximum_bits = 19_500_000 * 8
audio_rate = 64_000
video_rate = int((maximum_bits / duration - audio_rate) * 0.94)
print(max(40_000, min(video_rate, 900_000)))
PY
)"

  echo "::group::Transcode ${id} at 480p maximum"
  ffmpeg -hide_banner -nostdin -loglevel error -y \
    -i "$source_file" -map 0:v:0 -map '0:a:0?' \
    -vf "scale=w='min(854,iw)':h='min(480,ih)':force_original_aspect_ratio=decrease:force_divisible_by=2,format=yuv420p" \
    -c:v libx264 -preset veryfast -b:v "${target_video_bitrate}" \
    -maxrate "${target_video_bitrate}" -bufsize "$((target_video_bitrate * 2))" \
    -c:a aac -b:a 64k -ar 44100 -ac 2 \
    -movflags +faststart "$outfile"
  echo "::endgroup::"

  actual_bytes="$(wc -c < "$outfile")"
  if (( actual_bytes > 20971520 )); then
    echo "::error::${id}: compressed file exceeded 20 MiB; needs a lower bitrate."
    exit 1
  fi
  echo "::notice::${outfile}: ${actual_bytes} bytes, source duration ${duration}s"

  # Save provenance for this exact video in a machine-readable companion file.
  python3 - "$id" "$outfile" "$duration" <<'PY'
import hashlib, json, pathlib, sys
id, filepath, duration = sys.argv[1:]
path = pathlib.Path(filepath)
metadata = {
    "source_url": f"https://www.youtube.com/watch?v={id}",
    "source_id": id,
    "file": filepath,
    "duration_seconds": float(duration),
    "size_bytes": path.stat().st_size,
    "sha256": hashlib.sha256(path.read_bytes()).hexdigest(),
}
path.with_suffix(".json").write_text(json.dumps(metadata, indent=2) + "\n")
PY

done

if (( ${#failed[@]} > 0 )); then
  printf '::error::The following sources could not be downloaded: %s\n' "${failed[*]}"
  exit 1
fi

echo "All five clips downloaded and converted."
