resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = "kube-system"
  version    = "3.12.1"

  wait            = true
  timeout         = 100
  atomic          = false
  cleanup_on_fail = false

   values = [
    yamlencode({
      args = [
        "--kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname",
        "--metric-resolution=15s",
        "--kubelet-insecure-tls"
      ]
    })
  ]

  depends_on = [aws_eks_node_group.main]
}