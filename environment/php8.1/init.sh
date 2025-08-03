#!/bin/bash

set -e

echo "Atualizando repositórios devcett"

update_repo() {
  local repo_url=$1
  local repo_path=$2

  if [ ! -d "$repo_path/.git" ]; then
    if [ -d "$repo_path" ]; then
      echo "Pasta $repo_path existe mas não é um repositório Git. Removendo para clonar corretamente..."
      rm -rf "$repo_path"
    fi
    echo "Clonando $repo_url em $repo_path..."
    git clone "$repo_url" "$repo_path"
  else
    echo "Repositório em $repo_path já existe. Verificando alterações locais..."
    cd "$repo_path"

    if [ -n "$(git status --porcelain)" ]; then
      echo "Existem alterações locais não commitadas em $repo_path. Faça commit ou stash antes."
      return
    fi

    echo "Atualizando repositório $repo_path..."
    git pull
  fi
}

clone_subdir() {
  local repo_url=$1
  local subdir_path=$2
  local target_path=$3

  TMP_CLONE=$(mktemp -d)
  echo "Clonando temporariamente $repo_url..."
  git clone --depth 1 "$repo_url" "$TMP_CLONE"

  echo "Copiando $subdir_path para $target_path"
  mkdir -p "$(dirname "$target_path")"
  rm -rf "$target_path"
  cp -r "$TMP_CLONE/$subdir_path" "$target_path"

  rm -rf "$TMP_CLONE"
}

# Plugins e módulos independentes
update_repo "https://github.com/jlowcode/easyadmin.git" "/var/www/html/plugins/fabrik_list/easyadmin"
update_repo "https://github.com/jlowcode/workflow.git" "/var/www/html/plugins/fabrik_form/workflow"
update_repo "https://github.com/jlowcode/databasejoin.git" "/var/www/html/plugins/fabrik_element/databasejoin"
update_repo "https://github.com/jlowcode/Metadata-form.git" "/var/www/html/plugins/fabrik_form/metadata"
update_repo "https://github.com/jlowcode/Metadata-system.git" "/var/www/html/plugins/system/metadata"
update_repo "https://github.com/jlowcode/mod_workflow_notification.git" "/var/www/html/modules/mod_workflow_notification"
update_repo "https://github.com/jlowcode/lib_fabrik_fabrik.git" "/var/www/html/libraries/fabrik/fabrik"

# Repositório com_fabrik_4.0 (clonar subpastas específicas)
FABRIK_REPO="https://github.com/jlowcode/com_fabrik_4.0.git"
clone_subdir "$FABRIK_REPO" "site" "/var/www/html/components/com_fabrik"
clone_subdir "$FABRIK_REPO" "admin" "/var/www/html/administrator/components/com_fabrik"
clone_subdir "$FABRIK_REPO" "media/com_fabrik" "/var/www/html/media/com_fabrik"

echo "Todos os repositórios foram atualizados com sucesso."

# Inicia o Apache
echo "Iniciando Apache..."
exec apache2-foreground
