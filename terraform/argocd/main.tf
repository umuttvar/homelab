resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "10.9.4"
  namespace        = "argocd"
  create_namespace = true

  values = [file("${path.module}/values.yaml")]
}

resource "helm_release" "root_app" {
  name       = "root-app"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-apps"
  version    = "2.0.7"
  namespace  = "argocd"

  values     = [file("${path.module}/root-app-values.yaml")]
  depends_on = [helm_release.argocd]

}