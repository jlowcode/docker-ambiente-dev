#!/bin/bash

set -e

echo "Atualizando repositórios devcett"

update_repo() {
  local repo_url=$1
  local repo_path=$2
  local branch=$3

  # Só continua se a pasta existir
  if [ ! -d "$repo_path" ]; then
    echo "A pasta $repo_path não existe. Nada será feito."
    return
  fi

  # Se branch não foi passada, tenta "dev", senão cai pra master/main
  if [ -z "$branch" ]; then
    echo "Nenhuma branch informada. Tentando usar 'dev'..."
    if git ls-remote --exit-code --heads "$repo_url" dev &>/dev/null; then
      branch="dev"
    elif git ls-remote --exit-code --heads "$repo_url" master &>/dev/null; then
      branch="master"
    elif git ls-remote --exit-code --heads "$repo_url" main &>/dev/null; then
      branch="main"
    else
      echo "Nenhuma das branches 'dev', 'master' ou 'main' existe no repositório!"
      return
    fi
  fi

  if [ ! -d "$repo_path/.git" ]; then
    echo "Pasta $repo_path existe mas não é um repositório Git. Removendo para clonar corretamente..."
    rm -rf "$repo_path"
    echo "Clonando branch $branch de $repo_url em $repo_path..."
    git clone -b "$branch" "$repo_url" "$repo_path"
  else
    echo "Repositório em $repo_path já existe. Verificando alterações locais..."
    cd "$repo_path" || return

    if [ -n "$(git status --porcelain)" ]; then
      echo "Existem alterações locais não commitadas em $repo_path. Faça commit ou stash antes."
      return
    fi

    echo "Atualizando branch $branch em $repo_path..."
    git fetch origin "$branch"
    git checkout "$branch" || git checkout -b "$branch" "origin/$branch"
    git pull origin "$branch"
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
update_repo "https://github.com/jlowcode/action.git" "/var/www/html/plugins/fabrik_list/action"
update_repo "https://github.com/jlowcode/autocompletesearch.git" "/var/www/html/plugins/fabrik_list/autocompletesearch"
update_repo "https://github.com/jlowcode/Calc.git" "/var/www/html/plugins/fabrik_element/calc"
update_repo "https://github.com/jlowcode/Comment.git" "/var/www/html/plugins/fabrik_form/comment"
update_repo "https://github.com/jlowcode/databasejoin.git" "/var/www/html/plugins/fabrik_element/databasejoin"
update_repo "https://github.com/jlowcode/Date.git" "/var/www/html/plugins/fabrik_element/date"
update_repo "https://github.com/jlowcode/delete_tree_node.git" "/var/www/html/plugins/fabrik_list/delete_tree_node"
update_repo "https://github.com/jlowcode/drag_and_drop_file.git" "/var/www/html/plugins/fabrik_list/drag_and_drop_file"
update_repo "https://github.com/jlowcode/dropdown.git" "/var/www/html/plugins/fabrik_element/dropdown"
update_repo "https://github.com/jlowcode/easyadmin.git" "/var/www/html/plugins/fabrik_list/easyadmin"
update_repo "https://github.com/jlowcode/easyuserlogin.git" "/var/www/html/plugins/system/easyuserlogin"
update_repo "https://github.com/jlowcode/field.git" "/var/www/html/plugins/fabrik_element/field"
update_repo "https://github.com/jlowcode/fileupload.git" "/var/www/html/plugins/fabrik_element/fileupload"
update_repo "https://github.com/jlowcode/hits.git" "/var/www/html/plugins/fabrik_element/hits"
update_repo "https://github.com/jlowcode/Homescreen.git" "/var/www/html/plugins/fabrik_visualization/homescreen"
update_repo "https://github.com/jlowcode/jlowcode-sites-form.git" "plugins/fabrik_form/jlowcode_sites"
update_repo "https://github.com/jlowcode/lib_fabrik_fabrik.git" "/var/www/html/libraries/fabrik/fabrik"
update_repo "https://github.com/jlowcode/list_cloner_admin.git" "/var/www/html/plugins/fabrik_form/list_cloner_admin"
update_repo "https://github.com/jlowcode/Metadata-form.git" "/var/www/html/plugins/fabrik_form/metadata"
update_repo "https://github.com/jlowcode/Metadata-lista.git" "/var/www/html/plugins/fabrik_lista/metadata"
update_repo "https://github.com/jlowcode/Metadata-system.git" "/var/www/html/plugins/system/metadata"
update_repo "https://github.com/jlowcode/mod_workflow_notification.git" "/var/www/html/modules/mod_workflow_notification"
update_repo "https://github.com/jlowcode/Ordering.git" "/var/www/html/plugins/fabrik_element/ordering"
update_repo "https://github.com/jlowcode/Rating.git" "/var/www/html/plugins/fabrik_element/rating"
update_repo "https://github.com/jlowcode/Textarea.git" "/var/www/html/plugins/fabrik_element/textarea"
update_repo "https://github.com/jlowcode/Thumbs.git" "/var/www/html/plugins/fabrik_element/thumbs"
update_repo "https://github.com/jlowcode/User.git" "/var/www/html/plugins/fabrik_element/user/user.php"
update_repo "https://github.com/jlowcode/workflow.git" "/var/www/html/plugins/fabrik_form/workflow"
update_repo "https://github.com/jlowcode/workflow_request.git" "/var/www/html/plugins/fabrik_list/workflow_request"
update_repo "https://github.com/jlowcode/Youtube.git" "/var/www/html/plugins/fabrik_element/youtube/youtube.php"


# Repositório com_fabrik_4.0 (clonar subpastas específicas)
FABRIK_REPO="https://github.com/jlowcode/com_fabrik_4.0.git"
clone_subdir "$FABRIK_REPO" "site" "/var/www/html/components/com_fabrik"
clone_subdir "$FABRIK_REPO" "admin" "/var/www/html/administrator/components/com_fabrik"
clone_subdir "$FABRIK_REPO" "media/com_fabrik" "/var/www/html/media/com_fabrik"

echo "Todos os repositórios foram atualizados com sucesso."

# Inicia o Apache
echo "Iniciando Apache..."
exec apache2-foreground
