resource "kubernetes_namespace_v1" "datadog" {
  metadata {
    name = var.datadog_namespace
  }
}

resource "kubernetes_secret_v1" "datadog" {
  metadata {
    name      = "datadog-secret"
    namespace = var.datadog_namespace
  }

  type = "Opaque"

  data = {
    "api-key" = var.datadog_api_key
  }
}

resource "helm_release" "datadog" {
  name       = "datadog"
  repository = "https://helm.datadoghq.com"
  chart      = "datadog"
  namespace  = var.datadog_namespace

  set = [
    {
      name  = "datadog.site"
      value = var.datadog_site
    },
    {
      name  = "datadog.clusterName"
      value = var.datadog_cluster_name
    },
    {
      name  = "datadog.apiKeyExistingSecret"
      value = "datadog-secret"
    },
    {
      name  = "datadog.apm.enabled"
      value = "true"
    },
    {
      name  = "clusterAgent.enabled"
      value = "true"
    },
    {
      name  = "datadog.logs.enabled"
      value = "true"
    },
    {
      name  = "datadog.logs.containerCollectAll"
      value = "true"
    },
  ]
}