resource "flux_bootstrap_git" "this" {
  path = "kubernetes/clusters/golem"
  components = ["source-controller", "kustomize-controller", "helm-controller"]
}
