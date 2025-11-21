# 언어별 상세 가이드

24개 언어에 대한 설정 요구사항, 설치 방법, 사용 팁입니다.

## 목차
- [Systems Languages](#systems-languages): Rust, Go, C/C++, Zig, Nim
- [JVM Languages](#jvm-languages): Java, Kotlin, Scala
- [Mobile Development](#mobile-development): Swift, Dart/Flutter
- [Web Development](#web-development): TypeScript, JavaScript, PHP
- [Scripting Languages](#scripting-languages): Python, Ruby, Bash, Lua, R
- [Functional Languages](#functional-languages): Haskell, Elixir, Lisp
- [Enterprise Languages](#enterprise-languages): C#
- [Query Languages](#query-languages): SQL

---

## Systems Languages

### Rust

**필수 도구**:
```bash
# macOS/Linux
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup component add rust-analyzer rustfmt clippy
```

**LSP**: rust-analyzer (Mason 자동 설치)
**Formatter**: rustfmt
**Debugger**: codelldb
**플러그인**: rustaceanvim, crates.nvim

**키바인딩**:
- `F5`: cargo run
- `F6`: cargo test
- `<Space>rr`: Runnables 메뉴
- `<Space>rt`: Testables 메뉴
- `<Space>rd`: Debuggables
- `<Space>re`: Expand macro
- `<Space>rc`: Open Cargo.toml

**팁**:
- `crates.nvim`가 Cargo.toml에서 버전 자동완성 제공
- rustaceanvim이 자동으로 rust-analyzer 설정 최적화
- clippy 힌트가 자동으로 표시됨

---

### Go

**필수 도구**:
```bash
# macOS
brew install go

# Linux
wget https://go.dev/dl/go1.21.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.21.linux-amd64.tar.gz

# 추가 도구 (자동 설치됨)
go install golang.org/x/tools/gopls@latest
go install github.com/go-delve/delve/cmd/dlv@latest
```

**LSP**: gopls
**Formatter**: goimports + gofumpt
**Debugger**: Delve
**플러그인**: go.nvim

**키바인딩**:
- `F5`: go run
- `F6`: go test
- `<Space>gr`: Go run
- `<Space>gt`: Test all
- `<Space>gT`: Test function
- `<Space>gc`: Test coverage
- `<Space>gi`: Add if err block
- `<Space>gf`: Fill struct
- `<Space>ga`: Alternate file (test ↔ impl)

**팁**:
- go.nvim가 자동으로 imports 정리
- `:GoAddTag json` - struct 태그 추가
- `:GoFillStruct` - struct 필드 자동 채우기

---

### C/C++

**필수 도구**:
```bash
# macOS
xcode-select --install
brew install llvm

# Linux
sudo apt install build-essential clang clangd clang-format
```

**LSP**: clangd
**Formatter**: clang-format
**Debugger**: codelldb
**플러그인**: clangd_extensions.nvim

**키바인딩**:
- `F5`: Compile & run (gcc/g++)
- `F6`: Compile with debug info
- `<Space>ch`: Switch header/source

**팁**:
- `compile_commands.json` 생성으로 LSP 향상:
  ```bash
  cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .
  ```
- `.clang-format` 파일로 스타일 커스터마이즈

---

### Zig

**필수 도구**:
```bash
# macOS
brew install zig zls

# Linux
# https://ziglang.org/download/ 에서 다운로드
```

**LSP**: zls
**Formatter**: zig fmt (내장)
**플러그인**: zig.vim

**키바인딩**:
- `F5`: zig build run
- `F6`: zig test
- `<Space>zr`: Run
- `<Space>zb`: Build
- `<Space>zt`: Test
- `<Space>zf`: Format
- `<Space>zd`: Debug build
- `<Space>zR`: Release build

---

### Nim

**필수 도구**:
```bash
# macOS
brew install nim

# Linux - choosenim 사용 권장
curl https://nim-lang.org/choosenim/init.sh -sSf | sh
```

**LSP**: nim_langserver
**Formatter**: nimpretty
**플러그인**: nim.nvim

**키바인딩**:
- `F5`: nim compile --run
- `F6`: nimble test
- `<Space>nr`: Run
- `<Space>nb`: Build
- `<Space>nc`: Check
- `<Space>nf`: Format
- `<Space>nd`: Generate docs

**팁**:
- `.nimble` 파일이 있으면 자동으로 nimble 사용
- `nim check`로 빠른 문법 검사

---

## JVM Languages

### Java

**필수 도구**:
```bash
# macOS
brew install openjdk maven

# Linux
sudo apt install openjdk-17-jdk maven
```

**LSP**: jdtls (Eclipse JDT)
**Formatter**: google-java-format
**Debugger**: java-debug-adapter
**플러그인**: nvim-java

**키바인딩**:
- `F5`: javac + java
- `F6`: Maven test
- `<Space>jc`: Run main class
- `<Space>jt`: Test class
- `<Space>jT`: Test method
- `<Space>jd`: Debug test

**팁**:
- jdtls가 자동으로 프로젝트 설정 감지 (Maven/Gradle)
- 첫 시작이 느릴 수 있음 (workspace 초기화)

---

### Kotlin

**필수 도구**:
```bash
# macOS
brew install kotlin ktlint

# Gradle 프로젝트 권장
```

**LSP**: kotlin-language-server
**Formatter**: ktlint
**Debugger**: Java debug adapter

**키바인딩**:
- `F5`: kotlinc + kotlin
- `F6`: Gradle test
- `<Space>kr`: Run
- `<Space>kb`: Build (Gradle)
- `<Space>kt`: Test
- `<Space>kc`: Format

---

### Scala

**필수 도구**:
```bash
# macOS
brew install scala sbt scalafmt

# Coursier 설치 권장
curl -fL https://github.com/coursier/launchers/raw/master/cs-x86_64-apple-darwin.gz | gzip -d > cs && chmod +x cs && ./cs setup
```

**LSP**: Metals (nvim-metals)
**Formatter**: scalafmt
**플러그인**: nvim-metals

**키바인딩**:
- `F5`: sbt run
- `F6`: sbt test
- `<Space>mc`: Compile cascade
- `<Space>mt`: Test
- `<Space>mf`: Format
- `<Space>mR`: REPL

**팁**:
- Metals는 첫 시작 시 프로젝트 import 필요
- `.scalafmt.conf`로 포맷 스타일 설정

---

## Mobile Development

### Swift

**필수 도구**:
```bash
# macOS only
xcode-select --install

# 추가 도구
brew install swiftformat swiftlint
```

**LSP**: sourcekit-lsp
**Formatter**: swiftformat
**Debugger**: LLDB
**플러그인**: xcodebuild.nvim

**키바인딩**:
- `F5`: swift run
- `F6`: swift test
- `<Space>Sr`: Run
- `<Space>Sb`: Build
- `<Space>St`: Test
- `<Space>SX`: Xcode picker
- `<Space>SD`: Select device

**팁**:
- Package.swift 또는 Xcode 프로젝트 모두 지원
- xcodebuild.nvim으로 Xcode 완전 통합

---

### Dart/Flutter

**필수 도구**:
```bash
# Flutter SDK 설치
# https://docs.flutter.dev/get-started/install

# macOS
brew install --cask flutter

# PATH 설정
export PATH="$PATH:`pwd`/flutter/bin"
flutter doctor
```

**LSP**: dartls (Flutter SDK 포함)
**Formatter**: dart format
**Debugger**: Dart debug adapter
**플러그인**: flutter-tools.nvim

**키바인딩**:
- `F5`: Flutter run
- `F6`: Flutter test
- `<Space>dr`: Flutter run
- `<Space>dh`: Hot reload
- `<Space>dR`: Flutter restart
- `<Space>dd`: Devices
- `<Space>de`: Emulators
- `<Space>dt`: DevTools

**팁**:
- `flutter pub get` 자동 실행
- Hot reload로 빠른 개발
- Widget 가이드 자동 표시

---

## Web Development

### TypeScript/JavaScript

**필수 도구**:
```bash
# macOS
brew install node

# Linux
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install nodejs

# 글로벌 도구
npm install -g typescript tsx prettier eslint
```

**LSP**: typescript-language-server (typescript-tools.nvim)
**Formatter**: prettier
**Linter**: eslint_d
**Debugger**: js-debug-adapter

**키바인딩**:
- `F5`: node/tsx 실행
- `F6`: npm test
- `<Space>to`: Organize imports
- `<Space>ts`: Sort imports
- `<Space>tu`: Remove unused
- `<Space>ti`: Add missing imports
- `<Space>tf`: Fix all

**팁**:
- typescript-tools가 inlay hints 제공
- ESLint 자동 수정: `<Space>ca` → Fix ESLint
- `tsconfig.json` 설정 자동 감지

---

### PHP

**필수 도구**:
```bash
# macOS
brew install php composer

# Linux
sudo apt install php php-cli composer

# 추가 도구
composer global require friendsofphp/php-cs-fixer
composer global require phpstan/phpstan
```

**LSP**: intelephense
**Formatter**: php-cs-fixer
**Linter**: phpstan
**Debugger**: Xdebug
**플러그인**: phpactor

**키바인딩**:
- `F5`: php 실행
- `F6`: phpunit
- `<Space>pm`: Context menu
- `<Space>pn`: New class
- `<Space>pu`: Import class
- `<Space>pa`: Import missing classes

**팁**:
- Composer autoload 자동 감지
- phpactor로 클래스 생성 및 import

---

## Scripting Languages

### Python

**필수 도구**:
```bash
# macOS
brew install python

# Linux
sudo apt install python3 python3-pip python3-venv

# 추가 도구
pip install black isort debugpy pytest
```

**LSP**: pyright
**Formatter**: black + isort
**Debugger**: debugpy
**플러그인**: venv-selector.nvim

**키바인딩**:
- `F5`: python3 실행
- `F6`: pytest
- `<Space>vs`: Select venv
- `<Space>pc`: Syntax check
- `<Space>pi`: Install requirements

**팁**:
- 가상환경 자동 감지 (.venv, venv)
- `<Space>vs`로 수동 선택 가능
- Type hints로 더 나은 자동완성

---

### Ruby

**필수 도구**:
```bash
# macOS
brew install ruby rubocop

# Linux
sudo apt install ruby-full

# Bundler
gem install bundler rubocop
```

**LSP**: ruby-lsp
**Formatter**: rubocop
**Debugger**: Ruby debug adapter
**플러그인**: vim-ruby

**키바인딩**:
- `F5`: ruby 실행
- `F6`: rspec
- `<Space>Rr`: Run
- `<Space>Rt`: Test (RSpec)
- `<Space>Rb`: Bundle install
- `<Space>Rf`: Format
- `<Space>Ri`: IRB REPL

---

### Bash

**필수 도구**:
```bash
# macOS
brew install shellcheck shfmt

# Linux
sudo apt install shellcheck
go install mvdan.cc/sh/v3/cmd/shfmt@latest
```

**LSP**: bash-language-server
**Formatter**: shfmt
**Linter**: shellcheck

**키바인딩**:
- `F5`: 스크립트 실행
- `F6`: shellcheck
- `<Space>br`: Run
- `<Space>bx`: chmod +x
- `<Space>bc`: Shellcheck
- `<Space>bf`: Format
- `<Space>bd`: Debug mode (bash -x)

**팁**:
- shellcheck로 일반적인 실수 자동 감지
- `#!/bin/bash` shebang 필수

---

### Lua

**필수 도구**:
```bash
# macOS
brew install lua stylua luacheck

# Linux
sudo apt install lua5.4
```

**LSP**: lua_ls
**Formatter**: stylua
**Linter**: luacheck
**플러그인**: lazydev.nvim

**키바인딩**:
- `F5`: lua 실행
- `F6`: Source (Neovim)
- `<Space>Lr`: Run
- `<Space>Ls`: Source
- `<Space>Lf`: Format
- `<Space>Lc`: Check

**팁**:
- lazydev.nvim이 Neovim API 자동완성 제공
- Neovim 설정 개발에 최적화

---

### R

**필수 도구**:
```bash
# macOS
brew install r

# Linux
sudo apt install r-base

# R에서 설치
R
install.packages("languageserver")
install.packages("styler")
```

**LSP**: r-languageserver
**Formatter**: styler
**플러그인**: R.nvim

**키바인딩**:
- `F5`: R console 시작
- `F6`: Send file to R
- `<Space>rr`: Start console
- `<Space>rf`: Send file
- `<Space>rl`: Send line
- `<Space>rs`: Send selection
- `<Space>rv`: View DataFrame

**팁**:
- R.nvim이 REPL 완전 통합
- RStudio와 유사한 워크플로우

---

## Functional Languages

### Haskell

**필수 도구**:
```bash
# GHCup 설치 (권장)
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

# 또는 Stack
curl -sSL https://get.haskellstack.org/ | sh

# 추가 도구
ghcup install hls
cabal install ormolu hlint
```

**LSP**: haskell-language-server
**Formatter**: ormolu
**Linter**: hlint
**플러그인**: haskell-tools.nvim

**키바인딩**:
- `F5`: stack/cabal run
- `F6`: stack test
- `<Space>hr`: GHCi REPL
- `<Space>hb`: Build
- `<Space>hf`: Format
- `<Space>hh`: Hoogle search

**팁**:
- HLS 첫 시작이 느림 (프로젝트 빌드)
- Hoogle로 타입 시그니처 검색

---

### Elixir

**필수 도구**:
```bash
# macOS
brew install elixir

# Linux
sudo apt install elixir

# Phoenix (선택)
mix archive.install hex phx_new
```

**LSP**: elixir-ls
**Formatter**: mix format (내장)
**Debugger**: Elixir debug adapter
**플러그인**: elixir-tools.nvim

**키바인딩**:
- `F5`: mix run
- `F6`: mix test
- `<Space>er`: IEx REPL
- `<Space>et`: Test all
- `<Space>eT`: Test file
- `<Space>ef`: Format
- `<Space>ep`: Phoenix server

**팁**:
- Mix 프로젝트 자동 감지
- Phoenix LiveView 지원

---

### Lisp (Common Lisp & Scheme)

**필수 도구**:
```bash
# Common Lisp - SBCL
# macOS
brew install sbcl

# Scheme - Racket
brew install racket
```

**플러그인**: vlime

**키바인딩**:
- `F5`: 스크립트 실행
- `F6`: REPL 로드
- `<Space>lr`: Start REPL
- `<Space>ll`: Load file
- `<Space>le`: Execute

**팁**:
- SBCL for Common Lisp
- Racket for Scheme
- REPL 중심 개발

---

## Enterprise Languages

### C#

**필수 도구**:
```bash
# macOS
brew install dotnet

# Linux
# https://dotnet.microsoft.com/download

# 추가 도구
dotnet tool install -g csharpier
```

**LSP**: omnisharp
**Formatter**: csharpier / dotnet format
**Debugger**: netcoredbg
**플러그인**: csharp.nvim

**키바인딩**:
- `F5`: dotnet run
- `F6`: dotnet test
- `<Space>Cr`: Run
- `<Space>Cb`: Build
- `<Space>Ct`: Test
- `<Space>Cf`: Format
- `<Space>Cn`: New project

**팁**:
- .csproj 파일 자동 감지
- NuGet 패키지 관리 지원

---

## Query Languages

### SQL

**필수 도구**:
```bash
# macOS
brew install sqlfluff

# Python으로 설치
pip install sqlfluff sql-formatter
```

**LSP**: sqlls
**Formatter**: sqlfluff

**키바인딩**:
- `F5`: View SQL
- `F6`: Format SQL
- `<Space>sf`: Format
- `<Space>sl`: Lint

**팁**:
- sqlfluff로 다양한 SQL dialect 지원
- 데이터베이스 연결은 dbext 사용

---

## 일반 팁

### LSP 최적화
```lua
-- init.lua에서 LSP 메모리 설정
vim.lsp.set_log_level("warn")  -- 로그 레벨 낮추기
```

### 언어 전환
여러 언어를 동시에 사용할 때:
- Telescope로 빠른 파일 전환: `<Space>ff`
- 버퍼 간 이동: `Shift+h` / `Shift+l`
- 최근 파일: `<Space>fr`

### 추가 학습 자료
각 언어별 공식 문서:
- `:help lspconfig-all` - 모든 LSP 서버 설정
- `:Mason` - 사용 가능한 도구 목록
- `:checkhealth` - 설정 상태 확인

---

**더 많은 정보가 필요하신가요?**
- README.md - 전체 기능 개요
- QUICKSTART.md - 빠른 시작
- TROUBLESHOOTING.md - 문제 해결
