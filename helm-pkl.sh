#!/bin/sh

function usage_missing_command() {
  printf 'Usage:\n'
  printf '  helm pkl [command] [--pkl-template TEMPLATE] [flags]\n\n'
  printf 'Available commands:\n'
  helm --help | 
    grep -e '^\s\sinstall' -e '^\s\supgrade' -e '^\s\stemplate' -e '^\s\slint'
  printf '\n'
  helm --help | 
    sed -n '/^Flags:$/,$p' |
    awk 'NR==2{print "      --values-file string\t\tsave compliled YAML output from pkl to file"}1' |
    head -n -1
  exit 1
}

function usage_command() {
  printf 'Usage:\n'
  printf '  helm pkl %s [--pkl-template TEMPLATE] [NAME] [CHART] [flags]\n\n' "$1"
  helm "$1" --help | 
    sed -n '/^Flags:$/,$p' |
    awk 'NR==2{print "      --values-file string\t\t\t   save compliled YAML output from pkl to file"}1'
  printf "\n"
  exit 1
}

case "$1" in
  install|upgrade|template|lint) helm_command="$1"; shift;;
  *) usage_missing_command;;
esac

while [ $# -gt 0 ]; do
  case "$1" in
    --pkl-template) pkl_file="$2"; shift; shift;;
    --values-file) values_file="$2"; shift; shift;;
    --help|-h) usage_command "$helm_command";;
    *) helm_args+="$1 "; shift;;
  esac
done

for helm_env in $(printenv | grep 'HELM'); do
  IFS="=" read -r helm_var helm_value <<< "$helm_env"
  if [[ "$helm_value" != "false" && "$helm_value" != "" ]]; then
    case "$helm_var" in
      HELM_BURST_LIMIT) helm_args+="--burst-limit $helm_value ";;
      HELM_DEBUG) helm_args+="--debug ";;
      HELM_KUBEAPISERVER) helm_args+="--kube-apiserver $helm_value ";;
      HELM_KUBEASGROUPS) helm_args+="--kube-as-group $helm_value ";;
      HELM_KUBEASUSER) helm_args+="--kube-as-user $helm_value ";;
      HELM_KUBECAFILE) helm_args+="--kube-ca-file $helm_value ";;
      HELM_KUBECONTEXT) helm_args+="--kube-context $helm_value ";;
      HELM_KUBEINSECURE_SKIP_TLS_VERIFY) helm_args+="--kube-insecure-skip-tls-verify ";;
      HELM_KUBETLS_SERVER_NAME) helm_args+="--kube-tls-server-name $helm_value ";;
      HELM_KUBETOKEN) helm_args+="--kube-token $helm_value ";;
      HELM_KUBECONFIG) helm_args+="--kubeconfig $helm_value ";;
      HELM_NAMESPACE) helm_args+="--namespace $helm_value ";;
      HELM_QPS) helm_args+="--qps $helm_value ";;
      HELM_REGISTRY_CONFIG) helm_args+="--registry-config $helm_value ";;
      HELM_REPOSITORY_CACHE) helm_args+="--repository-cache $helm_value ";;
      HELM_REPOSITORY_CONFIG) helm_args+="--repository-config $helm_value ";;
    esac
  fi
done

if [[ -z "$pkl_file" ]]; then
  usage_command "$helm_command"
fi

if [[ -z "$values_file" ]]; then
  values_file=$(mktemp)
  trap "rm -f $values_file" 0 2 3 15
fi

pkl eval \
  --format=yaml \
  --output-path="$values_file" \
  "$pkl_file" || exit 1

helm "$helm_command" \
  $helm_args \
  --values "$values_file" 

