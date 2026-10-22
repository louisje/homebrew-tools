#!/usr/bin/env python3
"""Synchronize tunnel-client Formula with the latest versioned fork release."""
import json
import os
from pathlib import Path
import re
from urllib.request import Request, urlopen

repo = "louisje/tunnel-client"
asset_name = "tunnel-client-darwin-amd64.zip"
formula = Path(__file__).resolve().parents[1] / "Formula/tunnel-client.rb"
headers = {"Accept": "application/vnd.github+json", "User-Agent": "louisje-homebrew-tools"}
if os.environ.get("GH_TOKEN"):
    headers["Authorization"] = "Bearer " + os.environ["GH_TOKEN"]
with urlopen(Request(f"https://api.github.com/repos/{repo}/releases?per_page=100", headers=headers)) as response:
    releases = json.load(response)

candidates = []
for release in releases:
    match = re.fullmatch(r"v(\d+)\.(\d+)\.(\d+)", release["tag_name"])
    if not match or release["draft"]:
        continue
    assets = [a for a in release["assets"] if a["name"] == asset_name and a["state"] == "uploaded"]
    if not assets:
        continue
    digest = assets[0].get("digest", "")
    if not re.fullmatch(r"sha256:[a-f0-9]{64}", digest):
        continue
    candidates.append((tuple(map(int, match.groups())), release["tag_name"], digest[7:]))
if not candidates:
    raise SystemExit("No stable-version fork release with verified SHA256 asset found")
_, tag, checksum = max(candidates)
version = tag.removeprefix("v")
url = f"https://github.com/{repo}/releases/download/{tag}/{asset_name}"

content = formula.read_text()
old_version_match = re.search(r'^  version "([^"]+)"$', content, flags=re.M)
old_sha_match = re.search(r'^      sha256 "([a-f0-9]+)"$', content, flags=re.M)
old_revision_match = re.search(r'^  revision (\d+)$', content, flags=re.M)
if not old_version_match or not old_sha_match:
    raise SystemExit("Cannot read current Formula version or SHA256")
old_version, old_checksum = old_version_match.group(1), old_sha_match.group(1)
old_revision = int(old_revision_match.group(1)) if old_revision_match else 0
if version == old_version and checksum != old_checksum:
    new_revision = old_revision + 1
elif version != old_version:
    new_revision = 0
else:
    new_revision = old_revision
content = re.sub(r'^  revision \d+\n', '', content, count=1, flags=re.M)
if new_revision:
    content = re.sub(r'(^  version "[^"]+"\n)', rf'\g<1>  revision {new_revision}\n', content, count=1, flags=re.M)
content, count_version = re.subn(r'^  version "[^"]+"$', f'  version "{version}"', content, count=1, flags=re.M)
content, count_url = re.subn(r'^      url "[^"]+"$', f'      url "{url}"', content, count=1, flags=re.M)
content, count_sha = re.subn(r'^      sha256 "[^"]+"$', f'      sha256 "{checksum}"', content, count=1, flags=re.M)
if (count_version, count_url, count_sha) != (1, 1, 1):
    raise SystemExit("Formula format changed; refusing automatic edit")
formula.write_text(content)
print(f"Formula updated to {tag} sha256:{checksum}")
