
GENESIS_REMOTE="https://github.com/open-power-ref-design/cluster-genesis.git"
GENESIS_LOCAL="genesis"
GENESIS_COMMIT="730985b4dce2f3fee94938651d67f90df387b9c9" # I.e. "3.2"
GENESIS_VERSION="0.9"

./setup_git_repo.sh "${GENESIS_REMOTE}" "${GENESIS_LOCAL}" "${GENESIS_COMMIT}"

