# SOAT FASE 03 - Infra

_Tech challenge_ da pós tech em arquitetura de software - FIAP Fase 3

# Alunos

- Felipe
    - RM: `365154`
    - discord: `felipeoli7eira`
    - LinkedIn: [@felipeoli7eira](https://www.linkedin.com/in/felipeoli7eira)
- Nicolas
    - RM: `365746`
    - discord: `nic_hcm`
    - LinkedIn: [@Nicolas Martins](https://www.linkedin.com/in/nicolas-henrique/)
- William
    - RM: `365973`
    - discord: `wllsistemas`
    - LinkedIn: [@William Francisco Leite](https://www.linkedin.com/in/william-francisco-leite-9b3ba9269/?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app)

# Material
- [Vídeo de apresentação](https://www.youtube.com/watch?v=POC_FaWt39E)
- [Documento de entrega - PDF](https://drive.google.com/file/d/1Xl_8YgZHRIELfM3yCWjbswp4tD7Gxoin/view?usp=drive_link)

# Sobre o projeto
Este projeto foi desenvolvido com [Laravel](https://laravel.com), [nginx](https://nginx.org) e [postgresql](https://www.postgresql.org) e por volta dessas 3 tecnologias, está o [docker](https://www.docker.com)/[docker compose](https://docs.docker.com/compose) e toda uma arquitetura com kubernetes, utilizando terraform para provisionamento de rescursos na AWS.

# Documentação

## 🚀 Pipeline GitHub Actions

#### 1. Aprovação de um PR para merge com a `main`
No branch `main` são efetuados merges mediante aprovação dos PRs.

#### 2. Execução da Pipeline CI
Ao executar o merge, é disparada a pipeline `infra.yaml` que executa:
- Provisionamento do Cluster na AWS
- Provisionamento dos Nodes dentro do Cluster
- Cria as regras para HPA
- Cria recurso para o Datadog
- Persiste o estado do terraform no bucket S3

## 🚀 State Terraform no Bucket S3
Para persistência do estado dos recursos provisionados via terraform, é utilizado um repositório Bucket S3 na AWS, onde os arquivos de persistência foram separados por repositório (infra, database e application).

## 🚀 Armazenamento EBS
Para o armazenamento utilizado para o banco de dados PostgreSQL persistir os dados, é necessário que ao criar o cluster o terraform já provisione o armazenamento de volumes no Kubernetes com Amazon EBS.

## 📈 Monitoramento Datadog
No momento do provisionamento do cluster é criado também o recurso para monitoramento utilizando a integração via API com a ferramenta **datadog**, onde inicialmente são setados alguns parâmetros via terraform para coletada de logs.

## 🚀 HPA (HorizontalPodAutoscaler)
Escrevemos um manifesto kubernetes `13-hpa-nginx.yaml` para automatizar o escalonamento horizontal dos pods **lab-soat-nginx** com base em métricas de utilização.

| Métrica | Valor | Und Medida |
|---|---|---|
| Utilização de CPU | 15 | % |
|Média de Consumo Memória RAM| 15 | MegaBytes |

O HPA garante que o Deployment **lab-soat-nginx** tenha entre 1 e 10 pods, escalando para cima se a utilização média da CPU exceder 15% (em relação ao request do pod) ou se o consumo médio de memória exceder 15Mi. O objetivo é manter a performance da aplicação otimizada, adicionando ou removendo pods conforme a demanda, sem intervenção manual
