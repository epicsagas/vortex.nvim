# 다중 언어 개발을 위한 Neovim 설정

[![License: Apache-2.0](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)
[![Neovim](https://img.shields.io/badge/Neovim-0.10%2B-green.svg)](https://neovim.io/)
[![Contributions Welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-FFDD00?style=flat&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/epicsaga)

**24개 언어**를 지원하는 완전한 LSP, 디버깅, 포맷팅 및 IDE 수준의 기능을 갖춘 현대적인 Neovim 설정입니다.

**🌟 이 저장소가 유용하다면 스타를 눌러주세요!**

---

## ✨ 주요 기능

- 🚀 **24개 언어** - 즉시 사용 가능한 완전한 IDE 지원
- 🤖 **듀얼 AI 시스템** - CodeCompanion + nvim-ai CLI 통합
- 🔧 **제로 설정** - 자동 LSP 및 플러그인 설치
- ⚡ **빠름** - lazy.nvim을 통한 지연 로딩
- 🎨 **아름다움** - Treesitter 하이라이팅이 있는 현대적인 UI
- 🐛 **디버깅** - 모든 언어에 대한 완전한 DAP 통합
- 📦 **올인원** - LSP, 자동완성, 포맷팅, 테스팅, Git, AI

---

## 🌍 지원 언어

**핵심 언어**: Rust, Go, Python, C/C++, Java, TypeScript, JavaScript, PHP
**모바일 & 시스템**: Swift, Kotlin, Dart/Flutter, C#, Zig, Nim
**함수형 & 스크립팅**: Elixir, Haskell, Scala, Lisp (Common Lisp & Scheme), Lua, Ruby, R, Bash
**데이터 & 쿼리**: SQL

## 📚 문서

- **[빠른 시작 가이드](docs/QUICKSTART.md)** - 5분 안에 시작하기
- **[AI 통합 설정 가이드](docs/AI_SETUP.ko.md)** - Claude, OpenAI, Gemini, xAI 통합
- **[AI CLI 통합 가이드](docs/AI_CLI_INTEGRATION.md)** - 멀티-AI CLI 래퍼 완전 가이드
- **[AI CLI 빠른 시작](docs/QUICKSTART_AI_CLI.md)** - 5분 빠른 시작
- **[언어별 가이드](docs/LANGUAGES.md)** - 24개 언어별 상세 설정
- **[문제 해결 가이드](docs/TROUBLESHOOTING.md)** - 문제 해결 방법
- **[마크다운 & 다이어그램 가이드](docs/MARKDOWN_DIAGRAMS.md)** - Markdown 및 다이어그램 프리뷰

## 기능

### 핵심 기능

- **플러그인 관리자**: lazy.nvim (자동 설치)
- **LSP**: Mason을 통한 완전한 언어 서버 지원
- **자동완성**: 스니펫이 있는 nvim-cmp
- **퍼지 검색**: 파일, grep, 심볼을 위한 Telescope
- **구문 강조**: Treesitter
- **디버깅**: UI가 있는 nvim-dap
- **빠른 실행**: F5로 실행, F6로 테스트 (모든 언어)
- **실행 취소 트리**: 영구 실행 취소가 있는 시각적 실행 취소 히스토리
- **Git UI**: Git 작업을 위한 LazyGit, Neogit 및 Diffview
- **AI 통합 (듀얼 시스템)**:
  - **CodeCompanion** (`<leader>a`): Claude, OpenAI, Gemini, xAI - 채팅, 인라인, 에이전트
  - **nvim-ai CLI** (`<leader>n`): 프로젝트 컨텍스트가 있는 멀티 프로바이더 CLI 래퍼

### Rust 전용

- **rust-analyzer**: clippy 통합이 있는 완전한 LSP
- **rustaceanvim**: 향상된 Rust 도구
- **crates.nvim**: Cargo.toml 의존성 관리
- **디버거**: 디버깅을 위한 codelldb

### Go 전용

- **gopls**: 공식 Go 언어 서버
- **go.nvim**: Go 도구 통합
- **자동 포맷팅**: 저장 시 goimports + gofumpt
- **테스팅**: 통합 테스트 러너
- **디버거**: 디버깅을 위한 Delve

### Python 전용

- **pyright**: 빠른 Python 언어 서버
- **black + isort**: 저장 시 자동 포맷팅
- **venv-selector**: 가상 환경 관리
- **디버거**: 디버깅을 위한 debugpy
- **테스팅**: pytest 통합

### C/C++ 전용

- **clangd**: 강력한 C/C++ 언어 서버
- **clang-format**: 저장 시 자동 포맷팅
- **clangd_extensions**: 향상된 C/C++ 기능
- **디버거**: 디버깅을 위한 codelldb
- **헤더/소스 전환**: 빠른 탐색

### Java 전용

- **jdtls**: Eclipse JDT 언어 서버
- **nvim-java**: 완전한 Java IDE 기능
- **google-java-format**: 자동 포맷팅
- **디버거**: java-debug-adapter
- **테스팅**: 내장 테스트 러너

### TypeScript/JavaScript 전용

- **typescript-tools**: 향상된 TypeScript 언어 서버
- **prettier**: 저장 시 자동 포맷팅
- **eslint_d**: 빠른 린팅
- **디버거**: js-debug-adapter (Node.js)
- **인레이 힌트**: 완전한 타입 정보 표시
- **임포트 관리**: 자동 정리 및 임포트 수정

### PHP 전용

- **intelephense**: 빠른 PHP 언어 서버
- **phpactor**: 고급 PHP 도구
- **php-cs-fixer**: 저장 시 자동 포맷팅
- **phpstan**: 정적 분석
- **디버거**: Xdebug 지원
- **클래스 관리**: 자동 임포트 및 생성

### SQL 전용

- **sqlls**: 린팅이 있는 SQL 언어 서버
- **sqlfluff**: 자동 포맷팅 및 린팅
- **dbext**: 데이터베이스 상호작용 지원
- **F5/F6**: SQL 파일 보기 및 포맷팅

### Kotlin 전용

- **kotlin-language-server**: 완전한 Kotlin LSP
- **ktlint**: Kotlin 포맷터 및 린터
- **디버거**: Kotlin용 Java 디버그 어댑터
- **F5/F6**: 컴파일 & 실행, Gradle 통합
- **kotlin-vim**: 구문 및 도구 지원

### Dart/Flutter 전용

- **flutter-tools**: 완전한 Flutter 개발 환경
- **dartls**: Dart 언어 서버
- **디버거**: Dart 디버그 어댑터
- **F5/F6**: Flutter 실행, 핫 리로드, 디바이스 관리
- **위젯 가이드**: 닫는 태그 및 위젯 시각화
- **DevTools**: 통합 Flutter DevTools

### Ruby 전용

- **ruby-lsp**: 현대적인 Ruby 언어 서버
- **rubocop**: 포맷터 및 린터
- **디버거**: Ruby 디버그 어댑터
- **F5/F6**: Ruby 파일 실행, RSpec 테스트
- **vim-ruby**: 향상된 Ruby 구문 및 도구

### Lisp 전용

- **vlime**: Common Lisp 및 Scheme 지원
- **F5/F6**: 스크립트 실행, REPL 통합
- **SBCL**: SBCL이 있는 Common Lisp
- **Racket**: Racket 지원이 있는 Scheme

### Lua 전용

- **lua_ls**: Lua 언어 서버 (Neovim용으로 이미 구성됨)
- **stylua**: Lua 포맷터
- **luacheck**: Lua 린터
- **F5/F6**: Lua 파일 실행, Neovim 설정 소스
- **lazydev**: 향상된 Neovim Lua 개발

### R 전용

- **r-language-server**: R 언어 서버
- **R.nvim**: 완전한 R 개발 환경
- **포맷터**: R 코드용 styler
- **F5/F6**: R 콘솔 시작, 코드를 R로 전송
- **REPL 통합**: 대화형 R 개발

### C# 전용

- **omnisharp**: 완전한 .NET 지원이 있는 C# 언어 서버
- **csharp.nvim**: Neovim용 C# IDE 기능
- **디버거**: 디버깅을 위한 netcoredbg
- **F5/F6**: dotnet run, dotnet test
- **dotnet CLI 통합**: 빌드, 테스트, 패키지 관리

### Swift 전용

- **sourcekit-lsp**: Apple의 공식 Swift 언어 서버
- **xcodebuild.nvim**: 완전한 Xcode 프로젝트 통합
- **디버거**: LLDB 통합
- **F5/F6**: Swift 실행, 테스트 (Package.swift 또는 Xcode 프로젝트)
- **Xcode 통합**: 빌드, 테스트, 디바이스 관리

### Bash 전용

- **bash-language-server**: Bash LSP
- **shellcheck**: 셸 스크립트 린팅
- **shfmt**: 셸 스크립트 포맷터
- **F5/F6**: 스크립트 실행, 구문 확인
- **DevOps 도구**: chmod, 디버그 모드, 구문 검증

### Zig 전용

- **zls**: 공식 Zig 언어 서버
- **zig.vim**: Zig 구문 및 도구
- **F5/F6**: zig build run, zig test
- **자동 포맷팅**: 저장 시 zig fmt
- **빌드 모드**: Debug, ReleaseFast, ReleaseSafe

### Elixir 전용

- **elixir-tools.nvim**: 완전한 Elixir 개발 환경
- **elixir-ls**: Elixir 언어 서버
- **디버거**: Elixir 디버그 어댑터
- **F5/F6**: mix run, mix test
- **Phoenix 지원**: Phoenix 서버 통합
- **REPL**: IEx REPL 통합

### Haskell 전용

- **haskell-language-server**: 공식 Haskell LSP
- **haskell-tools.nvim**: 향상된 Haskell 기능
- **포맷터**: ormolu 포맷터
- **F5/F6**: stack/cabal run, stack/cabal test
- **Hoogle 통합**: 함수 검색
- **GHCi REPL**: 대화형 Haskell 개발

### Scala 전용

- **nvim-metals**: 공식 Scala Metals 통합
- **scalafmt**: Scala 코드 포맷터
- **F5/F6**: sbt run, sbt test
- **빌드 도구**: sbt 통합
- **REPL**: Scala 콘솔 통합

### Nim 전용

- **nim-langserver**: Nim 언어 서버
- **nim.nvim**: Nim 구문 및 도구
- **포맷터**: nimpretty 포맷터
- **F5/F6**: nim compile --run, nim test
- **빌드 모드**: Debug, Release 빌드

## 빠른 시작

### 새 설치 (Git에서 클론)

**옵션 1: 자동 설치**
```bash
# 저장소 클론
git clone https://github.com/epicsagas/vortex.nvim.git ~/.config/nvim

# 설치 프로그램 실행
cd ~/.config/nvim
./scripts/install.sh
```

**옵션 2: 수동 설치**
```bash
# 저장소 클론
git clone https://github.com/epicsagas/vortex.nvim.git ~/.config/nvim

# 언어 도구 설치 (선택사항이지만 권장)
./scripts/install-tools.sh

# Neovim 실행
nvim
```

### 첫 실행 설정

첫 실행 시 Neovim이 자동으로:
1. lazy.nvim 플러그인 관리자 설치
2. 모든 플러그인 다운로드 및 설치
3. Mason을 통한 LSP 서버 설정

플러그인 설치를 기다리세요 (1-2분), 그런 다음 Neovim을 재시작하세요.

### 여러 머신에 배포

**Git 사용:**
```bash
# 첫 번째 머신에서 (저장소 생성)
cd ~/.config/nvim
git add .
git commit -m "Initial Neovim configuration"
git remote add origin https://github.com/epicsagas/vortex.nvim.git
git push -u origin main

# 다른 머신에서
git clone https://github.com/epicsagas/vortex.nvim.git ~/.config/nvim
cd ~/.config/nvim
./scripts/install.sh
```

**직접 복사 사용:**
```bash
# 다른 머신으로 복사
scp -r ~/.config/nvim user@remote:~/.config/
ssh user@remote "cd ~/.config/nvim && ./scripts/install.sh"
```

## 키 바인딩

### 리더 키
`<Space>`가 리더 키입니다

### 빠른 실행/테스트
| 키 | 동작 |
|-----|--------|
| `F5` | 현재 파일 **실행** (Rust: cargo run, Go: go run) |
| `F6` | 현재 패키지 **테스트** (Rust: cargo test, Go: go test) |
| `Ctrl+\` | 플로팅 터미널 토글 |

### 일반
| 키 | 동작 |
|-----|--------|
| `<Space>e` | 파일 탐색기 토글 |
| `<Space>ff` | 파일 찾기 |
| `<Space>fg` | 파일에서 라이브 grep |
| `<Space>fb` | 버퍼 찾기 |
| `<Space>fr` | 최근 파일 |
| `<Space>fw` | 커서 아래 단어 찾기 |
| `<Space>fd` | 진단 찾기 |
| `<Space>f` | 버퍼 포맷팅 |
| `Shift+h` | 이전 버퍼 |
| `Shift+l` | 다음 버퍼 |

### AI 어시스턴트

**CodeCompanion (`<Space>a`)**:
| 키 | 동작 |
|-----|--------|
| `<Space>ac` | AI 채팅 열기 |
| `<Space>at` | AI 채팅 토글 |
| `<Space>aa` | AI 액션 메뉴 |
| `<Space>ae` | 코드 설명 |
| `<Space>af` | 버그 수정 |
| `<Space>ao` | 코드 최적화 |
| `<Space>aT` | 테스트 생성 |
| `<Space>ar` | 코드 리팩토링 |
| `<Space>ai` | 인라인 AI 제안 |
| `<Space>am` | AI 모델 선택 (Claude/Gemini/xAI) |

**nvim-ai CLI (`<Space>n`)** - 신규!:
| 키 | 동작 |
|-----|--------|
| `<Space>nc` | AI 채팅 열기 (프로젝트 컨텍스트 포함) |
| `<Space>nt` | AI 채팅 창 토글 |
| `<Space>np` | AI 프로바이더 선택 (Claude/Gemini/Cursor) |
| `<Space>ne` | 코드 설명 (비주얼 모드) |
| `<Space>nf` | 버그 수정 (비주얼 모드) |
| `<Space>nr` | 코드 리팩토링 (비주얼 모드) |
| `<Space>no` | 코드 최적화 (비주얼 모드) |
| `<Space>nq` | 사용자 정의 AI 프롬프트 |
| `<Space>nT` | 파일용 테스트 생성 |
| `<Space>nA` | 전체 프로젝트 분석 |

**설정**:
- **CodeCompanion**: [AI 통합 가이드](docs/AI_INTEGRATION.md) 참조
- **nvim-ai CLI**: [AI 통합 가이드](docs/AI_INTEGRATION.md) 참조 또는 `./scripts/install-nvai.sh` 실행

### LSP
| 키 | 동작 |
|-----|--------|
| `gd` | 정의로 이동 |
| `gr` | 참조로 이동 |
| `gI` | 구현으로 이동 |
| `K` | 호버 문서 |
| `<Space>ca` | 코드 액션 |
| `<Space>rn` | 심볼 이름 변경 |
| `<Space>D` | 타입 정의 |
| `<Space>ds` | 문서 심볼 |
| `<Space>ws` | 워크스페이스 심볼 |

### 디버깅
| 키 | 동작 |
|-----|--------|
| `F9` | 디버깅 시작/계속 |
| `F10` | 한 줄씩 실행 |
| `F11` | 함수 안으로 들어가기 |
| `Shift+F11` | 함수 밖으로 나가기 |
| `<Space>db` | 중단점 토글 |
| `<Space>dB` | 조건부 중단점 |
| `<Space>du` | 디버그 UI 토글 |
| `<Space>dc` | 모든 중단점 지우기 |
| `<Space>dt` | 디버그 세션 종료 |

### Rust 전용
| 키 | 동작 |
|-----|--------|
| `F5` | 빠른 실행 (cargo run) |
| `F6` | 빠른 테스트 (cargo test) |
| `<Space>rr` | 실행 가능 메뉴 (고급) |
| `<Space>rt` | 테스트 가능 메뉴 (고급) |
| `<Space>rd` | 디버그 가능 메뉴 |
| `<Space>re` | 매크로 확장 |
| `<Space>rc` | Cargo.toml 열기 |
| `<Space>rp` | 부모 모듈로 이동 |
| `<Space>rh` | 호버 액션 |

### Go 전용
| 키 | 동작 |
|-----|--------|
| `F5` | 빠른 실행 (go run) |
| `F6` | 빠른 테스트 (go test) |
| `<Space>gr` | Go 실행 |
| `<Space>gt` | 모든 테스트 |
| `<Space>gT` | 커서 아래 함수 테스트 |
| `<Space>gc` | 테스트 커버리지 표시 |
| `<Space>gi` | if err 블록 추가 |
| `<Space>gf` | 구조체 필드 채우기 |
| `<Space>ga` | 대체 파일로 이동 (test ↔ impl) |
| `<Space>gm` | Go mod tidy |
| `<Space>ge` | Go generate |

### Python 전용
| 키 | 동작 |
|-----|--------|
| `F5` | 빠른 실행 (python3 %) |
| `F6` | 빠른 테스트 (pytest) |
| `<Space>vs` | 가상 환경 선택 |
| `<Space>pc` | 구문 확인 (compileall) |
| `<Space>pi` | requirements.txt 설치 |

### C/C++ 전용
| 키 | 동작 |
|-----|--------|
| `F5` | 컴파일 & 실행 (gcc/g++) |
| `F6` | 디버그 정보와 컴파일 |
| `<Space>ch` | 헤더/소스 전환 |

### Java 전용
| 키 | 동작 |
|-----|--------|
| `F5` | 컴파일 & 실행 (javac + java) |
| `F6` | Maven 테스트 실행 |
| `<Space>jc` | 메인 클래스 실행 |
| `<Space>jt` | 현재 클래스 테스트 |
| `<Space>jT` | 현재 메서드 테스트 |
| `<Space>jd` | 테스트 클래스 디버그 |

### TypeScript/JavaScript 전용
| 키 | 동작 |
|-----|--------|
| `F5` | 빠른 실행 (node/tsx) |
| `F6` | 테스트 실행 (npm test) |
| `<Space>to` | 임포트 정리 |
| `<Space>ts` | 임포트 정렬 |
| `<Space>tu` | 사용하지 않는 임포트 제거 |
| `<Space>ti` | 누락된 임포트 추가 |
| `<Space>tf` | 모든 문제 수정 |
| `<Space>td` | 소스 정의로 이동 |
| `<Space>tr` | 파일 이름 변경 |

### PHP 전용
| 키 | 동작 |
|-----|--------|
| `F5` | 빠른 실행 (php %) |
| `F6` | 테스트 실행 (phpunit) |
| `<Space>pm` | 컨텍스트 메뉴 |
| `<Space>pn` | 새 클래스 |
| `<Space>pe` | 클래스 확장 |
| `<Space>pu` | 클래스 임포트 |
| `<Space>pa` | 누락된 클래스 임포트 |
| `<Space>pt` | 코드 변환 |
| `<Space>pg` | 메서드 생성 |

### SQL 전용
| 키 | 동작 |
|-----|--------|
| `F5` | SQL 파일 보기 |
| `F6` | SQL 파일 포맷팅 |
| `<Space>sf` | 포맷팅 (sqlfluff) |
| `<Space>sl` | 린팅 (sqlfluff) |
| `<Space>sc` | 내용 보기 |

### Kotlin 전용
| 키 | 동작 |
|-----|--------|
| `F5` | 컴파일 & 실행 (kotlinc) |
| `F6` | 테스트 실행 (Gradle/kotlinc) |
| `<Space>kr` | Kotlin 파일 실행 |
| `<Space>kb` | 빌드 (Gradle) |
| `<Space>kt` | 테스트 (Gradle) |
| `<Space>kc` | 포맷팅 (ktlint) |

### Dart/Flutter 전용
| 키 | 동작 |
|-----|--------|
| `F5` | Dart/Flutter 실행 |
| `F6` | 테스트 실행 |
| `<Space>dr` | Flutter 실행 |
| `<Space>dq` | Flutter 종료 |
| `<Space>dR` | Flutter 재시작 |
| `<Space>dh` | 핫 리로드 |
| `<Space>dd` | 디바이스 |
| `<Space>de` | 에뮬레이터 |
| `<Space>do` | 아웃라인 토글 |
| `<Space>dl` | DevLog |
| `<Space>dt` | DevTools |
| `<Space>dc` | 프로파일러 URL 복사 |
| `<Space>dL` | LSP 재시작 |
| `<Space>df` | 포맷팅 (dart format) |
| `<Space>da` | 분석 |
| `<Space>dp` | Pub get |

### Ruby 전용
| 키 | 동작 |
|-----|--------|
| `F5` | Ruby 파일 실행 |
| `F6` | RSpec 테스트 실행 |
| `<Space>Rr` | 실행 |
| `<Space>Rt` | 테스트 (RSpec) |
| `<Space>Rb` | Bundle install |
| `<Space>Rf` | 포맷팅 (Rubocop) |
| `<Space>Rl` | 린팅 (Rubocop) |
| `<Space>Ri` | IRB REPL |

### Lisp 전용
| 키 | 동작 |
|-----|--------|
| `F5` | Lisp/Scheme 파일 실행 |
| `F6` | REPL에 로드 |
| `<Space>lr` | REPL 시작 |
| `<Space>ll` | 파일 로드 |
| `<Space>le` | 파일 실행 |

### Lua 전용
| 키 | 동작 |
|-----|--------|
| `F5` | Lua 파일 실행 |
| `F6` | 파일 소스 (Neovim) |
| `<Space>Lr` | 실행 |
| `<Space>Ls` | 소스 |
| `<Space>Lf` | 포맷팅 (stylua) |
| `<Space>Lc` | 확인 (luacheck) |

### R 전용
| 키 | 동작 |
|-----|--------|
| `F5` | R 콘솔 시작 |
| `F6` | 파일을 R로 전송 |
| `<Space>rr` | 콘솔 시작 |
| `<Space>rq` | 콘솔 닫기 |
| `<Space>rf` | 파일 전송 |
| `<Space>rl` | 줄 전송 |
| `<Space>rs` | 선택 영역 전송 (비주얼) |
| `<Space>rh` | 도움말 |
| `<Space>ro` | 객체 브라우저 |
| `<Space>rv` | DataFrame 보기 |
| `<Space>rc` | 모두 지우기 |
| `<Space>rp` | 스크립트 실행 (Rscript) |
| `<Space>ri` | R 대화형 |

### C# 전용
| 키 | 동작 |
|-----|--------|
| `F5` | C# 프로젝트 실행 (dotnet run) |
| `F6` | 테스트 실행 (dotnet test) |
| `<Space>Cr` | 실행 |
| `<Space>Cb` | 빌드 (dotnet build) |
| `<Space>Ct` | 테스트 |
| `<Space>Cc` | 정리 |
| `<Space>Cf` | 포맷팅 (dotnet format) |
| `<Space>Cn` | 새 프로젝트 |
| `<Space>Ca` | 패키지 추가 |

### Swift 전용
| 키 | 동작 |
|-----|--------|
| `F5` | Swift 프로젝트 실행 |
| `F6` | 테스트 실행 |
| `<Space>Sr` | 실행 (swift run) |
| `<Space>Sb` | 빌드 (swift build) |
| `<Space>St` | 테스트 (swift test) |
| `<Space>Sf` | 포맷팅 (swift-format) |
| `<Space>Sl` | 린팅 (swiftlint) |
| `<Space>SX` | Xcode 선택기 |
| `<Space>SB` | Xcode 빌드 |
| `<Space>ST` | Xcode 테스트 |
| `<Space>SD` | 디바이스 선택 |
| `<Space>SS` | 스킴 선택 |

### Bash 전용
| 키 | 동작 |
|-----|--------|
| `F5` | 셸 스크립트 실행 |
| `F6` | Shellcheck |
| `<Space>br` | 실행 |
| `<Space>bx` | 실행 가능하게 만들기 (chmod +x) |
| `<Space>bc` | Shellcheck |
| `<Space>bf` | 포맷팅 (shfmt) |
| `<Space>bd` | 디버그 모드 (bash -x) |
| `<Space>bs` | 구문 확인 (bash -n) |

### Zig 전용
| 키 | 동작 |
|-----|--------|
| `F5` | 빌드 & 실행 (zig build run) |
| `F6` | 테스트 실행 (zig test) |
| `<Space>zr` | 실행 |
| `<Space>zb` | 빌드 |
| `<Space>zt` | 테스트 |
| `<Space>zf` | 포맷팅 (zig fmt) |
| `<Space>zc` | AST 확인 |
| `<Space>zd` | 디버그 빌드 |
| `<Space>zR` | 릴리스 빌드 |

### Elixir 전용
| 키 | 동작 |
|-----|--------|
| `F5` | Elixir 실행 (mix run) |
| `F6` | 테스트 실행 (mix test) |
| `<Space>er` | IEx REPL (iex -S mix) |
| `<Space>et` | 모든 테스트 |
| `<Space>eT` | 현재 파일 테스트 |
| `<Space>ef` | 포맷팅 (mix format) |
| `<Space>ec` | 컴파일 (mix compile) |
| `<Space>ed` | 의존성 가져오기 |
| `<Space>eD` | Dialyzer |
| `<Space>eC` | Credo |
| `<Space>ep` | Phoenix 서버 |

### Haskell 전용
| 키 | 동작 |
|-----|--------|
| `F5` | Haskell 실행 (stack/cabal run) |
| `F6` | 테스트 실행 |
| `<Space>hr` | GHCi REPL |
| `<Space>hb` | 빌드 (stack/cabal) |
| `<Space>ht` | 테스트 |
| `<Space>hf` | 포맷팅 (ormolu) |
| `<Space>hl` | 린팅 (hlint) |
| `<Space>hc` | 컴파일 (ghc) |
| `<Space>hh` | Hoogle 시그니처 |
| `<Space>he` | 모두 평가 |

### Scala 전용
| 키 | 동작 |
|-----|--------|
| `F5` | Scala 실행 (sbt run) |
| `F6` | 테스트 실행 (sbt test) |
| `<Space>mc` | 컴파일 캐스케이드 |
| `<Space>mr` | 실행 |
| `<Space>mt` | 테스트 |
| `<Space>mb` | 빌드 (sbt compile) |
| `<Space>mf` | 포맷팅 (scalafmt) |
| `<Space>mi` | 임포트 정리 |
| `<Space>mh` | 호버 워크시트 |
| `<Space>ms` | Metals 명령 |
| `<Space>mR` | REPL (sbt console) |

### Nim 전용
| 키 | 동작 |
|-----|--------|
| `F5` | 컴파일 & 실행 (nim compile --run) |
| `F6` | 테스트 실행 (nimble test) |
| `<Space>nr` | 실행 |
| `<Space>nb` | 빌드 (nim compile) |
| `<Space>nc` | 확인 (nim check) |
| `<Space>nt` | 테스트 (nimble test) |
| `<Space>nf` | 포맷팅 (nimpretty) |
| `<Space>nd` | 문서 생성 |
| `<Space>nR` | 릴리스 빌드 |
| `<Space>nD` | 디버그 빌드 |

### 터미널
| 키 | 동작 |
|-----|--------|
| `Ctrl+\` | 플로팅 터미널 토글 |
| `<Space>tf` | 터미널 열기 (플로팅) |
| `<Space>th` | 터미널 열기 (수평 분할) |
| `<Space>tv` | 터미널 열기 (수직 분할) |
| `Esc` (터미널에서) | 터미널 모드 종료 |

### 실행 취소 트리
| 키 | 동작 |
|-----|--------|
| `<Space>u` | 실행 취소 트리 토글 |

시각적 실행 취소 히스토리를 탐색하여 파일의 이전 상태를 복원하세요. 실행 취소 히스토리는 세션 간에 유지됩니다.

### Git
**Git Signs (인라인 변경사항)**:
| 키 | 동작 |
|-----|--------|
| `]c` | 다음 hunk |
| `[c` | 이전 hunk |
| `<Space>hs` | hunk 스테이징 |
| `<Space>hr` | hunk 리셋 |
| `<Space>hb` | 줄 블레임 |
| `<Space>hp` | hunk 미리보기 |
| `<Space>hd` | 이것 diff |

**LazyGit (Git UI)**:
| 키 | 동작 |
|-----|--------|
| `<Space>gg` | LazyGit 열기 |
| `<Space>gc` | LazyGit 설정 |
| `<Space>gf` | LazyGit 필터 |
| `<Space>gF` | LazyGit 현재 파일 |

**Neogit (Magit 스타일 Git 인터페이스)**:
| 키 | 동작 |
|-----|--------|
| `<Space>gs` | Neogit 상태 |
| `<Space>gC` | Neogit 커밋 |
| `<Space>gp` | Neogit 푸시 |
| `<Space>gP` | Neogit 풀 |
| `<Space>gl` | Neogit 로그 |
| `<Space>gr` | **빠른 소프트 리셋** (가장 안전) |
| `<Space>gR` | **대화형 리셋** (soft/mixed/hard 선택) |

**Diffview (시각적 Diff)**:
| 키 | 동작 |
|-----|--------|
| `<Space>gd` | Diffview 열기 |
| `<Space>gD` | Diffview 닫기 |
| `<Space>gh` | Diffview 파일 히스토리 (모든 파일) |
| `<Space>gH` | Diffview 현재 파일 히스토리 |

**안전한 Git 리셋 기능**:
- **`<Space>gr`**: 빠른 소프트 리셋 (가장 안전)
  - 마지막 커밋만 취소
  - 모든 변경사항은 유지됨
  - 확인 메시지 표시

- **`<Space>gR`**: 대화형 리셋 (선택형)
  - **Soft**: 커밋만 취소, 변경사항 + staging 유지
  - **Mixed**: 커밋 + staging 취소, 파일 내용 유지
  - **Hard**: 모든 변경사항 완전 삭제 (⚠️ 'yes' 입력 필요)

### 진단
| 키 | 동작 |
|-----|--------|
| `<Space>xx` | 진단 토글 |
| `<Space>xX` | 버퍼 진단 |
| `<Space>q` | 진단 빠른 수정 |

### 주석
| 키 | 동작 |
|-----|--------|
| `gcc` | 줄 주석 토글 |
| `gbc` | 블록 주석 토글 |
| `gc` (비주얼) | 주석 토글 |

## 언어 서버 설정

모든 언어 서버와 도구는 첫 실행 시 Mason을 통해 자동으로 설치됩니다.

### Rust
- `rust-analyzer`: clippy 통합이 있는 언어 서버
- `codelldb`: 디버거
- `rustfmt`: 포맷터

### Go
- `gopls`: 언어 서버
- `goimports`: 임포트 관리
- `gofumpt`: 엄격한 포맷터
- `delve`: 디버거
- Go 도구: gomodifytags, impl

### Python
- `pyright`: 빠른 타입 인식 언어 서버
- `black`: 코드 포맷터
- `isort`: 임포트 정렬기
- `debugpy`: 디버거

### C/C++
- `clangd`: clang-tidy가 있는 언어 서버
- `clang-format`: 코드 포맷터
- `codelldb`: 디버거

### Java
- `jdtls`: Eclipse JDT 언어 서버
- `google-java-format`: 코드 포맷터
- `java-debug-adapter`: 디버거
- `java-test`: 테스트 러너

### TypeScript/JavaScript
- `typescript-language-server`: 언어 서버
- `prettier`: 코드 포맷터
- `eslint_d`: 빠른 린터
- `js-debug-adapter`: 디버거

### PHP
- `intelephense`: 언어 서버
- `php-cs-fixer`: 코드 포맷터
- `phpstan`: 정적 분석기
- `php-debug-adapter`: Xdebug 디버거

### SQL
- `sqlls`: SQL 언어 서버
- `sqlfluff`: 포맷터 및 린터
- `sql-formatter`: SQL 포맷터

### Kotlin
- `kotlin-language-server`: Kotlin LSP
- `ktlint`: 포맷터 및 린터

### Dart/Flutter
- `dartls`: Dart 언어 서버 (Flutter SDK를 통해)
- `dart-debug-adapter`: 디버거
- `flutter-tools`: 완전한 Flutter 도구

### Ruby
- `ruby-lsp`: 현대적인 Ruby 언어 서버
- `rubocop`: 포맷터 및 린터

### Lisp
- Common Lisp용 SBCL (외부 의존성)
- Scheme용 Racket (외부 의존성)
- `vlime`: Lisp 개발을 위한 Neovim 플러그인

### Lua
- `lua_ls`: Lua 언어 서버
- `stylua`: Lua 포맷터
- `luacheck`: Lua 린터

### R
- `r-languageserver`: R 언어 서버
- `styler`: R 포맷터 (R 패키지를 통해)
- `R.nvim`: 완전한 R 개발 환경

### C#
- `omnisharp`: C# 언어 서버
- `netcoredbg`: .NET 디버거
- `csharpier`: C# 포맷터 (선택사항, dotnet format 사용 가능)

### Swift
- `sourcekit-lsp`: Swift 언어 서버
- `swiftformat`: Swift 포맷터
- `xcodebuild.nvim`: Xcode 통합

### Bash
- `bash-language-server`: Bash LSP
- `shellcheck`: 셸 스크립트 분석기
- `shfmt`: 셸 스크립트 포맷터

### Zig
- `zls`: Zig 언어 서버
- 내장 `zig fmt` 포맷팅

### Elixir
- `elixir-ls`: Elixir 언어 서버
- 내장 `mix format` 포맷팅
- `credo`: Elixir 정적 코드 분석기
- `dialyzer`: Erlang/Elixir용 정적 분석기

### Haskell
- `haskell-language-server`: Haskell LSP
- `ormolu`: Haskell 포맷터
- `hlint`: Haskell 린터
- `hoogle`: Haskell API 검색

### Scala
- `nvim-metals`: Scala Metals 통합
- `scalafmt`: Scala 포맷터
- `sbt`: Scala 빌드 도구

### Nim
- `nim-langserver`: Nim 언어 서버
- `nimpretty`: Nim 포맷터
- 내장 `nim check` 검증

## 포맷팅

### 저장 시 자동 포맷팅
모든 지원 언어에 대해 기본적으로 활성화됨:
- **Rust**: rustfmt
- **Go**: goimports + gofumpt
- **Python**: isort + black
- **C/C++**: clang-format
- **Java**: google-java-format
- **TypeScript/JavaScript**: prettier
- **PHP**: php-cs-fixer
- **SQL**: sqlfluff
- **Kotlin**: ktlint
- **Dart**: dart format
- **Ruby**: rubocop
- **R**: styler
- **C#**: csharpier (또는 dotnet format)
- **Swift**: swiftformat
- **Bash/Zsh**: shfmt
- **Zig**: zig fmt
- **Elixir**: mix format
- **Haskell**: ormolu
- **Scala**: scalafmt
- **Nim**: nimpretty
- **HTML/CSS**: prettier
- **Lua**: stylua

### 수동 포맷팅
현재 버퍼를 포맷하려면 `<Space>f`를 누르세요.

## 테스팅

### Rust
rustaceanvim 명령 사용:
- `<Space>rt` - 테스트 러너로 테스트 실행
- `<Space>rr` - 현재 실행 가능 항목 실행
- `<Space>dr` - 현재 실행 가능 항목 디버그

### Go
go.nvim 명령 사용:
- `<Space>gt` - 파일의 모든 테스트 실행
- `<Space>gT` - 커서 아래 테스트 실행
- `<Space>gc` - 테스트 커버리지 표시

## 디버깅

### 디버그 세션 시작
1. `<Space>b`로 중단점 설정
2. `F5`를 눌러 디버깅 시작
3. `F1/F2/F3`을 사용하여 코드를 단계별로 실행
4. 디버그 UI가 자동으로 열림

### Rust 디버깅
디버거가 실행 파일 경로를 요청합니다:
```
target/debug/your_binary
```

### Go 디버깅
go.nvim 및 Delve를 통해 자동으로 구성됩니다.

## 파일 탐색기

파일 트리를 토글하려면 `<Space>e`를 누르세요:
- `<CR>` - 파일/폴더 열기
- `a` - 파일 생성
- `d` - 파일 삭제
- `r` - 파일 이름 변경
- `x` - 파일 잘라내기
- `c` - 파일 복사
- `p` - 파일 붙여넣기
- `R` - 트리 새로고침

## 커스터마이징

### 색상 스킴 변경
`~/.config/nvim/lua/plugins/colorscheme.lua`를 편집하고 변경:
```lua
vim.cmd.colorscheme("tokyonight")
```

인기 있는 대안:
- `catppuccin`
- `gruvbox`
- `nord`
- `onedark`

### 플러그인 추가
`~/.config/nvim/lua/plugins/`에 새 파일 생성:
```lua
return {
  {
    "author/plugin-name",
    config = function()
      -- 플러그인 구성
    end,
  },
}
```

## 문제 해결

### 플러그인이 설치되지 않음
```bash
nvim --headless "+Lazy! sync" +qa
```

### LSP가 작동하지 않음
1. Mason 확인: `:Mason`
2. 설치된 서버 확인: `:LspInfo`
3. 서버 재설치: `:Mason` → 서버 선택 → `i` 누르기

### Rust-Analyzer 문제
```bash
rustup component add rust-analyzer
```

### Go 도구 누락
```bash
go install golang.org/x/tools/gopls@latest
go install github.com/go-delve/delve/cmd/dlv@latest
```

### 상태 확인
```vim
:checkhealth
```

## 시스템 요구사항

- Neovim ≥ 0.10.0 ✅ (현재 0.11.3)
- Git
- Rust 도구 체인 ✅ (rust-analyzer, rustfmt, clippy)
- Go 도구 체인 ✅ (go ≥ 1.20)
- ripgrep (Telescope grep용)
- fd (Telescope find용, 선택사항)
- Node.js (일부 LSP 서버용, 선택사항)

## 프로젝트 구조

```
~/.config/nvim/
├── init.lua                    # 메인 설정 진입점
└── lua/
    └── plugins/
        ├── colorscheme.lua     # 색상 스킴
        ├── completion.lua      # 자동완성
        ├── debug.lua           # 디버깅 (DAP)
        ├── editor.lua          # 에디터 향상
        ├── formatting.lua      # 코드 포맷팅
        ├── git.lua             # Git 통합
        ├── go.lua              # Go 전용
        ├── lsp.lua             # 언어 서버
        ├── rust.lua            # Rust 전용
        ├── telescope.lua       # 퍼지 파인더
        ├── treesitter.lua      # 구문 강조
        └── ui.lua              # UI 컴포넌트
```

## 다음 단계

1. Neovim 실행: `nvim`
2. 플러그인 설치 대기
3. Neovim 재시작
4. Rust 프로젝트 열기: `nvim src/main.rs`
5. Go 프로젝트 열기: `nvim main.go`
6. 키 바인딩을 시도하고 기능 탐색

새로운 IDE 수준의 Neovim 경험을 즐기세요! 🚀

---

## 🤝 기여

기여를 환영합니다! 자세한 내용은 [기여 가이드](CONTRIBUTING.md)를 참조하세요.

### 기여 방법

- 🐛 [Issues](https://github.com/epicsagas/vortex.nvim/issues)를 통해 버그 보고
- 💡 [Issues](https://github.com/epicsagas/vortex.nvim/issues)를 통해 기능 제안
- 🌍 새로운 언어 지원 추가
- 📝 문서 개선
- 🔧 Pull Request 제출

자세한 가이드라인은 [CONTRIBUTING.md](CONTRIBUTING.md)를 참조하세요.

## 📝 라이선스

이 프로젝트는 Apache License 2.0을 따릅니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 확인하세요.

### 서드파티 플러그인 고지

Lazy.nvim이 자동 설치하는 일부 플러그인은 GPL 또는 AGPL을 사용합니다. 다음 구성 요소(포함되지만 이에 국한되지 않음)를 함께 배포하거나 수정할 때에는 각 라이선스의 요구 사항(소스 제공, 라이선스 사본 전달, AGPL의 네트워크 의무 등)을 반드시 준수하세요.

- `nvim-tree/nvim-tree.lua`
- `akinsho/bufferline.nvim`
- `akinsho/toggleterm.nvim`
- `mfussenegger/nvim-dap`
- `theHamsta/nvim-dap-virtual-text`
- `jay-babu/mason-nvim-dap.nvim`
- `mrcjkb/haskell-tools.nvim`
- `mrcjkb/rustaceanvim`
- `R-nvim/R.nvim`
- `sindrets/diffview.nvim`

## 🌟 지원 표시

이 프로젝트가 도움이 되었다면 다음을 고려해주세요:

- ⭐ 저장소에 스타 주기
- 🐛 문제 보고
- 💡 기능 제안
- 🔀 코드 기여
- 📢 다른 사람들과 공유

## 📞 지원 & 커뮤니티

- 📖 **문서**: 포괄적인 가이드 확인
- 🐛 **Issues**: [버그 보고](https://github.com/epicsagas/vortex.nvim/issues)
- 💬 **Discussions**: [토론 참여](https://github.com/epicsagas/vortex.nvim/discussions)
- 🔧 **문제 해결**: [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) 참조

## 📊 프로젝트 통계

- **지원 언어**: 24개
- **LSP 서버**: 24개 이상
- **플러그인**: 50개 이상
- **문서 페이지**: 10개 이상
- **설정 라인**: 5000개 이상

## 🏆 감사의 말

이 설정은 다음의 훌륭한 작업을 기반으로 구축되었습니다:

- [Neovim](https://neovim.io/) - 확장 가능한 텍스트 에디터
- [lazy.nvim](https://github.com/folke/lazy.nvim) - 플러그인 관리자
- [Mason](https://github.com/williamboman/mason.nvim) - LSP 설치 프로그램
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - LSP 구성
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) - 자동완성 엔진
- [Telescope](https://github.com/nvim-telescope/telescope.nvim) - 퍼지 파인더
- [Treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - 구문 강조
- [CodeCompanion](https://github.com/olimorris/codecompanion.nvim) - AI 통합
- 모든 플러그인 작성자 및 기여자분들!

## 📜 행동 강령

이 프로젝트는 [행동 강령](CODE_OF_CONDUCT.md)을 준수합니다. 참여함으로써 이 규칙을 준수할 것으로 예상됩니다.

## 📈 변경 로그

이 프로젝트의 변경 히스토리는 [CHANGELOG.md](CHANGELOG.md)를 참조하세요.

---

**커뮤니티의 ❤️로 만들어졌습니다**

**[epicsagas](https://github.com/epicsagas)의 ❤️로 만들어졌습니다**

