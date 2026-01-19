# holbertonschool.com — Passive Recon Report (Shodan)

**Target:** holbertonschool.com  
**Scope:** Domain və subdomainlər (passive recon)  
**Source of Truth:** Shodan (DNSDB + Internet exposure), əlavə kontekst üçün DNS record-lar  
**Date:** 2026-01-19  
**Analyst:** <adını yaz>

---

## 1) Məqsəd və Tapşırıq Tələbi

Bu hesabatın məqsədi Shodan istifadə etməklə holbertonschool.com domeni barədə mümkün qədər çox məlumat toplamaqdır:

1. **holbertonschool.com domeninə aid bütün IP range-ləri toplamaq**
2. **Bütün subdomainlər üzrə istifadə olunan texnologiya və frameworkləri müəyyən etmək**
3. Nəticələri **Markdown formatında** hesabat şəklində təqdim etmək

---

## 2) Metodologiya (Shodan)

### 2.1. Shodan DNSDB ilə subdomain və IP çıxarışı
Shodan DNSDB domen/subdomain → A record (IP) əlaqələrini verir.

**Shodan CLI:**
- Subdomainlər:
  - `shodan domain holbertonschool.com`
- Hostname üzrə nəticələr (HTTP/SSL banner):
  - `shodan search --fields ip_str,port,hostnames,org,isp,product,version "hostname:holbertonschool.com"`
  - `shodan search --fields ip_str,port,hostnames,org,isp,product,version "hostname:*.holbertonschool.com"`

**Shodan Web (search filters):**
- `hostname:holbertonschool.com`
- `hostname:*.holbertonschool.com`
- `ssl.cert.subject.cn:holbertonschool.com`
- `ssl:"holbertonschool.com"` (sertifikat mətnindən tapmaq üçün)
- `http.title:"Holberton"` (banner/title əsasında)

Qeyd: Shodan query sintaksisini düzgün qurmaq üçün Shodan-ın “Search Query Fundamentals” və “Advanced Search” sənədlərinə istinad et. :contentReference[oaicite:1]{index=1}

---

## 3) Tapıntılar (Findings)

### 3.1. Domenə aid IP-lər və IP range-lər

#### 3.1.1. Root domain (holbertonschool.com) A record IP-ləri
DNS səviyyəsində holbertonschool.com üçün tipik olaraq 2 A record görünür:

- `75.2.70.75` (IPv4 /32)
- `99.83.190.102` (IPv4 /32)

Bu IP-lər Webflow hostinqi üçün geniş istifadə olunan A record-lardır (Webflow root domain yönləndirməsi). :contentReference[oaicite:2]{index=2}

> **IP range təqdimatı (tapşırıq tələbinə uyğun):**
- `75.2.70.75/32`
- `99.83.190.102/32`

#### 3.1.2. Subdomainlər üzrə IP-lər (Shodan DNSDB nəticələrindən doldur)
Aşağıdakı cədvəli `shodan domain holbertonschool.com` və `hostname:*.holbertonschool.com` nəticələrinə əsasən doldur:

| Subdomain | Resolved IP | IP Range | Qeyd |
|---|---:|---:|---|
| www.holbertonschool.com | <...> | <...> | <...> |
| api.holbertonschool.com | <...> | <...> | <...> |
| ... | ... | ... | ... |

> **Qayda:** Eyni provider/AS daxilində çox IP çıxırsa, onları CIDR-ə yığ:
- Məsələn: `X.Y.Z.0/24` kimi (əgər həqiqətən eyni range-dirsə)
- Əks halda /32-lər şəklində saxla

---

### 3.2. E-poçt infrastrukturu (MX + TXT konteksti)

#### 3.2.1. MX (Mail Exchanger)
MX record-lar Google Workspace/Gmail infrastrukturu ilə uyğun görünür (aspmx.l.google.com və alt*.aspmx.l.google.com).

#### 3.2.2. TXT (Verification + SPF)
TXT record-larda adətən bu tip məlumatlar olur:
- Google/Microsoft/Apple kimi servislər üçün domain verification
- SPF policy (mailgun.org, spf.google.com və s.)

> Qeyd: TXT/SPF, subdomainlərin texnologiyasını birbaşa deməsə də,
istifadə olunan SaaS ekosistemini göstərir (Mailgun, Zendesk, Mailchimp və s.).

---

### 3.3. Texnologiyalar və frameworklər (Shodan banner analizinə əsasən)

Bu bölməni Shodan host nəticələrindən (ports + banners) çıxarıb doldur:

#### 3.3.1. Web server / reverse proxy
- **Müşahidə:** `<Server header / product>`  
- **Sübut (Shodan banner):** `<ip:port banner excerpt>`

#### 3.3.2. Frontend platform / CMS
- **Müşahidə:** Webflow ehtimalı yüksəkdir (A record IP-ləri Webflow nümunələri ilə üst-üstə düşür). :contentReference[oaicite:3]{index=3}  
- **Shodan təsdiqi:** `http.favicon.hash`, `http.html`, `http.headers` kimi banner sahələrində Webflow izləri axtar.

#### 3.3.3. TLS/Certificate göstəriciləri
- Sertifikat CN/SAN-lar subdomainləri ifşa edə bilər:
  - `ssl.cert.subject.cn`
  - `ssl.cert.subject.altname`

#### 3.3.4. Subdomain → Tech mapping (doldurulacaq cədvəl)
| Subdomain | IP:Port | Tech/Product | Version | Evidence (banner field) |
|---|---|---|---|---|
| <...> | <...> | <...> | <...> | <...> |

---

## 4) Risk/Exposure Xülasəsi (High-level)

Bu hissə tapıntılardan sonra yazılmalıdır:

- **Externally exposed services:** (80/443/22/3389 və s. portlar)
- **Outdated software:** (Shodan `product` + `version` ilə)
- **Misconfig indicators:** (default pages, debug endpoints, admin panellər)
- **Email security posture:** SPF/DKIM/DMARC vəziyyəti (TXT üzərindən)

---

## 5) Əlavə: Təkrarolunan Shodan sorğu dəsti (Copy/Paste)

**Subdomain list:**
- `shodan domain holbertonschool.com`

**All hosts for root + subdomains:**
- `shodan search "hostname:holbertonschool.com"`
- `shodan search "hostname:*.holbertonschool.com"`

**Only web ports:**
- `shodan search "hostname:*.holbertonschool.com port:80,443"`

**TLS-based discovery:**
- `shodan search "ssl:\"holbertonschool.com\""`

---

## 6) Nəticə

Bu hesabat Shodan nəticələrinə əsasən holbertonschool.com domeninin:
- IP-lərini / IP range-lərini,
- subdomain ekosistemini,
- texnologiya stack-ını,
- internetə açıq xidmətlərini

xəritələndirmək üçün hazırlanmışdır.

> Növbəti addım: Subdomain cədvəli və Tech mapping cədvəlini Shodan export nəticələri ilə tamamla.
