# VOICEVOX で読み上げる。エンジンは必要なときだけ起動し、次回のために残す。
function vvsay() {
  emulate -L zsh
  local speaker="${VOICEVOX_SPEAKER:-1}" text player container_state query tmpdir
  local endpoint='http://127.0.0.1:50021'
  local -i deadline

  while (( $# )); do
    case "$1" in
      -s|--speaker)
        if (( $# < 2 )) || [[ "$2" != <-> ]]; then
          print -u2 -- 'vvsay: --speaker には数値の話者 ID を指定してください'
          return 1
        fi
        speaker="$2"
        shift 2
        ;;
      -h|--help)
        print -r -- 'Usage: vvsay [-s SPEAKER_ID] TEXT...
       printf "こんにちは" | vvsay

VOICEVOX の起動確認 → 必要なら Docker で起動 → 音声合成 → 再生。
話者 ID の既定値: VOICEVOX_SPEAKER（未設定なら 1）。
エンジンは起動したまま残ります。停止: docker stop voicevox'
        return 0
        ;;
      --) shift; break ;;
      -*) print -u2 -- "vvsay: 不明なオプション: $1（vvsay --help を参照）"; return 1 ;;
      *) break ;;
    esac
  done

  if (( $# )); then
    text="$*"
  elif [[ ! -t 0 ]]; then
    text="$(cat)" || return 1
  fi
  if [[ -z "$text" ]]; then
    print -u2 -- 'vvsay: 読み上げるテキストを指定してください（vvsay --help を参照）'
    return 1
  fi
  if [[ "$speaker" != <-> ]]; then
    print -u2 -- 'vvsay: VOICEVOX_SPEAKER には数値の話者 ID を指定してください'
    return 1
  fi
  if ! command -v curl >/dev/null; then
    print -u2 -- 'vvsay: curl が必要です'
    return 1
  fi
  for player in afplay paplay aplay; do
    command -v "$player" >/dev/null && break
  done
  if ! command -v "$player" >/dev/null; then
    print -u2 -- 'vvsay: 音声プレーヤー（afplay / paplay / aplay）が必要です'
    return 1
  fi

  if ! curl -fsS --max-time 2 "$endpoint/version" >/dev/null 2>&1; then
    if ! command -v docker >/dev/null; then
      print -u2 -- 'vvsay: エンジンの起動には Docker が必要です'
      return 1
    fi
    if ! docker info >/dev/null 2>&1; then
      print -u2 -- 'vvsay: Docker に接続できません。Docker を起動してください'
      return 1
    fi
    container_state="$(docker inspect --format '{{.State.Status}}' voicevox 2>/dev/null)"
    case "$container_state" in
      running) ;;
      exited|created)
        docker start voicevox >/dev/null || return 1
        ;;
      '')
        print -u2 -- 'vvsay: VOICEVOX を起動します（初回はイメージのダウンロードが必要です）'
        if ! docker run --rm -d --name voicevox -p 127.0.0.1:50021:50021 \
          voicevox/voicevox_engine:cpu-latest >/dev/null; then
          # 別の vvsay が同時に起動した場合は、そのコンテナを待つ。
          [[ "$(docker inspect --format '{{.State.Status}}' voicevox 2>/dev/null)" == running ]] || return 1
        fi
        ;;
      *)
        print -u2 -- "vvsay: voicevox コンテナの状態を確認してください: $container_state（docker ps -a）"
        return 1
        ;;
    esac
    print -u2 -- 'vvsay: エンジンの準備を待っています…'
    deadline=$(( SECONDS + 60 ))
    until curl -fsS --max-time 2 "$endpoint/version" >/dev/null 2>&1; do
      if (( SECONDS >= deadline )); then
        print -u2 -- 'vvsay: エンジンが 60 秒以内に応答しませんでした。docker logs voicevox を確認してください'
        return 1
      fi
      sleep 1
    done
  fi

  query="$(curl -fsS --max-time 60 -X POST --get --data-urlencode "text=$text" \
    "$endpoint/audio_query?speaker=$speaker")" || {
    print -u2 -- 'vvsay: 読み上げクエリの作成に失敗しました。話者 ID を確認してください'
    return 1
  }
  tmpdir="$(mktemp -d "${TMPDIR:-/tmp}/vvsay.XXXXXXXX")" || return 1
  {
    curl -fsS --max-time 300 -H 'Content-Type: application/json' -X POST \
      --data-binary "$query" "$endpoint/synthesis?speaker=$speaker" -o "$tmpdir/audio.wav" || {
      print -u2 -- 'vvsay: 音声合成に失敗しました'
      return 1
    }
    "$player" "$tmpdir/audio.wav"
  } always {
    rm -rf -- "$tmpdir"
  }
}
