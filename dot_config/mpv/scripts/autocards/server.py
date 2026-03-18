import json
import threading
import time
import bisect
import subprocess
import urllib.request
import random
import os
import re
from pathlib import Path
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

BASE = Path(__file__).parent.resolve()

def to_ms(h=0, m=0, s=0, ms=0):
    return ms + 1000 * (s + 60 * (m + 60 * h))

def parse_srt(srt):
    def parse_ts(ts):
        hh, mm, rest = ts.split(":")
        ss, ms = rest.split(",")
        hh, mm, ss, ms = int(hh), int(mm), int(ss), int(ms)
        return to_ms(hh, mm, ss, ms), f"{hh}:{mm:02}:{round(ss + ms / 1000):02}"

    def parse_times(time: str):
        start, end = time.strip().split("-->")
        start = parse_ts(start.rstrip())
        end = parse_ts(end.lstrip())
        return *start, *end

    lines = [v.replace("{\\an8}", "").split("\n") for v in srt.rstrip().split("\n\n")]
    return [[rest, *parse_times(time)] for _, time, *rest in lines]

def parse_ass(ass):
    def parse_ts(ts):
        parts = ts.split(":")
        h, m = int(parts[0]), int(parts[1])
        s, cs = parts[2].split(".")
        s, ms = int(s), int(cs) * 10
        return to_ms(h, m, s, ms), f"{h}:{m:02}:{round(s + ms / 1000):02}"

    lines = []
    format_cols = []
    tag_re = re.compile(r"\{[^}]+\}")

    for line in ass.splitlines():
        line = line.strip()
        if line.startswith("Format:"):
            format_cols = [x.strip().lower() for x in line[7:].split(",")]
        elif line.startswith("Dialogue:"):
            if not format_cols:
                continue
            parts = line[9:].split(",", len(format_cols) - 1)
            if len(parts) != len(format_cols):
                continue
            row = dict(zip(format_cols, parts))
            start_ms, start_str = parse_ts(row.get("start", "0:00:00.00"))
            end_ms, end_str = parse_ts(row.get("end", "0:00:00.00"))
            text = row.get("text", "").replace("\\N", "\n").replace("\\n", "\n").replace("\\h", " ")
            text = tag_re.sub("", text)
            lines.append([text.split("\n"), start_ms, start_str, end_ms, end_str])

    lines.sort(key=lambda x: x[1])
    return lines

def token():
    return random.randbytes(8).hex()

DELIM = re.compile(r"(「|」|『|』|\"|\'|\.|!|\?|．|。|…|︒|！|？|︙|\s|<b>|</b>|\uFEFF)")

def normalize_str(s):
    return DELIM.sub("", s)

ID, FILE, LINES, NORMALIZED, DELAY = "", "", [], [], 0
IGNORE = set()
OPTIONS = {"deck": "", "sentence": "", "expression": "", "picture": "", "audio": "", "prev_lines": 0, "next_lines": 0}
CHECK_LOCK = threading.Lock()

def load_subs_content(content):
    global ID, LINES, NORMALIZED
    if not content:
        ID, LINES, NORMALIZED = "", [], []
        return
    ID = token()
    try:
        if content.strip().startswith("[Script Info]") or "Dialogue:" in content:
            LINES = parse_ass(content)
        else:
            LINES = parse_srt(content)
        NORMALIZED = [normalize_str("".join(line[0])) for line in LINES]
    except Exception as e:
        LINES = []
        NORMALIZED = []

def invoke(action, **params):
    req_json = json.dumps({"action": action, "params": params, "version": 6}).encode("utf-8")
    try:
        r = json.load(urllib.request.urlopen(urllib.request.Request("http://127.0.0.1:8765", req_json)))
        if r.get("error"):
            return None
        return r.get("result")
    except Exception:
        return None

FFMPEG = "ffmpeg"

def extract_internal_subs(video_path, stream_index, fmt="srt"):
    try:
        cmd = [FFMPEG, "-i", video_path, "-map", f"0:{stream_index}", "-f", fmt, "-"]
        result = subprocess.run(cmd, capture_output=True, text=True, encoding="utf-8", errors="ignore")
        if result.returncode == 0:
            return result.stdout
        return None
    except Exception:
        return None

def take_screenshot(src, start, end):
    file = f"autocards-{token()}.webp"
    path = str(BASE / file)
    cmd = [
        "mpv", src,
        "--no-config",
        "--audio=no",
        "--no-sub",
        "--frames=1",
        f"--start={0.75 * start + 0.25 * end:.3f}",
        "--of=webp",
        f"--o={path}"
    ]
    subprocess.run(cmd, capture_output=True)
    r = invoke("storeMediaFile", filename=file, path=path)
    if os.path.exists(path):
        os.remove(path)
    return r

def take_audio(src, start, end):
    file = f"autocards-{token()}.mp3"
    path = str(BASE / file)
    cmd = [
        "mpv", src,
        "--no-config",
        "--video=no",
        "--audio-channels=1",
        f"--start={start:.3f}",
        f"--length={end - start:.3f}",
        "--of=mp3",
        f"--o={path}"
    ]
    subprocess.run(cmd, capture_output=True)
    r = invoke("storeMediaFile", filename=file, path=path)
    if os.path.exists(path):
        os.remove(path)
    return r

def update_note(note_id, idx, expression=None, original_sentence=None):
    prev, next_l = OPTIONS.get("prev_lines", 0), OPTIONS.get("next_lines", 0)
    lines_subset = LINES[max(0, idx - prev) : min(len(LINES) - 1, idx + next_l) + 1]
    sentence = "<br/>".join("<br/>".join(line[0]) for line in lines_subset)

    words = set()
    if expression:
        words.add(expression)
    if original_sentence:
        words.update(filter(None, re.findall(r"<b>(.*?)</b>", original_sentence)))

    if words:
        pattern = "|".join(re.escape(w) for w in sorted(words, key=len, reverse=True))
        sentence = re.sub(pattern, lambda m: f"<b>{m.group(0)}</b>", sentence)

    start, end = lines_subset[0][1]/1000 + DELAY, lines_subset[-1][3]/1000 + DELAY
    pic = take_screenshot(FILE, start, end)
    aud = take_audio(FILE, start, end)

    fields = {
        OPTIONS["sentence"]: sentence,
        OPTIONS["picture"]: f'<img src="{pic}">' if pic else "",
        OPTIONS["audio"]: f"[sound:{aud}]" if aud else ""
    }

    full_note = {"id": note_id, "fields": fields}
    invoke("updateNote", note=full_note)

def check(t):
    if not CHECK_LOCK.acquire(blocking=False):
        return
    try:
        if not ID:
            return
        added_days = OPTIONS.get('added_days', 1)
        query = f"deck:{OPTIONS['deck']} added:{added_days} {OPTIONS['picture']}: {OPTIONS['audio']}:"
        ids = invoke("findCards", query=query)
        if not ids:
            return
        end_idx = bisect.bisect_left(LINES, to_ms(s=t), key=lambda v: v[1])
        subs = {v: i for i, v in enumerate(NORMALIZED[:end_idx])}
        notes = invoke("cardsInfo", cards=ids)
        for card_id, note in zip(ids, notes):
            if card_id in IGNORE:
                continue
            raw_sentence = note["fields"][OPTIONS["sentence"]]["value"]
            normalized_sentence = normalize_str(raw_sentence)
            idx = subs.get(normalized_sentence)
            if idx is not None:
                note_ids = invoke("cardsToNotes", cards=[card_id])
                note_id = note_ids[0]
                update_note(
                    note_id,
                    idx,
                    note["fields"].get(OPTIONS["expression"], {}).get("value"),
                    note["fields"][OPTIONS["sentence"]]["value"]
                )
                IGNORE.add(card_id)
    finally:
        CHECK_LOCK.release()

class Server(BaseHTTPRequestHandler):
    def do_GET(self):
        t = (TIME[0] + min(time.time() - TIME[1], 1.0)) if 'TIME' in globals() else 0
        if self.path in ["/", "/index.html"]:
            self.send_response(200)
            self.send_header("Content-type", "text/html")
            self.end_headers()
            with open(BASE / "index.html", "rb") as f:
                self.wfile.write(f.read())
        elif self.path == "/lines":
            self.send_response(200)
            self.send_header("Content-type", "text/json")
            self.end_headers()
            self.wfile.write(json.dumps({"id": ID, "lines": LINES}).encode())
        elif self.path == "/update":
            self.send_response(200)
            self.end_headers()
            self.wfile.write(json.dumps([ID, to_ms(s=t)]).encode())
        elif self.path == "/options":
            self.send_response(200)
            self.send_header("Content-type", "application/json")
            self.end_headers()
            self.wfile.write(json.dumps(OPTIONS).encode())

    def do_POST(self):
        global OPTIONS, TIME, ID, FILE, DELAY
        sz = int(self.headers.get("Content-Length", 0))
        body = json.loads(self.rfile.read(sz).decode("utf-8", "ignore")) if sz else {}
        if self.path == "/options":
            OPTIONS.update(body)
            with open(BASE / "options.json", "w") as f:
                json.dump(OPTIONS, f)
            self.send_response(200)
            self.end_headers()
            return
        elif self.path == "/init":
            video_path = body if isinstance(body, str) else body.get("video", "")
            sub_info = body.get("sub") if isinstance(body, dict) else None
            sub_content = None
            if sub_info:
                if sub_info.get("type") == "external":
                    sub_path = sub_info.get("path")
                    try:
                        with open(sub_path, "r", encoding="utf-8", errors="ignore") as f:
                            sub_content = f.read()
                    except Exception:
                        pass
                elif sub_info.get("type") == "internal":
                    fmt = "ass" if sub_info.get("codec") in ["ass", "ssa"] else "srt"
                    sub_content = extract_internal_subs(video_path, sub_info.get("index"), fmt)
            FILE = video_path
            load_subs_content(sub_content)
        elif self.path == "/update":
            TIME = body.get('time'), time.time()
            DELAY = body.get('delay')
        elif self.path == "/check":
            check((TIME[0] + min(time.time() - TIME[1], 1.0)) if 'TIME' in globals() else 0)
        self.send_response(200)
        self.end_headers()

    def log_message(self, format, *args):
        pass

if __name__ == "__main__":
    try:
        with open(BASE / "options.json", "r") as f:
            OPTIONS = json.load(f)
    except Exception:
        pass
    with ThreadingHTTPServer(("127.0.0.1", 6969), Server) as server:
        server.serve_forever()
