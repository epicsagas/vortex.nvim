NVIM_CONFIG := $(HOME)/.config/nvim
NVIM_DATA    := $(HOME)/.local/share/nvim
NVIM_STATE   := $(HOME)/.local/state/nvim
NVIM_CACHE   := $(HOME)/.cache/nvim
BACKUP_DIR   := $(HOME)/.config/nvim.backup.$(shell date +%Y%m%d_%H%M%S)
SCRIPTS_DIR  := $(CURDIR)/scripts

.DEFAULT_GOAL := help

# ── Formatting ────────────────────────────────────────────────────────────────
BOLD  := \033[1m
GREEN := \033[0;32m
YELLOW:= \033[1;33m
RED   := \033[0;31m
BLUE  := \033[0;34m
NC    := \033[0m

.PHONY: help install link update uninstall status clean plugins

help: ## Show this help
	@printf "$(BOLD)vortex.nvim$(NC)\n\n"
	@printf "$(BOLD)Usage:$(NC) make <target>\n\n"
	@printf "$(BOLD)Targets:$(NC)\n"
	@awk 'BEGIN{FS=":.*##"} /^[a-zA-Z_-]+:.*##/{printf "  $(BLUE)%-12s$(NC) %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# ── Install ───────────────────────────────────────────────────────────────────
install: ## Install vortex.nvim (runs scripts/install.sh + links vortex binary)
	@printf "$(BOLD)$(GREEN)=== Installing vortex.nvim ===$(NC)\n"
	@bash $(SCRIPTS_DIR)/install.sh
	@$(MAKE) --no-print-directory link

link: ## Symlink vortex binary to ~/.local/bin (no sudo required)
	@chmod +x $(SCRIPTS_DIR)/vortex
	@mkdir -p $(HOME)/.local/bin
	@ln -sf $(SCRIPTS_DIR)/vortex $(HOME)/.local/bin/vortex
	@printf "$(GREEN)✓$(NC) vortex linked to $(HOME)/.local/bin/vortex\n"
	@if ! echo "$$PATH" | grep -q "$(HOME)/.local/bin"; then \
	  printf "$(YELLOW)⚠$(NC) Add to PATH: export PATH=\"\$$HOME/.local/bin:\$$PATH\"\n"; \
	fi

# ── Update ────────────────────────────────────────────────────────────────────
update: ## Pull latest changes and sync plugins
	@printf "$(BOLD)$(BLUE)=== Updating vortex.nvim ===$(NC)\n"
	@REAL_CUR=$$(realpath "$(CURDIR)" 2>/dev/null || echo "$(CURDIR)"); \
	REAL_CFG=$$(realpath "$(NVIM_CONFIG)" 2>/dev/null || echo "$(NVIM_CONFIG)"); \
	if [ "$$REAL_CUR" = "$$REAL_CFG" ]; then \
	  git -C "$(NVIM_CONFIG)" pull --ff-only; \
	else \
	  git pull --ff-only; \
	  if [ -d "$(NVIM_CONFIG)" ]; then \
	    printf "$(YELLOW)Syncing files to $(NVIM_CONFIG)...$(NC)\n"; \
	    rsync -a --exclude='.git' "$(CURDIR)/" "$(NVIM_CONFIG)/"; \
	  fi; \
	fi
	@$(MAKE) --no-print-directory plugins
	@printf "$(GREEN)✓ Update complete$(NC)\n"

plugins: ## Sync lazy.nvim plugins (headless)
	@printf "$(BLUE)Syncing plugins...$(NC)\n"
	@nvim --headless "+Lazy! sync" +qa 2>/dev/null && \
	  printf "$(GREEN)✓ Plugins synced$(NC)\n" || \
	  printf "$(YELLOW)⚠ Plugin sync finished with warnings$(NC)\n"

# ── Status ────────────────────────────────────────────────────────────────────
status: ## Show installation status
	@printf "$(BOLD)=== vortex.nvim status ===$(NC)\n\n"

	@printf "$(BOLD)Neovim config:$(NC)\n"
	@if [ -d "$(NVIM_CONFIG)" ]; then \
	  printf "  $(GREEN)✓$(NC) $(NVIM_CONFIG)\n"; \
	  if [ -d "$(NVIM_CONFIG)/.git" ]; then \
	    printf "  branch : $$(git -C $(NVIM_CONFIG) branch --show-current 2>/dev/null)\n"; \
	    printf "  commit : $$(git -C $(NVIM_CONFIG) log --oneline -1 2>/dev/null)\n"; \
	  fi; \
	else \
	  printf "  $(RED)✗$(NC) not installed at $(NVIM_CONFIG)\n"; \
	fi

	@printf "\n$(BOLD)Theme:$(NC)\n"
	@if [ -f "$(NVIM_DATA)/vortex_theme.txt" ]; then \
	  printf "  $(GREEN)✓$(NC) $$(cat $(NVIM_DATA)/vortex_theme.txt)\n"; \
	else \
	  printf "  $(YELLOW)⚠$(NC) not set (default: tokyonight)\n"; \
	fi

	@printf "\n$(BOLD)Plugins (lazy.nvim):$(NC)\n"
	@if [ -d "$(NVIM_DATA)/lazy/lazy.nvim" ]; then \
	  PLUGIN_COUNT=$$(ls -d $(NVIM_DATA)/lazy/*/ 2>/dev/null | wc -l | tr -d ' '); \
	  printf "  $(GREEN)✓$(NC) $$PLUGIN_COUNT plugins installed\n"; \
	else \
	  printf "  $(RED)✗$(NC) lazy.nvim not found\n"; \
	fi

	@printf "\n$(BOLD)nvim-ai config:$(NC)\n"
	@AI_CONFIG="$(NVIM_CONFIG)/config/nvim-ai-config.yaml"; \
	if [ -f "$$AI_CONFIG" ]; then \
	  PROVIDER=$$(grep "^default_provider:" "$$AI_CONFIG" 2>/dev/null | sed 's/default_provider: *//' || echo "unknown"); \
	  printf "  $(GREEN)✓$(NC) provider: $$PROVIDER\n"; \
	else \
	  printf "  $(YELLOW)⚠$(NC) not configured\n"; \
	fi

	@printf "\n$(BOLD)Required tools:$(NC)\n"
	@for tool in nvim git gcc make curl rg fd; do \
	  if command -v $$tool > /dev/null 2>&1; then \
	    VER=$$($$tool --version 2>&1 | head -1 | grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?' | head -1); \
	    printf "  $(GREEN)✓$(NC) %-10s $$VER\n" "$$tool"; \
	  else \
	    printf "  $(RED)✗$(NC) $$tool\n"; \
	  fi; \
	done

	@printf "\n$(BOLD)Optional tools:$(NC)\n"
	@for tool in magick chafa node npm go rustc python3; do \
	  if command -v $$tool > /dev/null 2>&1; then \
	    VER=$$($$tool --version 2>&1 | head -1 | grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?' | head -1); \
	    printf "  $(GREEN)✓$(NC) %-12s $$VER\n" "$$tool"; \
	  else \
	    printf "  $(YELLOW)-$(NC) $$tool\n"; \
	  fi; \
	done

# ── Uninstall ─────────────────────────────────────────────────────────────────
uninstall: ## Remove vortex.nvim config and data (prompts before delete)
	@printf "$(BOLD)$(RED)=== Uninstall vortex.nvim ===$(NC)\n\n"
	@printf "$(YELLOW)This will remove:$(NC)\n"
	@printf "  $(NVIM_CONFIG)\n"
	@printf "  $(NVIM_DATA)\n"
	@printf "  $(NVIM_STATE)\n"
	@printf "  $(NVIM_CACHE)\n\n"
	@printf "$(RED)Are you sure? [y/N] $(NC)"; \
	read REPLY; \
	case "$$REPLY" in \
	  [yY]*) \
	    if [ -d "$(NVIM_CONFIG)" ]; then \
	      mv "$(NVIM_CONFIG)" "$(BACKUP_DIR)" && \
	        printf "$(GREEN)✓$(NC) Config backed up to $(BACKUP_DIR)\n"; \
	    fi; \
	    rm -rf "$(NVIM_DATA)" "$(NVIM_STATE)" "$(NVIM_CACHE)"; \
	    printf "$(GREEN)✓$(NC) vortex.nvim removed\n"; \
	    ;; \
	  *) printf "$(YELLOW)Aborted$(NC)\n"; ;; \
	esac

# ── Clean ─────────────────────────────────────────────────────────────────────
clean: ## Remove compiled Lua cache only (safe, keeps plugins)
	@printf "$(BLUE)Cleaning Lua cache...$(NC)\n"
	@rm -rf "$(NVIM_CACHE)/nvim" "$(NVIM_STATE)/nvim/shada"
	@printf "$(GREEN)✓$(NC) Cache cleared\n"
