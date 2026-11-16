set -gx FZF_DEFAULT_OPTS "\
  --color=fg:#{{ onSurface.hex }},bg:#{{ surface.hex }},hl:#{{ primary.hex }} \
  --color=fg+:#{{ onSurface.hex }},bg+:#{{ surfaceVariant.hex }},hl+:#{{ secondary.hex }} \
  --color=info:#{{ tertiary.hex }},prompt:#{{ primary.hex }},pointer:#{{ secondary.hex }} \
  --color=marker:#{{ tertiary.hex }},spinner:#{{ secondary.hex }},header:#{{ onSurfaceVariant.hex }} \
  --color=border:#{{ outline.hex }},gutter:#{{ surface.hex }}"