# 문제 해결 가이드

Neovim 설정 사용 중 발생할 수 있는 문제들과 해결 방법입니다.

## 목차
- [설치 문제](#설치-문제)
- [LSP 문제](#lsp-문제)
- [플러그인 문제](#플러그인-문제)
- [Tree-sitter 문제](#tree-sitter-문제)
- [디버깅 문제](#디버깅-문제)
- [Git 통합 문제](#git-통합-문제)
- [언어별 문제](#언어별-문제)

---

## 설치 문제

### Neovim 버전이 너무 낮음
**증상**: `Neovim >= 0.10.0 required`

**해결**:
```bash
# macOS
brew upgrade neovim

# Linux
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt install neovim

# 버전 확인
nvim --version
```

### 플러그인이 설치되지 않음
**증상**: 플러그인 로딩 실패, lazy.nvim 오류

**해결**:
```bash
# 1. lazy.nvim 수동 설치
rm -rf ~/.local/share/nvim/lazy
nvim --headless "+Lazy! sync" +qa

# 2. 캐시 정리
rm -rf ~/.local/share/nvim/lazy
rm -rf ~/.cache/nvim

# 3. Neovim 재시작
nvim
```

### Git 클론 실패
**증상**: `fatal: could not read Username`

**해결**:
```bash
# SSH 키 설정
ssh-keygen -t ed25519 -C "your_email@example.com"
cat ~/.ssh/id_ed25519.pub
# GitHub에 SSH 키 추가

# 또는 HTTPS 사용
git clone https://github.com/epicsagas/vortex.nvim.git ~/.config/nvim
```

---

## LSP 문제

### LSP 서버가 작동하지 않음
**증상**: 자동완성 안 됨, 에러 표시 안 됨

**해결**:
```vim
" 1. Mason에서 서버 확인
:Mason

" 2. 서버 수동 설치 (Mason에서 'i' 키)
" 3. LSP 상태 확인
:LspInfo

" 4. LSP 재시작
:LspRestart
```

### Mason 설치 실패
**증상**: `Mason installation failed`

**해결**:
```bash
# 필수 도구 설치
# macOS
brew install node python3 go rust

# Linux
sudo apt install nodejs python3 python3-pip golang rustc

# Mason 데이터 삭제 후 재설치
rm -rf ~/.local/share/nvim/mason
nvim
:Mason
```

### 특정 언어 LSP 안 됨
**증상**: 특정 언어만 LSP 작동 안 함

**해결**:
```vim
" 1. 해당 언어 파일 열기
" 2. LSP 로그 확인
:LspLog

" 3. Mason에서 서버 재설치
:Mason
" 해당 서버 선택 → 'X' (제거) → 'i' (재설치)

" 4. 상태 확인
:checkhealth lspconfig
```

---

## 플러그인 문제

### lazy.nvim 오류
**증상**: `Error in lazy.nvim`

**해결**:
```vim
" 1. 플러그인 재동기화
:Lazy sync

" 2. 특정 플러그인 문제
:Lazy log
" 에러 확인 후 해당 플러그인 재설치

" 3. 전체 재설치
:Lazy clean
:Lazy sync
```

### Telescope가 느림
**증상**: 파일 검색이 느림

**해결**:
```bash
# fzf-native 빌드
cd ~/.local/share/nvim/lazy/telescope-fzf-native.nvim
make

# ripgrep 설치 (더 빠른 검색)
brew install ripgrep
```

### Treesitter 하이라이팅 오류
**증상**: 문법 하이라이팅 깨짐

**해결**:
```vim
" 1. Parser 재설치
:TSInstall! all

" 2. 특정 언어만
:TSInstall! rust go python

" 3. 상태 확인
:TSInstallInfo
```

---

## Tree-sitter 문제

### Swift: tree-sitter CLI not found
**증상**: `tree-sitter CLI not found: tree-sitter is not executable!`

**원인**: Swift parser는 tree-sitter CLI가 필요하지만, Homebrew의 `tree-sitter` 패키지는 library만 설치함

**해결**:
```bash
# 올바른 패키지 설치
brew install tree-sitter-cli

# 또는 npm 사용
npm install -g tree-sitter-cli

# 확인
tree-sitter --version

# Neovim에서 Swift parser 설치
nvim
:TSInstall swift
```

**대안**: Swift를 사용하지 않는다면 비활성화
```lua
-- lua/plugins/treesitter.lua에서 "swift" 제거
ensure_installed = {
  "rust", "go", "python", -- ... "swift" 제외
}
```

### Parser 빌드 실패
**증상**: `Parser build failed for [language]`

**해결**:
```bash
# 컴파일러 설치
# macOS
xcode-select --install

# Linux
sudo apt install build-essential

# Parser 재빌드
nvim
:TSInstall! [language]
```

---

## 디버깅 문제

### 디버거가 시작되지 않음
**증상**: F9 눌러도 디버거 안 뜸

**해결**:
```vim
" 1. DAP 상태 확인
:lua require('dap').status()

" 2. 어댑터 확인
:lua print(vim.inspect(require('dap').adapters))

" 3. 설정 확인
:lua print(vim.inspect(require('dap').configurations))
```

### Rust 디버거: codelldb 오류
**해결**:
```bash
# codelldb 재설치
nvim
:Mason
# codelldb 선택 → 'X' → 'i'
```

### Go 디버거: Delve 오류
**해결**:
```bash
# Delve 수동 설치
go install github.com/go-delve/delve/cmd/dlv@latest

# PATH 확인
which dlv
```

---

## Git 통합 문제

### Git reset 오류: "reset is not a valid function"
**증상**: `<Space>gR` 또는 `<Space>gr` 실행 시 에러

**원인**: Fugitive 플러그인 없음 (이미 수정됨)

**확인**: 최신 버전으로 업데이트
```bash
cd ~/.config/nvim
git pull
nvim
```

### LazyGit이 열리지 않음
**해결**:
```bash
# LazyGit 설치
brew install lazygit

# 확인
lazygit --version
```

### Gitsigns가 작동하지 않음
**증상**: Git 변경사항 표시 안 됨

**해결**:
```bash
# Git 저장소인지 확인
git status

# Gitsigns 재시작
nvim
:Gitsigns toggle_signs
:Gitsigns toggle_signs
```

---

## 언어별 문제

### Rust

**증상**: rust-analyzer 느림

**해결**:
```bash
# rust-analyzer 업데이트
rustup update
rustup component add rust-analyzer

# Cargo 캐시 정리
cargo clean
```

### Go

**증상**: gopls 느림 또는 메모리 과다 사용

**해결**:
```bash
# gopls 업데이트
go install golang.org/x/tools/gopls@latest

# 작업 공간 초기화
rm -rf ~/go/pkg/mod/cache
```

### Python

**증상**: 가상환경 인식 안 됨

**해결**:
```vim
" 가상환경 수동 선택
<Space>vs

" 또는 명령어
:VenvSelect
```

**증상**: pyright가 라이브러리를 못 찾음

**해결**:
```bash
# 가상환경에서 타입 스텁 설치
pip install types-requests types-PyYAML
```

### TypeScript/JavaScript

**증상**: `Cannot find package 'tsserver'`

**원인**: typescript-tools.nvim 사용 (이미 수정됨)

**확인**: lsp.lua에 `tsserver = {}` 없어야 함

### Java

**증상**: jdtls 시작 느림

**해결**:
```bash
# JDK 버전 확인 (17+ 권장)
java --version

# 작업 공간 정리
rm -rf ~/.cache/jdtls-workspace
```

### Nim

**증상**: `zsh:1: command not found: nim`

**해결**:
```bash
# Nim 설치
brew install nim

# 또는 choosenim (버전 관리)
curl https://nim-lang.org/choosenim/init.sh -sSf | sh

# 확인
nim --version
nimble --version
```

### Swift

**증상**: sourcekit-lsp 오류

**해결**:
```bash
# Xcode Command Line Tools 설치
xcode-select --install

# sourcekit-lsp 확인
xcrun -f sourcekit-lsp
```

### C/C++

**증상**: clangd가 헤더를 못 찾음

**해결**:
```bash
# compile_commands.json 생성
# CMake 프로젝트
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .

# 수동 생성
bear -- make
```

---

## 성능 문제

### Neovim 시작이 느림
**해결**:
```vim
" 시작 시간 프로파일링
nvim --startuptime startup.log
```

플러그인 lazy loading 확인:
```lua
-- lua/plugins/*.lua에서
{
  "plugin-name",
  lazy = true,  -- 필요할 때만 로드
  ft = "rust",  -- 특정 파일타입에서만
  cmd = "PluginCommand",  -- 명령어 실행시에만
}
```

### 메모리 사용량이 높음
**해결**:
```vim
" LSP 메모리 사용량 확인
:lua print(vim.inspect(vim.lsp.get_active_clients()))

" 사용하지 않는 LSP 정지
:LspStop [server_name]
```

---

## 일반적인 해결 방법

### 1. 전체 상태 확인
```vim
:checkhealth
```

### 2. 로그 확인
```vim
:messages
:LspLog
:Lazy log
```

### 3. 깨끗한 시작
```bash
# 모든 플러그인과 캐시 제거
rm -rf ~/.local/share/nvim
rm -rf ~/.cache/nvim

# Neovim 재시작
nvim
```

### 4. 최신 버전으로 업데이트
```bash
cd ~/.config/nvim
git pull
nvim
:Lazy sync
```

---

## 추가 도움

### 로그 수집
문제 리포트 시 다음 정보 포함:
```bash
# 1. Neovim 버전
nvim --version

# 2. 운영체제
uname -a

# 3. Checkhealth 결과
nvim +checkhealth +qa > health.log 2>&1

# 4. 에러 메시지
# :messages 내용 복사
```

### GitHub Issues
https://github.com/epicsagas/vortex.nvim/issues

### Neovim 공식 문서
```vim
:help
:help lsp
:help dap
```

---

**문제가 해결되지 않나요?**
- 상세한 에러 메시지와 함께 GitHub Issue를 생성하세요
- `:checkhealth` 결과를 첨부하면 더 빠르게 도움을 받을 수 있습니다
