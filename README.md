# Lab 1 Terraform

## Projektöversikt
Det här projektet provisionerar en härdad Ubuntu-VM i Google Cloud med Terraform. Konfigurationen skapar en Compute Engine-instans (`e2-micro`), applicerar en daglig snapshots-policy för backup med 7 dagars retention och kör ett startup-script som installerar och aktiverar grundläggande säkerhetskontroller.

## Köra lokalt
Förutsättningar: Terraform CLI installerat och GCP-autentisering konfigurerad.

```bash
terraform init
terraform plan
terraform apply
```

## CI Pipeline (GitHub Actions)
Workflow: `Terraform CI`

- `lint`: `terraform fmt -check -recursive`
- `security`: Trivy IaC scan
- `validate`: `terraform init -backend=false` + `terraform validate`

### Screenshot - pipeline (grön)
Lägg in screenshot här efter inlämning/uppdatering:

![Pipeline Success](docs/screenshots/pipeline-success.png)

## GCP VM
Den skapade VM:n heter `${student_id}-lab1-vm` i zon `europe-north1-a`.

### Screenshot - VM i GCP Console
Lägg in screenshot här efter att VM skapats:

![GCP VM](docs/screenshots/gcp-vm.png)

## Blocker vid VM-skapande
Status per 2026-03-11: `terraform apply` stoppas av GCP IAM `403 Forbidden` i projekt `chas-devsecops-2026`.

Saknade rättigheter enligt felmeddelandet:
- `compute.instances.create`
- `compute.disks.create`
- `compute.subnetworks.use`
- `compute.subnetworks.useExternalIp`
- `compute.instances.setMetadata`
- `compute.instances.setTags`
- `compute.instances.setLabels`
- `compute.resourcePolicies.create`

Slutsats: Terraform-konfigurationen validerar och planerar korrekt, men VM-resursen kan inte provisioneras förrän nödvändiga IAM-roller är tilldelade.

## Säkerhetsbeslut
- `ufw`: aktiveras för att default-neka inkommande trafik och minimera attackytan.
- `fail2ban`: skyddar mot brute-force genom att blockera upprepade misslyckade inloggningar.
- `unattended-upgrades`: automatiska säkerhetsuppdateringar för att minska patch-fönstret.
- Snapshot policy: dagliga snapshots med retention ger återställningsmöjlighet vid incidenter eller fel.
