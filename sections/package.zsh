#
# Package
#
# Current package version.
# These package managers supported:
#   * NPM
#   * Setuptools/Python

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

SPACESHIP_PACKAGE_SHOW="${SPACESHIP_PACKAGE_SHOW=true}"
SPACESHIP_PACKAGE_PREFIX="${SPACESHIP_PACKAGE_PREFIX="is "}"
SPACESHIP_PACKAGE_SUFFIX="${SPACESHIP_PACKAGE_SUFFIX="$SPACESHIP_PROMPT_DEFAULT_SUFFIX"}"
SPACESHIP_PACKAGE_SYMBOL="${SPACESHIP_PACKAGE_SYMBOL="📦 "}"
SPACESHIP_PACKAGE_COLOR="${SPACESHIP_PACKAGE_COLOR="red"}"

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------
spaceship::pypkg_detect() {
  # Options for impl. https://packaging.python.org/guides/single-sourcing-package-version/
  [[ -f setup.py ]] || return

  python3 $SPACESHIP_ROOT/sections/package_helper.py
}

spaceship_package() {
  [[ $SPACESHIP_PACKAGE_SHOW == false ]] && return

  [[ -f setup.py ]] && local package_version=$(spaceship::pypkg_detect)

  # Show package version only when repository is a package
  # @todo: add more package managers

  # spaceship::exists npm || return
  # Grep and cut out package version
  [[ -f package.json ]] && local package_version=$(grep -E '"version": "v?([0-9]+\.){1,}' package.json | cut -d\" -f4 2> /dev/null)
  [[ -z $package_version ]] && return

  spaceship::section \
    "$SPACESHIP_PACKAGE_COLOR" \
    "$SPACESHIP_PACKAGE_PREFIX" \
    "${SPACESHIP_PACKAGE_SYMBOL}${package_version-⚠}" \
    "$SPACESHIP_PACKAGE_SUFFIX"
}
