# Helm Pkl Plugin

Wrapper around helm to use [pkl](https://pkl-lang.org/main/current/index.html) instead of yaml for values

```sh
helm pkl [command] [--pkl-template TEMPLATE] [flags]
```

## Requirements

* pkl 0.28.2

## Install

```sh
helm plugin install https://github.com/hunterwilkins2/helm-pkl
```

## Usage

```sh
Usage:
  helm pkl [command] [--pkl-template TEMPLATE] [flags]

Available commands:
  install     install a chart
  lint        examine a chart for possible issues
  template    locally render templates
  upgrade     upgrade a release

Flags:
      --values-file string		save compliled YAML output from pkl to file
      --burst-limit int                 client-side default throttling limit (default 100)
      --debug                           enable verbose output
  -h, --help                            help for helm
      --kube-apiserver string           the address and the port for the Kubernetes API server
      --kube-as-group stringArray       group to impersonate for the operation, this flag can be repeated to specify multiple groups.
      --kube-as-user string             username to impersonate for the operation
      --kube-ca-file string             the certificate authority file for the Kubernetes API server connection
      --kube-context string             name of the kubeconfig context to use
      --kube-insecure-skip-tls-verify   if true, the Kubernetes API server's certificate will not be checked for validity. This will make your HTTPS connections insecure
      --kube-tls-server-name string     server name to use for Kubernetes API server certificate validation. If it is not provided, the hostname used to contact the server is used
      --kube-token string               bearer token used for authentication
      --kubeconfig string               path to the kubeconfig file
  -n, --namespace string                namespace scope for this request (default "default")
      --qps float32                     queries per second used when communicating with the Kubernetes API, not including bursting
      --registry-config string          path to the registry config file 
      --repository-cache string         path to the directory containing cached repository indexes 
      --repository-config string        path to the file containing repository names and URLs 
```a

