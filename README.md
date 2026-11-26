# Puidutööstus MES – prototüüp

Klikitav MES-i prototüüp Puidutööstus OÜ tootmistellimuse põhivoole (kasutusmallid K01–K08). Kõik andmed on näidisandmed brauseri mälus; serverit ega andmebaasi ei ole. UI töötab pordil **8080**.

## Käivitamine Dockeriga

```bash
docker build -t puit-demo .
docker run -d --name puit-demo --restart unless-stopped -p 8080:8080 puit-demo
```

Ava brauseris `http://localhost:8080` (või serveri avalik IP). Tervisekontroll: `http://<host>:8080/healthz`.

## Oracle Cloud (OCI) Compute instants

1. **Paigalda Docker** (Oracle Linux 8/9):
   ```bash
   sudo dnf install -y dnf-utils
   sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
   sudo dnf install -y docker-ce docker-ce-cli containerd.io
   sudo systemctl enable --now docker
   sudo usermod -aG docker $USER   # logi välja ja sisse
   ```
   Ubuntu puhul: `sudo apt-get update && sudo apt-get install -y docker.io && sudo systemctl enable --now docker`.

2. **Klooni ja käivita:**
   ```bash
   git clone https://github.com/alekal1/puit_demo.git
   cd puit_demo
   docker build -t puit-demo .
   docker run -d --name puit-demo --restart unless-stopped -p 8080:8080 puit-demo
   ```

3. **Ava port 8080 OCI võrgus:** Networking → Virtual Cloud Networks → sinu VCN → Security Lists (või instantsi Network Security Group) → *Add Ingress Rule*: Source CIDR `0.0.0.0/0`, IP Protocol TCP, Destination Port `8080`.

4. **Ava port 8080 instantsi tulemüüris:**
   - Oracle Linux:
     ```bash
     sudo firewall-cmd --permanent --add-port=8080/tcp
     sudo firewall-cmd --reload
     ```
   - Ubuntu (OCI image kasutab iptables reegleid):
     ```bash
     sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 8080 -j ACCEPT
     sudo netfilter-persistent save
     ```

5. Ava `http://<instantsi-avalik-IP>:8080`.

Image `nginx:alpine` on multi-arch, seega töötab nii x86 kui ka Ampere (arm64, Always Free) instantsidel.

## Uuendamine

```bash
git pull
docker build -t puit-demo .
docker rm -f puit-demo
docker run -d --name puit-demo --restart unless-stopped -p 8080:8080 puit-demo
```
