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
![Pipeline Success](docs/screenshots/pipeline-success.png)

## GCP VM
Den skapade VM:n heter `${student_id}-lab1-vm` i zon `europe-north1-b`.

### Screenshot - VM i GCP Console
![GCP VM](docs/screenshots/gcp-vm.png)

## Säkerhetsbeslut
- `ufw`: aktiveras för att default-neka inkommande trafik och minimera attackytan.
- `fail2ban`: skyddar mot brute-force genom att blockera upprepade misslyckade inloggningar.
- `unattended-upgrades`: automatiska säkerhetsuppdateringar för att minska patch-fönstret.
- Snapshot policy: dagliga snapshots med retention ger återställningsmöjlighet vid incidenter eller fel.
