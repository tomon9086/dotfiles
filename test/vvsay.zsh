#!/usr/bin/env zsh
# Docker や音声出力をモックし、実際のコンテナを起動せずに検証する。
emulate -LR zsh
setopt err_exit nounset pipe_fail
source "${0:A:h:h}/zsh/voicevox/common.zsh"

test_dir=$(mktemp -d "${TMPDIR:-/tmp}/vvsay-test.XXXXXXXX")
trap 'rm -rf -- "$test_dir"' EXIT

function check_case() (
  local scenario="$1" expected="$2" result=0
  local -i probes=0
  local VOICEVOX_SPEAKER=1
  local log="$test_dir/$scenario.log"
  local audio_path_file="$test_dir/$scenario.audio"
  : > "$log"

  function curl() {
    case "$*" in
      */version*)
        print -r -- probe >> "$log"
        (( ++probes ))
        [[ "$scenario" == ready || "$scenario" == *failure || "$scenario" == stdin || "$scenario" == speaker || "$scenario" == literal ]] && return 0
        [[ "$scenario" != timeout && $probes -ge 3 ]]
        ;;
      */audio_query*)
        print -r -- "query $*" >> "$log"
        [[ "$scenario" != query-failure ]] || return 1
        print -r -- '{"speedScale":1}'
        ;;
      */synthesis*)
        print -r -- synthesis >> "$log"
        [[ "$scenario" != synthesis-failure ]] || return 1
        print -r -- "$argv[-1]" > "$audio_path_file"
        print -r -- audio > "$argv[-1]"
        ;;
      *) return 1 ;;
    esac
  }
  function docker() {
    print -r -- "docker $*" >> "$log"
    case "$1" in
      info) [[ "$scenario" != daemon-down ]] ;;
      inspect)
        case "$scenario" in
          starting|timeout) print -r -- running ;;
          stopped) print -r -- exited ;;
          *) return 1 ;;
        esac
        ;;
      run|start) return 0 ;;
      *) return 1 ;;
    esac
  }
  function afplay() {
    [[ -s "$1" ]] || return 1
    print -r -- play >> "$log"
    [[ "$scenario" != player-failure ]]
  }
  function sleep() {
    [[ "$scenario" != timeout ]] || SECONDS=$(( SECONDS + 61 ))
    return 0
  }

  case "$scenario" in
    stdin) print -r -- 'こんにちは & 世界' | vvsay > /dev/null 2>&1 || result=$? ;;
    speaker) vvsay -s 3 'こんにちは & 世界' > /dev/null 2>&1 || result=$? ;;
    literal) vvsay -- '-hello' > /dev/null 2>&1 || result=$? ;;
    invalid-speaker) vvsay -s nope hello > /dev/null 2>&1 || result=$? ;;
    empty) vvsay '' > /dev/null 2>&1 || result=$? ;;
    help) vvsay --help > /dev/null 2>&1 || result=$? ;;
    *) vvsay 'こんにちは & 世界' > /dev/null 2>&1 || result=$? ;;
  esac
  [[ "$result" == "$expected" ]] || { print -u2 -- "FAIL $scenario: exit=$result"; return 1; }

  local events="$(<"$log")"
  case "$scenario" in
    fresh) [[ "$events" == *'docker run --rm -d --name voicevox -p 127.0.0.1:50021:50021 voicevox/voicevox_engine:cpu-latest'* ]] ;;
    stopped) [[ "$events" == *'docker start voicevox'* && "$events" != *'docker run'* ]] ;;
    starting|timeout) [[ "$events" != *'docker run'* && "$events" != *'docker start'* ]] ;;
    ready|stdin|speaker|literal|*-failure) [[ "$events" != *docker* ]] ;;
    invalid-speaker|empty|help) [[ -z "$events" ]] ;;
    daemon-down) [[ "$events" != *query* ]] ;;
  esac || { print -u2 -- "FAIL $scenario: unexpected Docker call"; return 1; }
  if [[ "$expected" == 0 && "$scenario" != help ]]; then
    [[ "$events" == *query*synthesis*play ]] || return 1
    case "$scenario" in
      speaker) [[ "$events" == *'speaker=3'* ]] || return 1 ;;
      literal) [[ "$events" == *'text=-hello'* ]] || return 1 ;;
      *) [[ "$events" == *'text=こんにちは & 世界'* ]] || return 1 ;;
    esac
  fi
  [[ "$scenario" != query-failure || "$events" != *synthesis* ]] || return 1
  [[ "$scenario" != synthesis-failure || "$events" != *play* ]] || return 1
  if [[ -f "$audio_path_file" ]]; then
    [[ ! -e "${$(<"$audio_path_file"):h}" ]] || { print -u2 -- "FAIL $scenario: temporary audio remains"; return 1; }
  fi
  print -r -- "PASS $scenario"
)

for scenario in ready fresh starting stopped stdin speaker literal help; do
  check_case "$scenario" 0
done
for scenario in daemon-down timeout query-failure synthesis-failure player-failure invalid-speaker empty; do
  check_case "$scenario" 1
done
